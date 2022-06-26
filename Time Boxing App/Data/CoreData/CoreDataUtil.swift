//
//  CoreDataUtil.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataUtil {
    
    private var appDelegate : AppDelegate
    private var context : NSManagedObjectContext
    
    init?(){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        self.appDelegate = delegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func insertEntity<T: CoreDataEntityRequiere>(entityData : T, entityName: CoreDataEntity) -> Bool {
        let dataInserted = self.save(entityData: entityData, entityName: entityName)
        if(!dataInserted){
            return false
        }
        let inserted = saveData()
        return inserted
    }
    
    func insertEntities<T: CoreDataEntityRequiere>(entitiesData : [T], entityName: CoreDataEntity) -> Bool {
        for data in entitiesData {
            let successInsert = self.save(entityData: data, entityName: entityName)
            if (!successInsert) {
                return false
            }
        }
        let inserted = saveData()
        return inserted
    }
    
    private func save<T: CoreDataEntityRequiere>(entityData : T, entityName: CoreDataEntity) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue , in: context) else {
            return false
        }
        let newData =  NSManagedObject(entity: entity, insertInto: context)
        newData.setValuesForKeys(entityData.getDataModel())
        return true
    }
    
    private func saveData() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
