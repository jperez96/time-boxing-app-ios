//
//  CreateRoutineUseCase.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import RxSwift

protocol CreateRoutineUseCaseProtocol {
    func execute(_ routine: Routine) -> Single<BaseResponse<Routine>>
}

class CreateRoutineUseCase: CreateRoutineUseCaseProtocol {
    
    private let repository : RoutineRepository
    
    init() {
        self.repository = RoutineRepository()
    }
    
    func execute(_ routine: Routine) -> Single<BaseResponse<Routine>> {
        return repository.createRoutine(routine)
    }
    
}
