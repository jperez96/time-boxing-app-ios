//
//  RemoveRoutineUseCase.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import RxSwift

protocol RemoveRoutineUseCaseProtocol {
    func execute(_ routine: Routine) -> Single<BaseResponse<Bool>>
}

class RemoveRoutineUseCase: RemoveRoutineUseCaseProtocol {
    
    private let repository : RoutineRepository
    
    init() {
        self.repository = RoutineRepository()
    }
    
    func execute(_ routine: Routine) -> Single<BaseResponse<Bool>> {
        return repository.removeRoutine(routine)
    }
    
}
