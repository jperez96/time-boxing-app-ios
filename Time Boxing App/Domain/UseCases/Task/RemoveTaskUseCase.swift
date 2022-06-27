//
//  RemoveTaskUseCase.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 27/06/22.
//

import Foundation
import RxSwift

protocol RemoveTaskUseCaseProtocol {
    func execute(_ task: Task) -> Single<BaseResponse<Bool>>
}

class RemoveTaskUseCase : RemoveTaskUseCaseProtocol {
    
    private let taskRepository : TaskRepository

    init() {
        self.taskRepository = TaskRepository()
    }
    
    func execute(_ task: Task) -> Single<BaseResponse<Bool>> {
        return taskRepository.removeTask(task)
    }

}
