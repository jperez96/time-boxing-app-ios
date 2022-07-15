//
//  GoogleFirestoreManager.swift
//  Time Boxing App
//
//  Created by Julio Perez on 13/07/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GoogleFirestoreManager {
    
    private var firebaseContext : Firestore
    private var collection : CollectionReference
    typealias FirebaseTypeRequiered = FirestoreEntityRequiere & Codable
    
    init(_ collection : String) {
        self.firebaseContext = Firestore.firestore()
        self.collection = self.firebaseContext.collection(collection)
    }
    
    func saveDocument<T : FirebaseTypeRequiered> (_ entity: T, _ completion: (BaseResponse<Bool>) -> Void){
        do {
            try self.collection.document(entity.getIdentifier()).setData(from: entity)
            completion(.success(data: true))
        } catch let error{
            print(error)
            completion(.error(msg: error.localizedDescription))
        }
    }
    
    func getDocument<T : FirebaseTypeRequiered> (_ identifier: String, _ type: T.Type,  _ completion: @escaping (BaseResponse<T>) -> Void) {
        self.collection.document(identifier).getDocument(as: T.self) { result in
            switch result {
                case .success(let result): completion(.success(data: result))
                case .failure(let error): completion(.error(msg: error.localizedDescription))
            }
        }
    }
    
    func removeDocument<T: FirebaseTypeRequiered>(_ entity: T, _ completion: @escaping (BaseResponse<Bool>) -> Void) {
        self.collection.document(entity.getIdentifier()).delete() { error in
            if error.isNull() {
                completion(.success(data: true))
            } else {
                print(error!)
                completion(.error(msg: error!.localizedDescription))
            }
        }
    }
}
