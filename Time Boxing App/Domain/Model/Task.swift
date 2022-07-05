//
//  Task.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 22/06/22.
//

import Foundation
import CoreData

struct Task : Codable {
    
    let id : UUID
    var name : String
    var finished : Bool
    var initDate : Date
    var finishDate : Date
    
    init(id: UUID ,name: String, finished: Bool, initDate: Date, finishDate: Date) {
        self.id = id
        self.name = name
        self.finished = finished
        self.initDate = initDate
        self.finishDate = finishDate
    }
    
    init(name: String, initDate: Date, finishDate: Date) {
        self.id = UUID.init()
        self.name = name
        self.finished = false
        self.initDate = initDate
        self.finishDate = finishDate
    }
    
    init(name: String, finished: Bool, initDate: Date, finishDate: Date) {
        self.id = UUID.init()
        self.name = name
        self.finished = finished
        self.initDate = initDate
        self.finishDate = finishDate
    }
    
    static func getTaskDateByWeekDay(date: Date, weekDay : Int) -> Date? {
        let nexttDay = DateComponents(weekday: weekDay)
        return Calendar.current.nextDate(after: date, matching: nexttDay, matchingPolicy: .strict)
    }
    
}

extension Task : CoreDataEntityRequiere {
    
    static func cast<T>(_ entity: NSManagedObject) -> T? {
        guard let id = entity.value(forKey: "id") as? UUID else {
            return nil
        }
        guard let name = entity.value(forKey: "name") as? String else {
            return nil
        }
        guard let finished = entity.value(forKey: "finished") as? Bool else {
            return nil
        }
        guard let initDate = entity.value(forKey: "initDate") as? Date else {
            return nil
        }
        guard let finishDate = entity.value(forKey: "finishDate") as? Date else {
            return nil
        }
        return Task(id: id, name: name, finished: finished, initDate: initDate, finishDate: finishDate) as? T
    }
    
    static func getEntityName() -> String {
        return CoreDataEntity.TaskEntity.rawValue
    }
    
    func getIdentifierPredicate() -> NSPredicate {
        return NSPredicate(format: "id == %@", "\(self.id)")
    }
    
    func getDataModel() -> [String : Any] {
        return [
            "id": self.id,
            "name": self.name,
            "finished": self.finished,
            "initDate": self.initDate,
            "finishDate": self.finishDate,
        ] as [String : Any]
    }
    
}
