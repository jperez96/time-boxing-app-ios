//
//  CalendaryTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class CalendaryTabViewController: UIViewController {
   
    @IBOutlet weak var taskTableView: UITableView!
    
    var tasks = [
        Task(name: "Estudiar",finished: true,  initDate: Date(), finishDate: Date()),
        Task(name: "Repasar", initDate: Date(), finishDate: Date()),
        Task(name: "Acabar el proyecto", finished: false, initDate: Date(), finishDate: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskCellTableViewCell", bundle: nil), forCellReuseIdentifier: CellViewName.task.rawValue)
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
