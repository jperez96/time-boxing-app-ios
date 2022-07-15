//
//  AuthRepository.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 23/06/22.
//

import Foundation
import RxSwift

class AuthRepository : IAuthRepository {

    private lazy var defaultUtilData = UserDefaultManager()
    
    func login(_ user: User) -> Single<Bool> {
        return Single.create { single in
            let userCreated = self.defaultUtilData.registerUser(user)
            let configuration = self.defaultUtilData.registerConfiguration(Configuration())
            if ( userCreated != nil && configuration != nil ) {
                single(.success(true))
            } else {
                single(.success(false))
            }
            return Disposables.create {}
        }
    }
    
}

