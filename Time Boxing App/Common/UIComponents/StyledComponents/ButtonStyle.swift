//
//  Extensions.swift
//  Time Boxing App
//
//  Created by Julio Perez on 6/07/22.
//

import Foundation
import UIKit

extension BaseButton {
    
    func setStyle() {
        self.setUpView()
        self.backgroundColor = .fifth
        self.titleLabel?.tintColor = .white
        self.tintColor = .white
    }
    
    func setLoginGoogleStyle() {
        self.setUpView()
        guard let googleIcon = UIImage(named: "icon_google")?.resizeImageTo(size: .init(width: 25, height: 25)) else {
            return
        }
        self.setIcon(googleIcon)
        self.backgroundColor = .white
        self.titleLabel?.tintColor = .black
    }
    
}
