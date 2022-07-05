//
//  CalendaryTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit
import HorizontalCalendar

class CalendaryTabViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var calendaryView: UIView!
    
    private var getTaskFromDate = GetTaskFromDateUseCase()
    private var removeTaskUseCase = RemoveTaskUseCase()
    private var tasks : [Task] = []
    private var calendar = HorizontalCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendaryView()
        initTableView()
    }
    
    private func initTableView(){
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.registerTaskCell()
    }
    
    @IBAction func openFormTaskButton(_ sender: UIButton) {
        if let vc = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "TaskFormVC") as? TaskFormViewController {
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func initCalendaryView(){
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 0),
            calendar.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendar.rightAnchor.constraint(equalTo: view.rightAnchor),
            calendar.bottomAnchor.constraint(equalTo: taskTableView.topAnchor)
        ])
        calendar.backgroundColor = .systemBackground
        calendar.onSelectionChanged = { date in
            self.getTaskFromDate(date)
        }
    }
    
    private func getTaskFromDate(_ date: Date){
        let _ = self.getTaskFromDate.execute(date).subscribe { response in
            guard let result = response.responseData else {
                print(response.responseMessage)
                return
            }
            self.tasks = result
            self.taskTableView.reloadData()
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
    
}


extension CalendaryTabViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellViewName.task.rawValue, for: indexPath) as! TaskCellTableViewCell
        cell.setData(obj: tasks[indexPath.row])
        return cell
    }
    
}

extension CalendaryTabViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let taskToRemove = self.tasks[indexPath.row]
            self.removeTask(taskToRemove)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension CalendaryTabViewController : TaskFormDelegate {
    func didRegister(task: Task) {
        getTaskFromDate(self.calendar.selectedDate)
    }
}