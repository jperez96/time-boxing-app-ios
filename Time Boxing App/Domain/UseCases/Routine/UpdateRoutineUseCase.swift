//
//  UpdateRoutineUseCase.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import RxSwift

protocol UpdateRoutineUseCaseProtocol {
    func execute(_ routine: Routine) -> Single<BaseResponse<Bool>>
}

class UpdateRoutineUseCase: UpdateRoutineUseCaseProtocol {
    
    private let repository : RoutineRepository
    
    init() {
        self.repository = RoutineRepository()
    }
    
    func execute(_ routine: Routine) -> Single<BaseResponse<Bool>> {
        return repository.updateRoutine(routine)
    }
    
}
