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
    
}
