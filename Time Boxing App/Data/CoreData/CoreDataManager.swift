//
//  CoreDataUtil.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    private var appDelegate : AppDelegate
    private var context : NSManagedObjectContext
    
    init?(){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        self.appDelegate = delegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func insertEntity<T: CoreDataEntityRequiere>(entityData : T) -> Bool {
        let dataInserted = self.save(entityData: entityData)
        if(!dataInserted){
            return false
        }
        let inserted = saveData()
        return inserted
    }
    
    func insertEntities<T: CoreDataEntityRequiere>(entitiesData : [T]) -> Bool {
        for data in entitiesData {
            let successInsert = self.save(entityData: data)
            if (!successInsert) {
                return false
            }
        }
        let inserted = saveData()
        return inserted
    }
    
    func updateEntity<T: CoreDataEntityRequiere>(entityData : T) -> Bool {
        guard let dataToUpdate = self.findEntitiesByPredicate(entity: T.self, predicate: entityData.getIdentifierPredicate() ) else {
            return false
        }
        if (dataToUpdate.isEmpty) {
            return false
        }
        
        dataToUpdate.forEach { obj in
            obj.setValuesForKeys(entityData.getDataModel())
        }
        
        let updated = saveData()
        return updated
    }
    
    func removeEntity<T: CoreDataEntityRequiere>(entity: T) -> Bool {
        guard let results = findEntitiesByPredicate(entity: T.self, predicate: entity.getIdentifierPredicate()) else {
            return false
        }
        
        if (results.isEmpty){
            return false
        }
        
        for result in results {
            context.delete(result)
        }
        return saveData()
    }
    
    func findEntitiesByPredicate<T: CoreDataEntityRequiere>(entity: T.Type, predicate: NSPredicate) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity.getEntityName())
        request.predicate = predicate
        request.returnsObjectsAsFaults = true
        do {
            return try context.fetch(request)
        } catch {
            return nil
        }
    }
    
    func findEntitiesByPredicateCasted<T: CoreDataEntityRequiere>(entity: T.Type, predicate : NSPredicate) -> [T?] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity.getEntityName())
        request.predicate = predicate
        request.returnsObjectsAsFaults = true
        do {
            let data = try context.fetch(request)
            return castNSManagedObjectToObject(data)
        } catch let error{
            print(error)
            return []
        }
    }
    
    func findEntitiesCasted<T: CoreDataEntityRequiere>(entity: T.Type) -> [T?] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity.getEntityName())
        request.returnsObjectsAsFaults = true
        do {
            let data = try context.fetch(request)
            return castNSManagedObjectToObject(data)
        } catch let error{
            print(error)
            return []
        }
    }

    private func castNSManagedObjectToObject<T: CoreDataEntityRequiere>(_ listNs : [NSManagedObject]) -> [T?] {
        var list : [T?] = []
        for obj in listNs {
            list.append(T.cast(obj))
        }
        return list
    }
    
    private func save<T: CoreDataEntityRequiere>(entityData : T) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: T.getEntityName() , in: context) else {
            return false
        }
        let newData =  NSManagedObject(entity: entity, insertInto: context)
        newData.setValuesForKeys(entityData.getDataModel())
        return true
    }
    
    func nuke() {
        let storeContainer = appDelegate.persistentContainer.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch let error {
                print(error)
            }
        }
        appDelegate.persistentContainer = NSPersistentCloudKitContainer(
            name: "DataModel"
        )
        appDelegate.persistentContainer.loadPersistentStores {
            (store, error) in
            print(error ?? "")
        }
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
