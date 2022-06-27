//
//  TaskRepository.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation
import RxSwift

class TaskRepository : ITaskRepository {
    
    private lazy var coreData = CoreDataManager()
    
    func createTask(_ task: Task) -> Single<BaseResponse<Task>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(data: task, msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            let created = coreData.insertEntity(entityData: task)
            if (created) {
                single(.success(.success(data: task)))
            } else {
                single(.success(.error(data: task, msg: "No se registro en Core Data.")))
            }
            return Disposables.create {}
        }
    }
    
    func removeTask(_ task: Task) -> Single<BaseResponse<Bool>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(data: false, msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            let removed = coreData.removeEntity(entity: task)
            if (removed) {
                single(.success(.success(data: true)))
            } else {
                single(.success(.error(data: false, msg: "No se elimino de Core Data.")))
            }
            return Disposables.create {}
        }
    }
    
    func getTaskByDate(_ date: Date) -> Single<BaseResponse<[Task]>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(data: [], msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            
            let predicate =  NSPredicate(format: "initDate >= %@ && initDate <= %@", Calendar.current.startOfDay(for: date) as CVarArg, Calendar.current.startOfDay(for: date + 86400) as CVarArg)
            
            let result = coreData.findEntitiesByPredicateCasted(entity: Task.self, predicate: predicate)
            
            let nillCount = result.filter { task in
                task == nil
            }.count
    
            if (nillCount == 0) {
                var taskList: [Task] = []
                for task in result {
                    if(task != nil) {
                        taskList.append(task!)
                    }
                }
                single(.success(.success(data: taskList)))
            } else {
                single(.success(.error(data: [], msg: "Hay objetos nulos en la lista, verifique el modelo que se ha implementado")))
            }
            
            return Disposables.create {}
        }
    }
    
    func updateTask(_ task: Task) -> Single<BaseResponse<Bool>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(data: false, msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            let updated = coreData.updateEntity(entityData: task)
            if (updated) {
                single(.success(.success(data: updated)))
            } else {
                single(.success(.error(data: updated, msg: "No se actualizo en Core Data.")))
            }
            return Disposables.create {}
        }
    }
    
}
