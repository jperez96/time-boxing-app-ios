//
//  RoutineTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class RoutineTabViewController: UIViewController {
    
    @IBOutlet weak var routineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addRoutineAction(_ sender: Any) {
        let vc = RoutineFormViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    
}

