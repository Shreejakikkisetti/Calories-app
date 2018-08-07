//
//  ShowCaloriesViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 8/7/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import Foundation
import UIKit
class ShowCaloriesViewController: UIViewController {
    var profile : Profile!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profile = CoreDataHelper.retrieveMyProfile()
        if profile.cals == 0 {
            calories.text = "0"
        }
        else {
            calories.text = String(profile.cals)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    @IBOutlet weak var calories: UILabel!
    
}


