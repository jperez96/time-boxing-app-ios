//
//  RoutineRepository.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import RxSwift

class RoutineRepository : IRoutineRepository {
    
    private lazy var coreData = CoreDataManager()
    private lazy var userDefault = UserDefaultManager()

    func createRoutine(_ routine: Routine) -> Single<BaseResponse<Routine>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            let created = coreData.insertEntity(entityData: routine)
            
            let config = self.userDefault.getConfiguration()?.notification ?? false
            if config {
                _ = NotificationRepository().createNotifications(routine.tasks, true)
            }
            
            if created {
                single(.success(.success(data: routine)))
            } else {
                single(.success(.error(msg: "No se registro en Core Data.")))
            }
            return Disposables.create {}
        }
    }
    
    func removeRoutine(_ routine: Routine) -> Single<BaseResponse<Bool>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            let removed = coreData.removeEntity(entity: routine)
            _ = NotificationRepository().removeNotification(routine.tasks)
            if removed  {
                single(.success(.success(data: true)))
            } else {
                single(.success(.error( msg: "No se elimino de Core Data.")))
            }
            return Disposables.create {}
        }
    }
    
    func updateRoutine(_ routine: Routine) -> Single<BaseResponse<Bool>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error( msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            let updated = coreData.updateEntity(entityData: routine)
            
            let config = self.userDefault.getConfiguration()?.notification ?? false
            if config {
                _ = NotificationRepository().removeNotification(routine.tasks)
                _ = NotificationRepository().createNotifications(routine.tasks, true)
            }
            
            if updated {
                single(.success(.success(data: updated)))
            } else {
                single(.success(.error( msg: "No se actualizo en Core Data.")))
            }
            return Disposables.create {}
        }
    }
    
    func getRoutines() -> Single<BaseResponse<[Routine]>> {
        return Single.create { single in
            guard let coreData = self.coreData else {
                single(.success(.error(msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            
            let result = coreData.findEntitiesCasted(entity: Routine.self)
            let nillCount = result.filter { task in
                task == nil
            }.count
    
            if (nillCount == 0) {
                var list: [Routine] = []
                for routine in result {
                    if(routine != nil) {
                        list.append(routine!)
                    }
                }
                single(.success(.success(data: list)))
            } else {
                single(.success(.error( msg: "Hay objetos nulos en la lista, verifique el modelo que se ha implementado")))
            }
            
            return Disposables.create {}
        }
    }
    
}

