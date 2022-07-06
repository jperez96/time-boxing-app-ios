//
//  UserDefaultUtil.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 24/06/22.
//

import Foundation

class UserDefaultManager {
    
    private enum Key : String {
        case userLogged = "userLogged"
        case configuration = "configuration"
    }
    
    private var userDefault = UserDefaults.standard
    
    func registerUser(_ user: User) -> User? {
        let encondeData = CodableUtil.encondeObject(user)
        self.userDefault.set(encondeData, forKey: Key.userLogged.rawValue)
        return self.getUserLogged()
    }
    
    func registerConfiguration(_ config : Configuration) -> Configuration? {
        let encondeData = CodableUtil.encondeObject(config)
        self.userDefault.set(encondeData, forKey: Key.configuration.rawValue)
        return self.getConfiguration()
    }
    
    func getConfiguration() -> Configuration? {
        let decodedData = self.userDefault.data(forKey: Key.configuration.rawValue)
        return CodableUtil.decodeObject(decodedData)
    }
    
    func removeUserLogged() -> Bool {
        self.userDefault.removeObject(forKey: Key.userLogged.rawValue)
        return self.getUserLogged() == nil
    }
    
    func getUserLogged() -> User? {
        let decodedData = self.userDefault.data(forKey: Key.userLogged.rawValue)
        return CodableUtil.decodeObject(decodedData)
    }
    
    func validateIfUserIsLogged() -> Bool {
        return self.getUserLogged() != nil
    }
    
}
