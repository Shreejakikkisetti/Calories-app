//
//  HistoryViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 7/24/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import UIKit

class HistoryViewController: HomeViewController {
    
    @IBOutlet weak var HistoryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func NewDay(_ sender: UIButton){
        HistoryLabel.text = "YASSS"
    }
    
}
