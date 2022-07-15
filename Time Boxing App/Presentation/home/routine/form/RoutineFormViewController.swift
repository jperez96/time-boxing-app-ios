//
//  RoutineFormViewController.swift
//  Time Boxing App
//
//  Created by Julio Perez on 2/07/22.
//

import UIKit

protocol RoutineFormDelegate {
    func registerRoutine(_ routine: Routine, _ isToUpdate: Bool)
}

class RoutineFormViewController: UIViewController {

    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var addRoutineOutlet: BaseButton!
    @IBOutlet weak var addTaskButtonOutlet: BaseButton!
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var createRoutineButton: BaseButton!
    @IBOutlet weak var closeFormButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var mondayButton: BaseButton!
    @IBOutlet weak var titleRoutineTextField: BaseTextField!
    
    @IBOutlet weak var containerEmptyTask: UIStackView!
    @IBOutlet var weekDaysOutlet: [BaseButton]!
    
    private var routine : Routine = Routine(id: UUID.init(), name: "", tasks: [] )
    private var tasks: [Task] = []
    private var weekDay = 2
    private var isToUpdate = false
    
    var delegate: RoutineFormDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpStyle()
    }
    
    private func setCurrentButton(_ button : BaseButton){
        weekDaysOutlet.forEach { btn in
            btn.backgroundColor = btn == button ? .fifth : .primary
        }
    }
    
    private func setUpStyle(){
        createRoutineButton.setStyle()
        closeFormButton.setStyle()
        addTaskButtonOutlet.setStyle()
        nameTextField.setStyle()
        addRoutineOutlet.setStyle()
        weekDaysOutlet.forEach { btn in
            btn.setStyle()
        }
        setCurrentButton(mondayButton)
        if isToUpdate {
            setTitleRotine(routine.name)
        }
    }
    
    private func setUpTableView(){
        self.routineTableView.dataSource = self
        self.routineTableView.delegate = self
        self.routineTableView.reloadData()
        self.routineTableView.registerTaskCell()
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    
    private func setTaskOnView(_ tasks: [Task]){
        self.tasks = sortByDate(tasks)
        self.containerEmptyTask.isHidden = !self.tasks.isEmpty
        self.routineTableView.isHidden = self.tasks.isEmpty
        routineTableView.reloadData()
    }
    
    private func setTaskToEdit(_ task: Task){
        var list : [Task] = []
        self.routine.tasks.forEach { obj in
            if(task.id == obj.id) {
                list.append(task)
            } else {
                list.append(obj)
            }
        }
        self.routine.tasks = list
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    
    private func sortByDate(_ tasks : [Task]) -> [Task] {
        return tasks.sorted { a, b in
            a.initDate < b.finishDate
        }
    }

    func setupForm(routine: Routine?){
        guard let routine = routine else {
            return
        }
        self.routine = routine
        self.isToUpdate = true
    }

    @IBAction func onEditNameTextField(_ sender: UITextField) {     
        guard let name = sender.text else {
            return
        }
        setTitleRotine(name)
    }
    
    private func setTitleRotine(_ title: String){
        if self.validateName(title) {
            setAnimationTransition()
        } else {
            self.addRoutineOutlet.isHidden = true
        }
        self.titleRoutineTextField.text = title
        self.routine.name = title
    }
    
    private func setAnimationTransition(){
        UIView.transition(with: self.addRoutineOutlet, duration: 0.5, options: .transitionCrossDissolve) {
            self.addRoutineOutlet.isHidden = false
        }
    }
    

    @IBAction func onTouchAddRoutineButton(_ sender: UIButton) {
        delegate?.registerRoutine(self.routine, isToUpdate)
        dismiss(animated: true)
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        openTaskForm()
    }
    
    private func openTaskForm(_ task: Task? = nil){
        if let vc = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "TaskFormVC") as? TaskFormViewController {
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            vc.setFormTaskRoutine(self.weekDay)
            if task.isNotNull() {
                vc.setFormToUpdate(task: task!)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //Days
    @IBAction func mondayButton(_ sender: BaseButton) {
        weekDay = 2
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    @IBAction func tuesdayButton(_ sender: BaseButton) {
        weekDay = 3
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    @IBAction func wednesdayButton(_ sender: BaseButton) {
        weekDay = 4
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    @IBAction func thursdayButton(_ sender: BaseButton) {
        weekDay = 5
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    @IBAction func fridayButton(_ sender: BaseButton) {
        weekDay = 6
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    @IBAction func saturdayButton(_ sender: BaseButton) {
        weekDay = 7
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    @IBAction func sundayButton(_ sender: BaseButton) {
        weekDay = 1
        setCurrentButton(sender)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    
    @IBAction func onTouchHideButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func validateName(_ text : String) -> Bool{
        return text.count > 2
    }
    
    private func removeTask(_ task : Task) {
        var index = 0
        for i in 0...self.routine.tasks.count - 1{
            if (self.routine.tasks[i].id == task.id) {
                index = i
            }
        }
        self.routine.tasks.remove(at: index)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
}

extension RoutineFormViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellViewName.task.rawValue, for: indexPath) as! TaskCellTableViewCell
        cell.setData(obj: self.tasks[indexPath.row])
        return cell
    }
    
}

extension RoutineFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.removeTask(self.tasks[indexPath.row])
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
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension RoutineFormViewController: TaskFormDelegate {
    func didRegister(task: Task, toUpdate : Bool) {
        if toUpdate {
            setTaskToEdit(task)
        } else {
            self.routine.tasks.append(task)
            setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
        }
    }
}
