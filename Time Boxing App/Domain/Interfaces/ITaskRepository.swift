//
//  ITaskRepository.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation
import RxSwift

protocol ITaskRepository {
    func createTask(_ task : Task) -> Single<BaseResponse<Task>>
    func removeTask(_ task : Task) -> Single<BaseResponse<Bool>>
    func updateTask(_ task : Task) -> Single<BaseResponse<Bool>>
    func getTaskByDate(_ date: Date) -> Single<BaseResponse<[Task]>>
}
