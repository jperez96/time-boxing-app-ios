//
//  RegisterNotificationUseCase.swift
//  Time Boxing App
//
//  Created by Julio Perez on 5/07/22.
//

import Foundation
import RxSwift

protocol RegisterNotificationUseCaseProtocol {
    func execute(_ enable: Bool) -> Single<BaseResponse<Bool>>
}

class ScheduleNotificationUseCase: RegisterNotificationUseCaseProtocol {
    
    private let repository : NotificationRepository
    
    init() {
        self.repository = NotificationRepository()
    }
    
    func execute(_ enable: Bool) -> Single<BaseResponse<Bool>> {
        return repository.scheduleNotification(enable)
    }
    
}
