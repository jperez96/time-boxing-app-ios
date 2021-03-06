//
//  CarouselData.swift
//  Time Boxing App
//
//  Created by Julio Perez on 6/07/22.
//

import UIKit

struct CarouselData {
    let image: UIImage?
    let text: String
    
    init(_ image: UIImage, _ title: String) {
        self.image = image
        self.text = title
    }
}
