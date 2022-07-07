//
//  LoginViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var googleLoginButton: DefaultButton!
    @IBOutlet weak var anonLoginButton: DefaultButton!
    @IBOutlet weak var stackView: UIStackView!
    private var loginUseCase = LoginUseCase()
    private var carouselView: CarouselView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCarrouselView()
        setViewStyle()
    }
    
    private func setViewStyle() {
        googleLoginButton.setLoginGoogleStyle()
        anonLoginButton.setStyle()
    }
    
    private func setUpCarrouselView(){
        carouselView = CarouselView(pages: 3, delegate: self)
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .primary
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        carouselView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        carouselView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: loginCarousel)
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

extension LoginViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        UIView.animate(withDuration: 0.5) {
            var color : UIColor
            switch (page) {
            case 0: color = .primary
                break
            case 1: color = .secundary
                break
            case 2: color = .tertiary
                break
            default:
                color = .systemBlue
                break
            }
            self.carouselView?.backgroundColor = color
            self.view.backgroundColor = color
        }
    }
}
