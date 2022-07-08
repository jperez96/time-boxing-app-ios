//
//  UIExtension.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 23/06/22.
//

import Foundation
import UIKit

extension UIButton {
    func setDateString(_ date: Date, _ adition : String = "", _ format : DateFormat = .format1) {
        var content = ""
        if (!adition.isEmpty) {
            content += "\(adition)\n"
        }
        content += date.string(format: format)
        self.setTitle(content, for: .normal)
    }
}

extension UITableView {
    func registerTaskCell(){
        self.register(UINib(nibName: "TaskCellTableViewCell", bundle: nil), forCellReuseIdentifier: CellViewName.task.rawValue)
    }
    
    func registerRoutineCell(){
        self.register(UINib(nibName: "RoutineCellTableViewCell", bundle: nil), forCellReuseIdentifier: CellViewName.routine.rawValue)
    }
}

extension UIImage {
    func
    resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension UIColor {
    
    static func colorPalette(_ name: String) -> UIColor {
        return UIColor(named: name) ?? .black
    }
    
    // Core Colors
    static var primary =  UIColor.colorPalette("primary")
    static var secundary = UIColor.colorPalette("secundary")
    static var tertiary = UIColor.colorPalette("tertiary")
    static var quaternary = UIColor.colorPalette("quaternary")
    static var fifth = UIColor.colorPalette("fifth")
    
    // TextField Colors
    static var bgTextField = UIColor.colorPalette("bg_grey_text_field")
    
}
