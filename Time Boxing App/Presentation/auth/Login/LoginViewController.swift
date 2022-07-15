//
//  LoginViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var googleLoginButton: BaseButton!
    @IBOutlet weak var anonLoginButton: BaseButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerCarouselView: UIView!
    private var carouselVc : CarouselPageViewController? = nil
    private var loginUseCase = LoginUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
    }
    
    private func setViewStyle() {
        googleLoginButton.setLoginGoogleStyle()
        anonLoginButton.setStyle()
        UIView.animate(withDuration: 0.5 ){
            self.view.backgroundColor = .primary
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let carouselVc = segue.destination as? CarouselPageViewController else {
            return
        }
        self.carouselVc = carouselVc
        self.carouselVc?.carouselDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpCarrouselView()
    }
    
    private func setUpCarrouselView(){
        self.view.backgroundColor = .primary
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
                if user.loginType == LoginType.Google.rawValue {
                    let repository = AppRepository()
                    repository.delegate = self
                    repository.syncDataToApp()
                    return
                }
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

extension LoginViewController : AppRepositoryDelegate {
    func result(_ result: BaseResponse<Bool>) {
        print(result.responseMessage)
        self.toHomeView()
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

extension LoginViewController : CarouselPageDelegate {    
    
    func onPageChanged(_ page: Int, _ vc: UIViewController, _ view: UIView) {
        UIView.animate(withDuration: 0.5 ){
            let uiColor: UIColor
            switch page {
            case 0: uiColor = .primary
            case 1 : uiColor = .secundary
            case 2 : uiColor = .tertiary
            default: uiColor = .primary
                break
            }
            self.view.backgroundColor = uiColor
        }
    }
    
}
