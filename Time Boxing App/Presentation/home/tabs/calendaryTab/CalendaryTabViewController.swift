//
//  CalendaryTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class CalendaryTabViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var calendaryView: UIView!
    @IBOutlet weak var addTaskButton: BaseButton!
    @IBOutlet weak var emptyTaskView: UIView!
    
    private var getTaskFromDate = GetTaskFromDateUseCase()
    private var removeTaskUseCase = RemoveTaskUseCase()
    private var tasks : [Task] = []
    private var tasksRoutine : [Task] = []
    private var calendar = HorizontalCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendaryView()
        initTableView()
        setStyleView()
    }
    
    private func setStyleView() {
        addTaskButton.setStyle()
    }
    
    private func initTableView(){
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.registerTaskCell()
    }
    
    @IBAction func openFormTaskButton(_ sender: UIButton) {
        openTaskForm()
    }
    
    private func openTaskForm(_ task: Task? = nil){
        if let vc = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "TaskFormVC") as? TaskFormViewController {
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            if task.isNotNull() {
                vc.setFormToUpdate(task: task!)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func initCalendaryView(){
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 5),
            calendar.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendar.rightAnchor.constraint(equalTo: view.rightAnchor),
            calendar.bottomAnchor.constraint(equalTo: taskTableView.topAnchor)
        ])
        calendar.backgroundColor = .systemBackground
        calendar.onSelectionChanged = { date in
            self.getTaskFromDate(date)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getTaskFromDate(calendar.selectedDate)
    }
    
    private func getTaskFromDate(_ date: Date){
        let _ = self.getTaskFromDate.execute(date).subscribe { response in
            guard let result = response.responseData else {
                print(response.responseMessage)
                return
            }
            self.tasks = result
            self.taskTableView.reloadData()
            self.getTaskRoutines(date)
            self.emptyTaskView.isHidden = !self.tasks.isEmpty
            self.taskTableView.isHidden = self.tasks.isEmpty
        } onFailure: { error in
            print(error)
        }
    }
    
    private func getTaskRoutines(_ date: Date){
        let weekDay = date.getWeekDay()
        let useCase = GetRoutineUseCase()
        _ = useCase.execute().subscribe(onSuccess: { response in
            guard let routines = response.responseData else {
                return
            }
            self.setTasksFromRoutines(routines, weekDay: weekDay)
        }, onFailure: { error in
            print(error)
        })
    }
    
    private func setTasksFromRoutines(_ routines: [Routine], weekDay: Int){
        var taskToAdd : [Task] = []
        for routine in routines {
            let tasksFromRoutines = Routine.getTaskByWeekDay(tasks: routine.tasks, weekDay: weekDay)
            taskToAdd.append(contentsOf: tasksFromRoutines)
        }
        self.tasks.append(contentsOf: taskToAdd)
        self.tasksRoutine = taskToAdd
        self.taskTableView.reloadData()
    }
    
    private func isTaskRoutine(_ task : Task) -> Bool {
        return self.tasksRoutine.filter { taskRoutine in
            taskRoutine.id == task.id
        }.isEmpty
    }
    
    private func registerTask(_ task: Task){
        let useCase = CreateTaskUseCase()
        _ = useCase.execute(task).subscribe { response in
            self.getTaskFromDate(self.calendar.selectedDate)
            self.syncData()
        } onFailure: { error in
            print(error)
        }
    }
    
    private func updateTask(_ task: Task){
        let useCase = UpdateTaskUseCase()
        _ = useCase.execute(task).subscribe { response in
            self.getTaskFromDate(self.calendar.selectedDate)
            self.syncData()
        } onFailure: { error in
            print(error)
        }
    }
    
    private func removeTask(_ task : Task) {
        let _ = removeTaskUseCase.execute(task).subscribe { response in
            guard let result = response.responseData else {
                print(response.responseMessage)
                return
            }
            if !result  {
                print("Fallo al borrar la tarea")
            }
            self.getTaskFromDate(self.calendar.selectedDate)
        } onFailure: { error in
          print(error)
        }
    }
    
    private func syncData() {
        let repository = AppRepository()
        repository.delegate = self
        repository.syncDataToCloud()
        return
    }
    
}


extension CalendaryTabViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellViewName.task.rawValue, for: indexPath) as! TaskCellTableViewCell
        cell.setData(obj: tasks[indexPath.row], !self.isTaskRoutine(self.tasks[indexPath.row]))
        return cell
    }
    
}

extension CalendaryTabViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            let taskToRemove = self.tasks[indexPath.row]
            self.removeTask(taskToRemove)
            completionHandler(true)
        }
        let updateAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.openTaskForm(self.tasks[indexPath.row])
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        updateAction.image = UIImage(systemName: "pencil")
        updateAction.backgroundColor = .systemOrange
        var actions : [UIContextualAction] = []
        if isTaskRoutine(self.tasks[indexPath.row]) {
            actions = [deleteAction,updateAction]
        }
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension CalendaryTabViewController : TaskFormDelegate {
    func didRegister(task: Task, toUpdate : Bool) {
        if !toUpdate {
            registerTask(task)
        } else {
            updateTask(task)
        }
    }
}

extension CalendaryTabViewController : AppRepositoryDelegate {
    func result(_ result: BaseResponse<Bool>) {
        print(result.responseMessage)
    }
}
