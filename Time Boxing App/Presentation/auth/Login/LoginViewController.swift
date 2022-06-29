//
//  LoginViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class LoginViewController: UIViewController {

    private var loginUseCase = LoginUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginGoogleButton() {
        guard let service = GoogleAuthService() else {
            return
        }
        service.signInDelegate = self
        service.signIn(vc: self)
    }
    
    private func loginWithUser(_ user : User) {
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


extension LoginViewController : GoogleSignInDelegate {
    func onSignInGoogleResponse(_ response: BaseResponse<User>) {
        if response.responseCode == .Success {
            loginWithUser(response.responseData!)
        } else {
            print(response.responseMessage)
        }
    }
}
