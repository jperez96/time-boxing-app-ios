//
//  GoogleAuthService.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 28/06/22.
//

import Foundation
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

protocol GoogleAuthDelegate {
    func onSignGoogleResponse(_ response: BaseResponse<User>)
}

class GoogleAuthService {
    
    private var clientID : String
    private var config : GIDConfiguration
    var delegate : GoogleAuthDelegate?
    
    init?(){
        guard let id = FirebaseApp.app()?.options.clientID else {
            return nil
        }
        self.clientID = id
        self.config = GIDConfiguration(clientID: clientID)
    }
    
    private func getCredentials(vc : UIViewController){
        
    }
    
    func signGoogle(vc : UIViewController){
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { [unowned self] user, error in
            if let error = error {
                self.delegate?.onSignGoogleResponse(.error(msg: error.localizedDescription))
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                self.delegate?.onSignGoogleResponse(.error(msg: "No se obtuvo el authentication."))
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            self.firebaseSignIn(credential)
        }
    }
    
    private func firebaseSignIn(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.delegate?.onSignGoogleResponse(.error(msg: error.localizedDescription))
                // Falta la verificacion de telefono MULTI-FACTOR
                return
            }
            
            guard let result = authResult else {
                self.delegate?.onSignGoogleResponse(.error(msg: "Error al iniciar sesion con Google."))
                return
            }
            let defaultErrorMessage = "Sin identificar."
            let userName = result.user.displayName ?? defaultErrorMessage
            let userEmail = result.user.email ?? defaultErrorMessage
            let user = User(name: userName, email: userEmail, loginType: LoginType.Google.rawValue)
            self.delegate?.onSignGoogleResponse(.success(data: user))
        }
    }
    
}
