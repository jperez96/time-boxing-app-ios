//
//  IAuthRepository.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 23/06/22.
//

import Foundation
import RxSwift

protocol IAuthRepository {
    func login(_ user : User) -> Single<Bool>
}
