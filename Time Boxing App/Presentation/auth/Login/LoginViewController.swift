//
//  LoginViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginGoogleButton() {
        guard let service = GoogleAuthService() else {
            return
        }
        service.signGoogle(vc: self)
    }
}
