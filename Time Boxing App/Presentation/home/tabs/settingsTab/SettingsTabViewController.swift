//
//  SettingsTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class SettingsTabViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    private var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let user = UserDefaultManager().getUserLogged() else {
            return
        }
        self.currentUser = user
        userNameLabel.text = user.name
    }
    
    private func setupViews() {
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    }
    
    @IBAction func onDidTouchSignOutButton(_ sender: UIButton) {
        guard let currentUser = currentUser else {
            removeLocalSesion()
            return
        }
        signOut(currentUser)
    }
    
    private func removeGoogleSession(_ currentUser: User) {
        if(currentUser.loginType == LoginType.Google.rawValue) {
            guard let service = GoogleAuthService() else {
                removeLocalSesion()
                return
            }
            service.signOutDelegate = self
            service.signOut()
        }
    }
    
    private func signOut(_ currentUser: User){
        switch(currentUser.loginType){
        case LoginType.Google.rawValue:
            removeGoogleSession(currentUser)
            break
        default:
            removeLocalSesion()
            break
        }
    }
    
    private func removeLocalSesion(){
        guard let coreData = CoreDataManager() else {
            return
        }
        if(UserDefaultManager().removeUserLogged()){
            coreData.nuke()
            let loginStoryBoard = UIStoryboard(name: StoryboardName.Login.rawValue , bundle: .main)
            let initialViewController = loginStoryBoard.instantiateViewController(withIdentifier: ViewControllerName.LoginView.rawValue)
            initialViewController.modalPresentationStyle = .currentContext
            self.present(initialViewController, animated: true)
        }
    }
}

extension SettingsTabViewController : GoogleSignOutDelegate {
    func onSignOutResponse(_ response: BaseResponse<Bool>) {
        switch(response.responseCode) {
        case .Success:
            removeLocalSesion()
            break
        case .Error:
            print(response.responseMessage)
            break
        }
    }
}
