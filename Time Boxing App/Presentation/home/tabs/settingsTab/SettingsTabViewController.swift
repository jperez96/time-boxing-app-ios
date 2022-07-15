//
//  SettingsTabViewController.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 20/06/22.
//

import UIKit

class SettingsTabViewController: UIViewController {
    
    private var notificationManager = NotificationManager()
    
    @IBOutlet weak var signOutButton: BaseButton!
    @IBOutlet var configurationStacks: [UIStackView]!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var notificationPermissionOutletSwitch: UISwitch!
    
    private var currentUser: User?
    private var currentConfig = Configuration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setStyleView()
        setUpConfiguration()
        setUpProfile()
    }
    
    private func setStyleView(){
        configurationStacks.forEach { stack in
            stack.layer.cornerRadius = 8
        }
        notificationPermissionOutletSwitch.onTintColor = .primary
        signOutButton.setStyle()
    }
    
    private func setUpConfiguration(){
        notificationManager.delegate = self
        guard let config = UserDefaultManager().getConfiguration() else {
            return
        }
        self.currentConfig = config
        notificationPermissionOutletSwitch.isOn = config.notification
    }
    
    private func setUpProfile(){
        guard let user = UserDefaultManager().getUserLogged() else {
            return
        }
        self.currentUser = user
        userNameLabel.text = user.name
    }
    
    private func setupViews() {
        userImageView.layer.masksToBounds = true
    }
    
    @IBAction func onDidTouchSignOutButton(_ sender: UIButton) {
        guard let currentUser = currentUser else {
            removeLocalSesion()
            return
        }
        signOut(currentUser)
    }
    
    private func scheduleNotifications(_ schedule: Bool){
        let useCase = ScheduleNotificationUseCase()
        _ = useCase.execute(schedule).subscribe(onSuccess: { response in
            self.syncData()
        }, onFailure: { error in
            print(error)
        })
    }
    
    private func syncData() {
        let repository = AppRepository()
        repository.delegate = self
        repository.syncDataToCloud()
        return
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
    
    @IBAction func requestNotificationPermission(_ sender: UISwitch) {
        changeNotificationPermission(sender.isOn)
    }
    
    private func changeNotificationPermission(_ checked: Bool) {
        self.currentConfig.notification = checked
        if checked {
            notificationManager.requestPermission()
            return
        }
        updateConfig(self.currentConfig)
    }
    
    private func updateConfig(_ config : Configuration){
        guard let _ = UserDefaultManager().registerConfiguration(config) else {
            return
        }
        setUpConfiguration()
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
            scheduleNotifications(false)
            removeLocalSesion()
            break
        case .Error:
            print(response.responseMessage)
            break
        }
    }
}

extension SettingsTabViewController : NotificationPermissionDelegate {
    func requestPermission(_ permission: BaseResponse<Bool>) {
        guard let result = permission.responseData else {
            print(permission.responseMessage)
            return
        }
        DispatchQueue.main.async {
            if !result {
                self.currentConfig.notification = false
            }
            self.scheduleNotifications(self.currentConfig.notification)
            self.updateConfig(self.currentConfig)
        }
    }
}

extension SettingsTabViewController : AppRepositoryDelegate {
    func result(_ result: BaseResponse<Bool>) {
        print(result.responseMessage)
    }
}
