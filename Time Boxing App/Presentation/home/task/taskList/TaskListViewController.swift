//
//  TaskListViewController.swift
//  Time Boxing App
//
//  Created by Julio Perez on 2/07/22.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    private var tasks : [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView(){
        taskTableView.dataSource = self
        taskTableView.registerTaskCell()
        taskTableView.reloadData()
    }
    
    func setNewTasks(_ tasks: [Task]) {
        self.tasks = tasks
        self.taskTableView.reloadData()
    }

}

extension TaskListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellViewName.task.rawValue, for: indexPath) as! TaskCellTableViewCell
        cell.setData(obj: tasks[indexPath.row])
        cell.hideCompletedButton(true)
        return cell
    }
    
}
