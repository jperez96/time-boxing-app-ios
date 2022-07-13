//
//  DefaultTextField.swift
//  Time Boxing App
//
//  Created by Julio Perez on 7/07/22.
//

import Foundation
import UIKit

class BaseTextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpView() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.bgTextField.cgColor
        self.tintColor = .black
    }
}
