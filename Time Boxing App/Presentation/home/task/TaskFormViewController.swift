//
//  TaskFormViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 21/06/22.
//

import UIKit

protocol TaskFormDelegate {
    func didRegister(task: Task)
}


class TaskFormViewController: UIViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var initDateButtonOutle: UIButton!
    @IBOutlet weak var endDateButtonOutlet: UIButton!
    
    var task = Task(name: "", initDate: Date(), finishDate: Date())
    var delegate : TaskFormDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func registerTaskButton(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.didRegister(task: task)
    }
    
    @IBAction func startDateButton(_ sender: UIButton) {
        startDatePicker.isHidden = !startDatePicker.isHidden
        if(startDatePicker.isHidden) {
            saveInitDate()
        }
    }
    
    @IBAction func endDateButton(_ sender: UIButton) {
        endDatePicker.isHidden = !endDatePicker.isHidden
        if(endDatePicker.isHidden) {
            saveEndDate()
        }
    }
    
    private func saveEndDate(){
        task.finishDate = endDatePicker.date
        endDateButtonOutlet.setTitle("\(task.finishDate.description(with: .current))", for: .normal)
    }
    
    private func saveInitDate() {
        task.initDate = startDatePicker.date
        task.finishDate = startDatePicker.date
        endDatePicker.minimumDate = startDatePicker.date
        initDateButtonOutle.setTitle("\(task.initDate.description(with: .current))", for: .normal)
    }
}
