//
//  RoutineTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class RoutineTabViewController: UIViewController {
    
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var addRoutineButton: BaseButton!
    private var routines: [Routine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpStyle()
    }
    
    private func setUpStyle(){
        addRoutineButton.setStyle()
    }
    
    @IBAction func addRoutineAction(_ sender: Any) {
        openRoutineFrom()
    }
    
    private func openRoutineFrom(_ routine: Routine? = nil) {
        let vc = RoutineFormViewController()
        vc.delegate = self
        if routine.isNotNull() {
            vc.setupForm(routine: routine)
        }
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    private func createRoutine(_ routine: Routine) {
        let useCase = CreateRoutineUseCase()
        _ = useCase.execute(routine).subscribe(onSuccess: { response in
            self.getRoutines()
        }, onFailure: { error in
            print(error)
        })
    }
    
    private func updateRoutine(_  routine: Routine) {
        let useCase = UpdateRoutineUseCase()
        _ = useCase.execute(routine).subscribe(onSuccess: { response in
            self.getRoutines()
        }, onFailure: { error in
            print(error)
        })
    }
    
    private func setUpTableView(_ routines : [Routine]){
        self.routines = routines
        routineTableView.reloadData()
    }
    
    
    private func setUpTable(){
        routineTableView.registerRoutineCell()
        routineTableView.dataSource = self
        routineTableView.delegate = self
        getRoutines()
    }
    
    private func getRoutines(){
        let useCase = GetRoutineUseCase()
        _ = useCase.execute().subscribe(onSuccess: { response in
            guard let routines = response.responseData else {
                print("No hay rutinas")
                return
            }
            self.setUpTableView(routines)
        }, onFailure: { error in
            print(error)
        })
    }
    
    private func removeRoutine(_ routine: Routine) {
        let useCase = RemoveRoutineUseCase()
        _ = useCase.execute(routine).subscribe(onSuccess: { response in
            guard let _ = response.responseData else {
                return
            }
            self.getRoutines()
        }, onFailure: { error in
            print(error)
        })
    }
    
}

extension RoutineTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellViewName.routine.rawValue, for: indexPath) as! RoutineCellTableViewCell
        cell.setData(routines[indexPath.row])
        return cell
    }
}

extension RoutineTabViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let routineToRemove = self.routines[indexPath.row]
            self.removeRoutine(routineToRemove)
            completionHandler(true)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            let routineToUpdte = self.routines[indexPath.row]
            self.openRoutineFrom(routineToUpdte)
            completionHandler(true)
        }
        
        updateAction.image = UIImage(systemName: "pencil")
        updateAction.backgroundColor = .systemOrange
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension RoutineTabViewController : RoutineFormDelegate {
    func registerRoutine(_ routine: Routine, _ isToUpdate: Bool) {
        if isToUpdate {
            updateRoutine(routine)
            return
        }
        createRoutine(routine)
    }
}
