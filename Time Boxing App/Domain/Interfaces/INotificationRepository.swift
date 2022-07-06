//
//  INotificationRepository.swift
//  Time Boxing App
//
//  Created by Julio Perez on 5/07/22.
//

import Foundation
import RxSwift

protocol INotificationRepository {
    func scheduleNotification(_ schedule : Bool) -> Single<BaseResponse<Bool>>
    func scheduleSingleNotification(_ tasks : [Task], _ schedule : Bool, _ repeatNotification: Bool) -> Single<BaseResponse<Bool>>
}
