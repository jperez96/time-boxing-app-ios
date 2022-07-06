//
//  Extensions.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 23/06/22.
//

import Foundation

extension Date {
    func string(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    func getWeekDay() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    func getHour() -> Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    func toDateString(_ format : DateFormat) -> String{
        return self.string(format: format)
    }
    
}

extension Optional {
    func isNull() -> Bool {
        return self == nil
    }
    func isNotNull() -> Bool {
        return !self.isNull()
    }
}
