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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let user = UserDefaultManager().getUserLogged() else {
            return
        }
        userNameLabel.text = user.name
    }
    
    private func setupViews() {
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    }
    
    @IBAction func onDidTouchSignOutButton(_ sender: UIButton) {
        
        if(UserDefaultManager().removeUserLogged()){
            let loginStoryBoard = UIStoryboard(name: StoryboardName.Login.rawValue , bundle: .main)
            let initialViewController = loginStoryBoard.instantiateViewController(withIdentifier: ViewControllerName.LoginView.rawValue)
            initialViewController.modalPresentationStyle = .currentContext
            self.present(initialViewController, animated: true)
        }
        
    }
}
