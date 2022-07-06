//
//  NotificationManager.swift
//  Time Boxing App
//
//  Created by Julio Perez on 5/07/22.
//

import Foundation
import UserNotifications

protocol NotificationPermissionDelegate {
    func requestPermission(_ permission : BaseResponse<Bool>)
}

class NotificationManager {
    
    private var userNotification : UNUserNotificationCenter
    var delegate: NotificationPermissionDelegate? = nil
    
    init(){
        self.userNotification = UNUserNotificationCenter.current()
    }
    
    func registerNotificationTask(_ task: Task,  _ notificationDate: Date, _ repeatNotification: Bool) {
        var date = DateComponents()
        date.weekday = notificationDate.getWeekDay()
        date.hour = notificationDate.getHour()
        let content = UNMutableNotificationContent()
        content.title = "\(task.name) - \(notificationDate.toDateString(.format3))"
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeatNotification)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        userNotification.add(request) { (error) in
            guard let error = error else {
                return
            }
            print(task)
            print(error)
        }
    }
    
    func requestPermission(){
        userNotification.requestAuthorization(options: [.alert, .sound, .badge]) { permission, error in
            guard let error = error else {
                self.delegate?.requestPermission(.success(data: permission))
                return
            }
            self.delegate?.requestPermission(.error(msg: error.localizedDescription))
        }
    }
    
    func removeNotificationTask(_ task : Task){
        userNotification.removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        userNotification.removeDeliveredNotifications(withIdentifiers: [task.id.uuidString])
    }
    
    func removeNotificationTask(_ tasks: [Task]) {
        let listOfUiid = tasks.map { task in
            task.id.uuidString
        }
        userNotification.removePendingNotificationRequests(withIdentifiers: listOfUiid)
        userNotification.removeDeliveredNotifications(withIdentifiers: listOfUiid)
    }
    
    func nuke(){
        userNotification.removeAllDeliveredNotifications()
    }
    
    
    
}
