//
//  Task.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 22/06/22.
//

import Foundation

struct Task {
    let id : UUID
    var name : String
    var finished : Bool
    var initDate : Date
    var finishDate : Date
    
    init(name: String, initDate: Date, finishDate: Date) {
        self.id = UUID.init()
        self.name = name
        self.finished = false
        self.initDate = initDate
        self.finishDate = finishDate
    }
    
    init(name: String, finished: Bool, initDate: Date, finishDate: Date) {
        self.id = UUID.init()
        self.name = name
        self.finished = finished
        self.initDate = initDate
        self.finishDate = finishDate
    }
    
}
