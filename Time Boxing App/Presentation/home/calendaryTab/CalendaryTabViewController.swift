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
    
    var tasks = [
        Task(name: "Estudiar",finished: true,  initDate: Date(), finishDate: Date()),
        Task(name: "Repasar", initDate: Date(), finishDate: Date()),
        Task(name: "Acabar el proyecto", finished: false, initDate: Date(), finishDate: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendaryView()
        initTableView()
    }
    
    private func initTableView(){
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskCellTableViewCell", bundle: nil), forCellReuseIdentifier: CellViewName.task.rawValue)
    }
    
    @IBAction func openFormTaskButton(_ sender: UIButton) {
        if let vc = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "TaskFormVC") as? TaskFormViewController {
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func initCalendaryView(){
        let calendar = HorizontalCalendar()
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
            print(date)
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

extension CalendaryTabViewController : TaskFormDelegate {
    func didRegister(task: Task) {
        tasks.append(task)
        taskTableView.reloadData()
    }
}
