//
//  RegisterViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    private var loginUseCase = LoginUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onChangeUsernameTextField(_ sender: UITextField) {
        guard let size = sender.text?.count else {
            return
        }
        registerButton.isEnabled = size > 2
    }

    @IBAction func createUserButton(_ sender: UIButton) {
        guard let name = userTextField.text else {
            return
        }
        let user = User(name: name , email: nil, loginType: LoginType.Other.hashValue)
        _ = loginUseCase.execute(user).subscribe { result in
            if result {
                self.toHomeView()
            }
        } onFailure: { error in
            print(error)
        }
    }
    
    private func toHomeView(){
        let storyboard = UIStoryboard(name: StoryboardName.Home.rawValue , bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerName.TabView.rawValue)
        self.present(vc, animated: true)
    }
}
