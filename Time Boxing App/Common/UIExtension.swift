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
}
