//
//  GetRoutineUseCase.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import RxSwift

protocol GetRoutineUseCaseProtocol {
    func execute() -> Single<BaseResponse<[Routine]>>
}

class GetRoutineUseCase: GetRoutineUseCaseProtocol {
    
    private let repository : RoutineRepository
    
    init() {
        self.repository = RoutineRepository()
    }
    
    func execute() -> Single<BaseResponse<[Routine]>> {
        return repository.getRoutines()
    }
    
}
