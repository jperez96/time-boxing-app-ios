//
//  DefaultButton.swift
//  Time Boxing App
//
//  Created by Julio Perez on 6/07/22.
//

import Foundation
import UIKit

class BaseButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpView() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .fifth
        let defaultWidth = ButtonConstans.defaultWidth.rawValue
        self.frame.size = .init(width: self.frame.size.width, height: CGFloat(defaultWidth))
    }
    
    func setIcon(_ icon : UIImage ) {
        self.imageView?.contentMode = .left
        self.setImage(icon, for: .normal)
        self.configuration?.imagePadding = 8
    }
    
}
