//
//  Routine.swift
//  Time Boxing App
//
//  Created by Julio Perez on 4/07/22.
//

import Foundation
import CoreData

struct Routine : Codable {
    
    let id : UUID
    var name : String
    var tasks: [Task]
    
    static func getTaskByWeekDay(tasks : [Task], weekDay: Int) -> [Task] {
        return tasks.filter { task in
            task.initDate.getWeekDay() == weekDay
        }
    }
    
}

extension Routine : CoreDataEntityRequiere {
    static func cast<T>(_ entity: NSManagedObject) -> T? {
        guard let id = entity.value(forKey: "id") as? UUID else {
            return nil
        }
        guard let name = entity.value(forKey: "name") as? String else {
            return nil
        }
        guard let tasks = entity.value(forKey: "tasks") as? [Task] else {
            return nil
        }
        return Routine(id: id, name: name, tasks: tasks) as? T
    }
    
    static func getEntityName() -> String {
        return CoreDataEntity.RoutineEntity.rawValue
    }
    
    func getIdentifierPredicate() -> NSPredicate {
        return NSPredicate(format: "id == %@", "\(self.id)")
    }
    
    func getDataModel() -> [String : Any] {
        return [
            "id": self.id,
            "name": self.name,
            "tasks": self.tasks,
        ] as [String : Any]
    }
}
