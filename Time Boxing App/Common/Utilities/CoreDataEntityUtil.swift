//
//  CoreDataEntityUtil.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 25/06/22.
//

import Foundation
import CoreData

protocol CoreDataEntityRequiere {
    func getDataModel() -> [String: Any]
    func getIdentifierPredicate() -> NSPredicate
    static func getEntityName() -> String
    static func cast<T>(_ entity : NSManagedObject) -> T?
}
