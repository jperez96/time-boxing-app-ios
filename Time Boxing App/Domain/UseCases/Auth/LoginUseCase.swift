//
//  LoginUseCase.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 23/06/22.
//

import Foundation
import RxSwift

protocol LoginUseCaseProtocol {
    func execute(_ user: User) -> Single<Bool>
}

class LoginUseCase: LoginUseCaseProtocol {
    
    private let authRepository : AuthRepository
    
    init() {
        self.authRepository = AuthRepository()
    }
    
    func execute(_ user: User) -> Single<Bool> {
        return authRepository.login(user)
    }
    
}
