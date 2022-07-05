//
//  NotificationManager.swift
//  Time Boxing App
//
//  Created by Julio Perez on 5/07/22.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    private var userNotification : UNUserNotificationCenter
    
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
