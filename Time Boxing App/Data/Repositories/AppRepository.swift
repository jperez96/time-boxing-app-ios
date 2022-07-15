//
//  AppRepository.swift
//  Time Boxing App
//
//  Created by Julio Perez on 14/07/22.
//

import Foundation

protocol AppRepositoryDelegate {
    func result(_ result : BaseResponse<Bool>)
}

class AppRepository : IAppRepository {
    
    private lazy var userDefault = UserDefaultManager()
    private lazy var coreData = CoreDataManager()
    var delegate : AppRepositoryDelegate? = nil
    
    
    func syncDataToApp() {
        guard let user = userDefault.getUserLogged() else {
            self.delegate?.result(.success(data: true))
            return
        }
        if user.email.isNull() {
            self.delegate?.result(.success(data: true))
            return
        }
        let firebaseManager = GoogleFirestoreManager(FirebaseEntity.User.rawValue)
        firebaseManager.getDocument(user.email!, FirebaseUserEntity.self) { result in
            print(result.responseData ?? "")
            switch result.responseCode {
            case .Success:
                self.saveToApp(data: result.responseData!)
                self.delegate?.result(.success(data: true))
                break
            case .Error:
                self.delegate?.result(.error(msg: result.responseMessage))
                break
            }
        }
    }
    
    private func saveToApp(data: FirebaseUserEntity) {
        guard let coreData = self.coreData else {
            return
        }
        _ = userDefault.registerConfiguration(data.configuration)
        
        data.tasks.forEach { task in
            let created = coreData.insertEntity(entityData: task)
            print(created)
        }
        
        data.routines.forEach { routine in
            let created = coreData.insertEntity(entityData: routine)
            print(created)
        }
        
        let notificationRepository = NotificationRepository()
        notificationRepository.scheduleNotificationNotSingle(data.configuration.notification)
    }
    
    func syncDataToCloud() {
        guard let user = userDefault.getUserLogged(), let config = userDefault.getConfiguration(), let coreData = self.coreData else {
            self.delegate?.result(.success(data: true))
            return
        }
        if user.email.isNull() {
            self.delegate?.result(.success(data: true))
            return
        }
        
        let tasksResult = coreData.findEntitiesCasted(entity: Task.self)
        var tasks : [Task] = []
        tasksResult.forEach { task in
            if task.isNotNull() {
                tasks.append(task!)
            }
        }
        
        let routinesResult = coreData.findEntitiesCasted(entity: Routine.self)
        var routines : [Routine] = []
        routinesResult.forEach { routine in
            if routine.isNotNull() {
                routines.append(routine!)
            }
        }
        
        let entity = FirebaseUserEntity(user: user, tasks: tasks, routines: routines, configuration: config)
        let firebaseManager = GoogleFirestoreManager(FirebaseEntity.User.rawValue)
        firebaseManager.saveDocument(entity) { result in
            switch result.responseCode {
            case .Success:
                self.delegate?.result(.success(data: true))
                break
            case .Error:
                self.delegate?.result(.error(msg: result.responseMessage))
                break
            }
        }
    }
    
}

