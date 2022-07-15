//
//  FirestoreEntityRequiere.swift
//  Time Boxing App
//
//  Created by Julio Perez on 13/07/22.
//

import Foundation

protocol FirestoreEntityRequiere {
    static func getCollectionName() -> String
    func getIdentifier() -> String
}
