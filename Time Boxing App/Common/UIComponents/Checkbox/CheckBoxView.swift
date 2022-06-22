//
//  CheckBoxView.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 22/06/22.
//

import UIKit

class CheckBoxView: UIButton {
    
    private let checkedIcon = UIImage(named: AssetsName.checkBoxChecked.rawValue)
    private let uncheckedIcon = UIImage(named: AssetsName.checkBoxUnchecked.rawValue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initButton()
    }
    
    func initButton() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.setTitle("", for: .normal)

        self.setImage(uncheckedIcon?.withRenderingMode(.alwaysOriginal) , for: .normal)
        self.setImage(checkedIcon?.withRenderingMode(.alwaysOriginal) , for: .highlighted)
        self.setImage(checkedIcon?.withRenderingMode(.alwaysOriginal) , for: .selected)
    }
    
    
}
