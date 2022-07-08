//
//  TaskFormViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 21/06/22.
//

import UIKit
import CoreData

protocol TaskFormDelegate {
    func didRegister(task: Task)
}


class TaskFormViewController: UIViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: DefaultTextField!
    @IBOutlet weak var initDateButtonOutle: DefaultButton!
    @IBOutlet weak var endDateButtonOutlet: DefaultButton!
    @IBOutlet weak var registerButton: DefaultButton!
    @IBOutlet weak var dimissOutletButton: DefaultButton!
    private var weekDay = 0
    
    var task = Task(name: "", initDate: Date(), finishDate: Date())
    var delegate : TaskFormDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setStyle()
        if(weekDay != 0){
            setUpFormTaskRoutineView()
        }
    }
    
    private func setStyle(){
        initDateButtonOutle.setStyle()
        endDateButtonOutlet.setStyle()
        dimissOutletButton.setStyle()
        registerButton.setStyle()
        titleTextField.setStyle()
    }
    
    private func setupViews() {
        initDateButtonOutle.contentHorizontalAlignment = .left
        endDateButtonOutlet.contentHorizontalAlignment = .left
        let defaultDate = Date()
        startDatePicker.minimumDate = defaultDate
        endDatePicker.minimumDate = defaultDate
        initDateButtonOutle.setDateString(defaultDate, "Fecha Inicio", weekDay == 0 ? .format1 : .format3)
        endDateButtonOutlet.setDateString(defaultDate, "Fecha Fin", .format3)
        startDatePicker.addTarget(self, action: #selector(self.startDatePickerChanged(_:)), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(self.endDatePickerChanged(_:)), for: .valueChanged)
    }
    
    @objc func startDatePickerChanged(_ sender: UIDatePicker) {
        saveInitDate(sender.date)
    }
    
    
    @objc func endDatePickerChanged(_ sender: UIDatePicker) {
        saveEndDate(sender.date)
    }
    
    func setFormTaskRoutine(_ weekDay : Int){
        self.weekDay = weekDay
    }
    
    private func setUpFormTaskRoutineView(){
        startDatePicker.datePickerMode = .time
        let now = Date.now
        guard let date = Task.getTaskDateByWeekDay(date: now, weekDay: weekDay) else {
            return
        }
        self.task.initDate = date
        self.task.finishDate = date
        startDatePicker.setDate(date, animated: true)
        startDatePicker.minimumDate = date
        endDatePicker.setDate(date, animated: true)
        endDatePicker.minimumDate = date
    }
    
 
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func registerTaskButton(_ sender: UIButton) {
        self.delegate?.didRegister(task: self.task)
        dismiss(animated: true)
    }
    
    @IBAction func startDateButton(_ sender: UIButton) {
        startDatePicker.isHidden = !startDatePicker.isHidden
    }
    
    @IBAction func endDateButton(_ sender: UIButton) {
        endDatePicker.isHidden = !endDatePicker.isHidden
    }
    
    @IBAction func titleEditingChangedTextField(_ sender: UITextField) {
        guard let title = sender.text else {
            return
        }
        registerButton.isEnabled = !title.isEmpty
        task.name = title
    }
    
    private func saveEndDate(_ date: Date){
        task.finishDate = date
        endDateButtonOutlet.setDateString(date, "Fecha Fin", .format3)
    }
    
    private func saveInitDate(_ date: Date) {
        task.initDate = date
        task.finishDate = date
        endDatePicker.minimumDate = date
        initDateButtonOutle.setDateString(date, "Fecha Inicio", weekDay == 0 ? .format1 : .format3)
    }
    
}
