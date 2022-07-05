//
//  CodableUtil.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 24/06/22.
//

import Foundation

class CodableUtil {
    
    static func encondeObject<T: Codable>(_ data: T) -> Data? {
        do {
            let enconder = JSONEncoder()
            return try enconder.encode(data)
        } catch {
          return nil
        }
    }
    
    static func decodeObject<T: Codable>(_ data: Data?) -> T? {
        do {
            let decoder = JSONDecoder()
            guard let data = data else {
                return nil
            }
            return try decoder.decode(T.self, from: data)
        } catch {
          return nil
        }
    }
    
    static func toJsonString<T: Codable>(_ object: T) -> String? {
        guard let data = self.encondeObject(object) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    static func toObject<T: Codable>(_ data: Data, _ type: T.Type) -> T? {
        return self.decodeObject(data)
    }
    
}
