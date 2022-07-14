//
//  CalendaryLabelView.swift
//  Time Boxing App
//
//  Created by Julio Perez on 13/07/22.
//

import UIKit

class CalendaryLabelView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed("CalendaryLabelItem", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
}
