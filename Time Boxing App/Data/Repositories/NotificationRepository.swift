//
//  NotificationRepository.swift
//  Time Boxing App
//
//  Created by Julio Perez on 5/07/22.
//

import Foundation
import RxSwift

class NotificationRepository : INotificationRepository {
    
    private lazy var coreData = CoreDataManager()
    private lazy var notificationManager = NotificationManager()
    
    func scheduleNotification(_ schedule: Bool) -> Single<BaseResponse<Bool>> {
        return Single.create { single in
            
            guard let coreData = self.coreData else {
                single(.success(.error(msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            
            var tasks : [Task] = []
            var taskRoutines : [Task] = []
            let predicate =  NSPredicate(format: "initDate >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
            
            coreData.findEntitiesByPredicateCasted(entity: Task.self, predicate: predicate).forEach { task in
                if task.isNotNull() {
                    tasks.append(task!)
                }
            }
            
            coreData.findEntitiesCasted(entity: Routine.self).forEach { routine in
                if routine.isNotNull() {
                    routine!.tasks.forEach { task in
                        taskRoutines.append(task)
                    }
                }
            }
            
            var result = false
            
            if schedule {
                let resultTask = self.createNotifications(tasks, false)
                let resultRoutines = self.createNotifications(taskRoutines, true)
                result = resultTask && resultRoutines
            } else {
                tasks.append(contentsOf: taskRoutines)
                let resultTask = self.removeNotification(tasks)
                result = resultTask
            }
            
            single(.success(.success(data: result)))
            return Disposables.create {}
        }
    }
    
    func scheduleNotificationNotSingle(_ schedule : Bool) {
        guard let coreData = self.coreData else {
            return
        }
        
        var tasks : [Task] = []
        var taskRoutines : [Task] = []
        let predicate =  NSPredicate(format: "initDate >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
        
        coreData.findEntitiesByPredicateCasted(entity: Task.self, predicate: predicate).forEach { task in
            if task.isNotNull() {
                tasks.append(task!)
            }
        }
        
        coreData.findEntitiesCasted(entity: Routine.self).forEach { routine in
            if routine.isNotNull() {
                routine!.tasks.forEach { task in
                    taskRoutines.append(task)
                }
            }
        }
                
        if schedule {
            _ = self.createNotifications(tasks, false)
            _ = self.createNotifications(taskRoutines, true)
        } else {
            tasks.append(contentsOf: taskRoutines)
            _ = self.removeNotification(tasks)
        }
        
    }
    
    func scheduleSingleNotification(_ tasks : [Task] , _ schedule: Bool, _ repeatNotification: Bool) -> Single<BaseResponse<Bool>> {
        return Single.create { single in
            
            guard let _ = self.coreData else {
                single(.success(.error(msg: "CoreData no inicializado.")))
                return Disposables.create {}
            }
            
            var result = false
            
            if schedule {
                result = self.createNotifications(tasks, repeatNotification)
            } else {
                result = self.removeNotification(tasks)
            }
            
            single(.success(.success(data: result)))
            return Disposables.create {}
        }
    }
    
    func createNotifications(_ tasks: [Task] , _ repeatNotification: Bool) -> Bool {
        tasks.forEach { task in
            notificationManager.registerNotificationTask(task, task.initDate, repeatNotification)
        }
        return true
    }
    
    func removeNotification(_ tasks: [Task]) -> Bool {
        notificationManager.removeNotificationTask(tasks)
        return true
    }
    
    
}
