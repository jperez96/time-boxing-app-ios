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
    @IBOutlet weak var initDateButtonOutle: UIButton!
    @IBOutlet weak var endDateButtonOutlet: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    private var weekDay = 0
    
    var task = Task(name: "", initDate: Date(), finishDate: Date())
    var delegate : TaskFormDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if(weekDay != 0){
            setUpFormTaskRoutineView()
        }
    }
    
    private func setupViews() {
        initDateButtonOutle.contentHorizontalAlignment = .left
        endDateButtonOutlet.contentHorizontalAlignment = .left
        let defaultDate = Date()
        initDateButtonOutle.setDateString(defaultDate, "Fecha Inicio", weekDay == 0 ? .format1 : .format3)
        endDateButtonOutlet.setDateString(defaultDate, "Fecha Fin", .format3)
    }
    
    func setFormTaskRoutine(_ weekDay : Int){
        self.weekDay = weekDay
    }
    
    private func setUpFormTaskRoutineView(){
        startDatePicker.datePickerMode = .time
        guard let date = Task.getTaskDateByWeekDay(date: Date(), weekDay: weekDay) else {
            startDatePicker.setDate(Date.now, animated: true)
            return
        }
        startDatePicker.setDate(date, animated: true)
    }
 
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func registerTaskButton(_ sender: UIButton) {
        if(weekDay == 0) {
            registerTask()
            return
        }
        self.delegate?.didRegister(task: self.task)
        dismiss(animated: true)
    }
    
    private func registerTask(){
        let useCase = CreateTaskUseCase()
        let _ = useCase.execute(task).subscribe { response in
            self.dismiss(animated: true)
            self.delegate?.didRegister(task: self.task)
        } onFailure: { error in
            print(error)
        }
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
    
    @IBAction func initValueChangeDatePicker(_ sender: UIDatePicker) {
        saveInitDate(sender.date)
    }

    @IBAction func endValueChangedDatePicker(_ sender: UIDatePicker) {
        saveEndDate(sender.date)
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
