//
//  User.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 24/06/22.
//

import Foundation

struct User : Codable {
    var name : String
    let email : String?
    let loginType : Int
}
