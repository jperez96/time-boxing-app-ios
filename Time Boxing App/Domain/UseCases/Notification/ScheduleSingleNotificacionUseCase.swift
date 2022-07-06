//
//  ScheduleSingleNotificacionUseCase.swift
//  Time Boxing App
//
//  Created by Julio Perez on 5/07/22.
//

import Foundation
import RxSwift

protocol RegisterSingleNotificationUseCaseProtocol {
    func execute(_ tasks: [Task], _ enable: Bool, _ repeatNotification: Bool) -> Single<BaseResponse<Bool>>
}

class ScheduleSingleNotificationUseCase: RegisterSingleNotificationUseCaseProtocol {
    
    private let repository : NotificationRepository
    
    init() {
        self.repository = NotificationRepository()
    }
    
    func execute(_ tasks: [Task],_ enable: Bool, _ repeatNotification : Bool) -> Single<BaseResponse<Bool>> {
        return repository.scheduleSingleNotification(tasks, enable, repeatNotification)
    }
    
}
