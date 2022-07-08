//
//  CarouselItem.swift
//  Time Boxing App
//
//  Created by Julio Perez on 7/07/22.
//

import Foundation

import UIKit

@IBDesignable
class CarouselItem: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var carouselImage: UIImageView!
    @IBOutlet weak var carouselLabel: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    init( _ titleText: String? = "", _ image: UIImage?) {
        self.init()
        carouselLabel.text = titleText
        carouselImage.image = image
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed("CarouselItem", owner: self, options: nil)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(containerView)
    }
    
    
}

