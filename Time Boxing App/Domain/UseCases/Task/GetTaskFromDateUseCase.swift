//
//  GetTaskFromDateUseCase.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 27/06/22.
//

import Foundation
import RxSwift

protocol GetTaskFromDateUseCaseProtocol {
    func execute(_ date: Date) -> Single<BaseResponse<[Task]>>
}

class GetTaskFromDateUseCase : GetTaskFromDateUseCaseProtocol {
    
    private let taskRepository : TaskRepository

    init() {
        self.taskRepository = TaskRepository()
    }
    
    func execute(_ date: Date) -> Single<BaseResponse<[Task]>> {
        return taskRepository.getTaskByDate(date)
    }
    
}
