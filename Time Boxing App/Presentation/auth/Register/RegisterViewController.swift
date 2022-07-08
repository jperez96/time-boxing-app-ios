//
//  RegisterViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userTextField: DefaultTextField!
    @IBOutlet weak var registerButton: DefaultButton!
    
    private var loginUseCase = LoginUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setUpViews()
    }
    
    private func setStyle() {
        self.view.backgroundColor = .primary
        userTextField.setStyle()
        registerButton.setStyle()
    }
    
    private func setUpViews(){
        userTextField.addTarget(self, action: #selector(self.onChangeTextName(_:)), for: .editingChanged)
    }
    
    @objc func onChangeTextName(_ textField: UITextField) {
        guard let size = textField.text?.count else {
            return
        }
        registerButton.isEnabled = size > 2
        registerButton.setStyle()
    }
    

    @IBAction func onDidTouchRegisterButton(_ sender: DefaultButton) {
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
