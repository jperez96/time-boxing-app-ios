//
//  FirebaseUserEntity.swift
//  Time Boxing App
//
//  Created by Julio Perez on 14/07/22.
//

import Foundation

struct FirebaseUserEntity: Codable {
    let user: User
    let tasks: [Task]
    let routines : [Routine]
    let configuration: Configuration
    
    enum CodingKeys: String, CodingKey {
        case user
        case tasks
        case routines
        case configuration
    }
}

extension FirebaseUserEntity : FirestoreEntityRequiere {
    
    static func getCollectionName() -> String {
        return FirebaseEntity.User.rawValue
    }
    
    func getIdentifier() -> String {
        return self.user.email ?? UUID.init().uuidString
    }
    
}
