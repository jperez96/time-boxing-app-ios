//
//  CreateTaskUseCase.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation
import RxSwift

protocol CreateTaskUseCaseProtocol {
    func execute(_ task: Task) -> Single<BaseResponse<Task>>
}

class CreateTaskUseCase: CreateTaskUseCaseProtocol {
    
    private let taskRepository : TaskRepository
    
    init() {
        self.taskRepository = TaskRepository()
    }
    
    func execute(_ task: Task) -> Single<BaseResponse<Task>> {
        return taskRepository.createTask(task)
    }
    
}
