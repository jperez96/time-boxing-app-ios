//
//  CheckBoxView.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 22/06/22.
//

import UIKit

protocol CheckBoxDelegate {
    func onChangeCheck(_ isCheck: Bool)
}

class CheckBoxView: UIButton {
    
    private let checkedIcon = UIImage(named: AssetsName.checkBoxChecked.rawValue)
    private let uncheckedIcon = UIImage(named: AssetsName.checkBoxUnchecked.rawValue)

    var delegate : CheckBoxDelegate?
    
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
        self.setImage(checkedIcon?.withRenderingMode(.alwaysOriginal) , for: .selected)
        self.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
    
    @objc func pressed() {
        self.isSelected = !self.isSelected
        delegate?.onChangeCheck(self.isSelected)
    }
    
}
