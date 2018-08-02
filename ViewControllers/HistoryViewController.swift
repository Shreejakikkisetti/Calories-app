//
//  HistoryViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 7/24/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import UIKit
class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var history: History?
    var historyItems = [History]()

    
    var dates = [Date]() {
        didSet {
            tableView.reloadData()
        }
    }
    var calories = [Double]() {
        didSet {
            tableView.reloadData()
        }
    }


    @IBOutlet weak var HistoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        historyItems.removeAll()
        calories.removeAll()
        dates.removeAll()
        
        historyItems = CoreDataHelperHistory.retreiveHistory()
        for i in historyItems{
            
            dates.append(i.date!)
            calories.append(Double(i.calories))
        }
        
        print(historyItems)
        tableView.reloadData()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let date = dates[indexPath.row]
        let calorie = calories[indexPath.row]
        cell.calories.text = String(calorie)
        cell.date.text = date.toString(dateFormat: "dd-MM")
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            let historyToDelete = historyItems[indexPath.row]
            CoreDataHelperHistory.delete(history: historyToDelete)
            historyItems = CoreDataHelperHistory.retreiveHistory()
            dates.remove(at: indexPath.row)
            calories.remove(at: indexPath.row)
            
  
            
            tableView.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50.0
    }

}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
