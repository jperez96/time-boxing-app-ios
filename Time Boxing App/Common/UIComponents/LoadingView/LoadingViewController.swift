//
//  LoadingViewController.swift
//  Time Boxing App
//
//  Created by Julio Perez on 15/07/22.
//

import UIKit
import Lottie
class LoadingViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimation()
    }
    
    private func setAnimation() {
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
    }

}
