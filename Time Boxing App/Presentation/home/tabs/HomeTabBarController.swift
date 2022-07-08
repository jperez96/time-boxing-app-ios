//
//  HomeTabBarController.swift
//  Time Boxing App
//
//  Created by Julio Perez on 8/07/22.
//

import Foundation
import UIKit

class HomeTabBarController : UITabBarController {
    
    var customTabBarView = UIView(frame: .zero)

    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.setupTabBarUI()
       }
       
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           self.setupCustomTabBarFrame()
       }
              
       private func setupCustomTabBarFrame() {
           let height = self.view.safeAreaInsets.bottom + 60
           
           var tabFrame = self.tabBar.frame
           tabFrame.size.height = height
           tabFrame.origin.y = self.view.frame.size.height - height
           
           self.tabBar.frame = tabFrame
           self.tabBar.setNeedsLayout()
           self.tabBar.layoutIfNeeded()
           customTabBarView.frame = tabBar.frame
       }
       
       private func setupTabBarUI() {
           self.tabBar.layer.cornerRadius = 24
           self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           self.tabBar.backgroundColor = .fifth
           self.tabBar.tintColor = .white
           self.tabBar.unselectedItemTintColor = UIColor.tertiary
       }
}
