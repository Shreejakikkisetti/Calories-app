//
//  MainTabBarController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 7/24/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    
    }

    
    
}
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
