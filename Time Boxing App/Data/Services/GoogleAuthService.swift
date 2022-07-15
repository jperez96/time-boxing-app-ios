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

protocol GoogleSignInDelegate {
    func onSignInGoogleResponse(_ response: BaseResponse<User>)
    func onStartSignIn()
}

protocol GoogleSignOutDelegate {
    func onSignOutResponse(_ response: BaseResponse<Bool>)
}

class GoogleAuthService {
    
    private var clientID : String
    private var config : GIDConfiguration
    var signInDelegate : GoogleSignInDelegate?
    var signOutDelegate : GoogleSignOutDelegate?

    
    init?(){
        guard let id = FirebaseApp.app()?.options.clientID else {
            return nil
        }
        self.clientID = id
        self.config = GIDConfiguration(clientID: clientID)
    }
    
    func signIn(vc : UIViewController){
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { user, error in
            if let _ = error {
                self.signInDelegate?.onSignInGoogleResponse(.error(msg: error?.localizedDescription ?? "Error no especifido."))
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                self.signInDelegate?.onSignInGoogleResponse(.error(msg: "No se obtuvo el authentication."))
                return
            }
            self.signInDelegate?.onStartSignIn()
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            self.firebaseSignIn(credential)
        }
    }
    
    private func firebaseSignIn(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let _ = error {
                self.signInDelegate?.onSignInGoogleResponse(.error(msg: error?.localizedDescription ?? "Error no especificado."))
                // Falta la verificacion de telefono MULTI-FACTOR
                return
            }
            
            guard let result = authResult else {
                self.signInDelegate?.onSignInGoogleResponse(.error(msg: "Error al iniciar sesion con Google."))
                return
            }
            let defaultErrorMessage = "Sin identificar."
            let userName = result.user.displayName ?? defaultErrorMessage
            let userEmail = result.user.email ?? defaultErrorMessage
            let user = User(name: userName, email: userEmail, loginType: LoginType.Google.rawValue)
            self.signInDelegate?.onSignInGoogleResponse(.success(data: user))
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            signOutDelegate?.onSignOutResponse(.success(data: true))
        } catch let signOutError as NSError {
            signOutDelegate?.onSignOutResponse(.error(msg: signOutError.localizedDescription))
        }
    }
    
}
