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
    @IBOutlet weak var addRoutineOutlet: UIButton!
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var createRoutineButton: BaseButton!
    @IBOutlet weak var closeFormButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var mondayButton: BaseButton!
    
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
        nameTextField.setStyle()
        weekDaysOutlet.forEach { btn in
            btn.setStyle()
        }
        setCurrentButton(mondayButton)
    }
    
    private func setUpTableView(){
        self.routineTableView.dataSource = self
        self.routineTableView.delegate = self
        self.routineTableView.reloadData()
        self.routineTableView.registerTaskCell()
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
    
    private func setTaskOnView(_ tasks: [Task]){
        self.tasks = tasks
        routineTableView.reloadData()
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
        self.addRoutineOutlet.isHidden = !validateName(name)
        self.routine.name = name
    }

    @IBAction func onTouchAddRoutineButton(_ sender: UIButton) {
        delegate?.registerRoutine(self.routine, isToUpdate)
        dismiss(animated: true)
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        if let vc = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "TaskFormVC") as? TaskFormViewController {
            vc.delegate = self
            vc.setFormTaskRoutine(self.weekDay)
            vc.modalPresentationStyle = .overCurrentContext
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
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension RoutineFormViewController: TaskFormDelegate {
    func didRegister(task: Task) {
        self.routine.tasks.append(task)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: self.routine.tasks, weekDay: weekDay))
    }
}
