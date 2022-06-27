//
//  UpdateTaskUseCase.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 27/06/22.
//

import Foundation
import RxSwift

protocol UpdateTaskUseCaseProtocol {
    func execute(_ task: Task) -> Single<BaseResponse<Bool>>
}

class UpdateTaskUseCase : UpdateTaskUseCaseProtocol {
    
    private let taskRepository : TaskRepository

    init() {
        self.taskRepository = TaskRepository()
    }
    
    func execute(_ task: Task) -> Single<BaseResponse<Bool>> {
        return taskRepository.updateTask(task)
    }

}
