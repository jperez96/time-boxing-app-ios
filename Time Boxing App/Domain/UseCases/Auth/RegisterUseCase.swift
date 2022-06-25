//
//  RegisterUseCase.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 24/06/22.
//


import Foundation
import RxSwift

protocol RegisterUseCaseProtocol {
    func execute(_ user: User) -> Single<Bool>
}

class RegisterUseCase: RegisterUseCaseProtocol {
    
    private let authRepository : AuthRepository
    
    init(_ repository: AuthRepository){
        self.authRepository = repository
    }
    
    func execute(_ user: User) -> Single<Bool> {
        return authRepository.register(user)
    }
    
}
