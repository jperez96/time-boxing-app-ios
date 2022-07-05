//
//  RoutineFormViewController.swift
//  Time Boxing App
//
//  Created by Julio Perez on 2/07/22.
//

import UIKit

class RoutineFormViewController: UIViewController {

    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var addRoutineButton: UIButton!
    private var tasksWeek: [Task] = []
    private var routine : Routine?
    private var weekDay = 1
    private var isToUpdate: Bool = false
    private let taskListViewController = TaskListViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTaskListView()
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    
    private func setUpTaskListView(){
        guard let taskListView = self.taskListViewController.view else {
            return
        }
        view.addSubview(taskListView)
        taskListView.translatesAutoresizingMaskIntoConstraints = false
        addChild(self.taskListViewController)
        NSLayoutConstraint.activate([
            taskListView.topAnchor.constraint(equalTo: daysStackView.bottomAnchor, constant: 15),
            taskListView.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            taskListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTaskOnView(_ tasks: [Task]){
        taskListViewController.setNewTasks(tasks)
    }

    func setupForm(routine: Routine?){
        guard let routine = routine else {
            return
        }
        self.routine = routine
        self.isToUpdate = true
    }

    @IBAction func onEditNameTextField(_ sender: UITextField) {
        addRoutineButton.isEnabled = validateName(sender.text)
    }

    @IBAction func onTouchAddRoutineButton(_ sender: UIButton) {
        if let vc = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "TaskFormVC") as? TaskFormViewController {
            vc.delegate = self
            vc.setFormTaskRoutine(self.weekDay)
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
    //Days
    @IBAction func mondayButton(_ sender: UIButton) {
        weekDay = 1
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    @IBAction func tuesdayButton(_ sender: UIButton) {
        weekDay = 2
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    @IBAction func wednesdayButton(_ sender: UIButton) {
        weekDay = 3
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    @IBAction func thursdayButton(_ sender: UIButton) {
        weekDay = 4
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    @IBAction func fridayButton(_ sender: UIButton) {
        weekDay = 5
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    @IBAction func saturdayButton(_ sender: UIButton) {
        weekDay = 6
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    @IBAction func sundayButton(_ sender: UIButton) {
        weekDay = 7
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
    
    @IBAction func onTouchHideButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func validateName(_ text : String?) -> Bool{
        guard let name = text else {
            return false
        }
        return name.count > 3
    }
    
}

extension RoutineFormViewController: TaskFormDelegate {
    func didRegister(task: Task) {
        self.tasksWeek.append(task)
        setTaskOnView(Routine.getTaskByWeekDay(tasks: tasksWeek, weekDay: weekDay))
    }
}
