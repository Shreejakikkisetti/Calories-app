//
//  HomeViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 7/24/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var totalCalories: Double = 2000
    var cals: Double = 0
    var caloriesInTotal: Double = 0
    var profile: Profile?
    var history : History!
    var historyArray = [History]()
    
    @IBOutlet weak var calorieAmount: UILabel!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodItemTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var NewDay: UIButton!
    
    func getButton() -> UIButton {
        return NewDay
    }
    var text = ProfileViewController()
    
    
    
    var numDouble: Double = 0.0
    var foodItem: String = ""
    
    
    var foods = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var calories = [Double](){
        didSet{
            tableView.reloadData()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profile = CoreDataHelper.retrieveMyProfile()

        guard let passedProfile = profile else {return}
        
        cals = passedProfile.cals
        var sum: Double = 0
        for i in calories{
            sum += i
        }
        
        totalCalories = passedProfile.cals - sum
        if totalCalories < 0{
            //            if alreadyPresentedTooManyCaloriesMessageForToday == false {
            totalCaloriesLabel.text = "0"
            let alert = UIAlertController(title: "Too many Calories", message: "Oops, it seems like you went over your calorie range, try better tomorrow", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
            //                alreadyPresentedTooManyCaloriesMessageForToday = true
            //            }
        }
        else{
            totalCaloriesLabel.text = String(totalCalories)
            
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        if let food = defaults.array(forKey: "FoodItemsArray") as? [String] {
            foods = food
        }
        if let calorie = defaults.array(forKey: "CaloriesArray") as? [Double] {
            calories = calorie
        }
        if let c = defaults.double(forKey: "totalCaloriesLabel") as? Double {
            totalCalories = c
        }
        if let c = defaults.double(forKey: "InTotal") as? Double {
            caloriesInTotal = c
        }
        if(totalCalories>=0){
            totalCaloriesLabel.text = String(totalCalories)
        }
        else{
            totalCaloriesLabel.text = "0"
        }
        calorieAmount.text = String(caloriesInTotal)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        //check if text fields are empty, if yes display an alert
        if(foodItemTextField.text?.count==0 || caloriesTextField.text?.count==0){
            let alert = UIAlertController(title: "Incomplete information", message: "Oops, it seems like you did not fill in everything, try to enter a food item and the calories", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            //check if food text field has text
            if let foodItm = foodItemTextField.text {
                foodItem = foodItm
            }
            
            //check if nCalories text field has text
            if let num = caloriesTextField.text {
                
                //checks if num text is a number
                if let numDbl = num.toDouble() {
                    
                    numDouble = numDbl
                    
                    //update the total calories and update the total calories label
                    totalCalories = totalCalories - numDouble
                    caloriesInTotal = caloriesInTotal + numDouble
                    calorieAmount.text = String(caloriesInTotal)
                    
                    //check if the new entry is not putting the total calories over the daily limit
                    if(totalCalories>=0) {
                        totalCaloriesLabel.text = String(totalCalories)
                    } else {
                        
                        //set calories label to zero and display message
                        totalCaloriesLabel.text = "0"
                        let alert = UIAlertController(title: "Too many Calories", message: "Oops, it seems like you went over your calorie range, try better tomorrow", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    //regardless of too many calories or not, record the new entry
                    foods.append(foodItem)
                    calories.append(numDouble)
                    defaults.set(totalCaloriesLabel.text, forKey: "totalCaloriesLabel")
                    defaults.set(totalCalories, forKey: "totalCaloriesLabel")
                    defaults.set(foods, forKey: "FoodItemsArray")
                    defaults.set(calories, forKey: "CaloriesArray")
                    defaults.set(caloriesInTotal, forKey: "InTotal")
                    tableView.reloadData()
                    
                    //reset the text fields
                    foodItemTextField.text = ""
                    caloriesTextField.text = ""
                } else {
                    
                    //invalid calories text
                    let alert = UIAlertController(title: "Incorrect calorie amount", message: "Oops, it seems like you did not put in a number for calories", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
                print(foods)
                print(calories)
                
            }
        }
        
    }
    
    @IBAction func NewDay(_ sender: UIButton) {
        totalCaloriesLabel.text = String(cals)
        history = CoreDataHelperHistory.retrieveMyHistory()
        totalCalories = Double(Int(cals))
        foods.removeAll()
        calories.removeAll()
        history.date = Date() // assigns the current time and date
        print(caloriesInTotal)
        history.calories = caloriesInTotal

        caloriesInTotal = 0
        calorieAmount.text = "0"
        defaults.set(totalCaloriesLabel.text, forKey: "totalCaloriesLabel")
        defaults.set(totalCalories, forKey: "totalCaloriesLabel")
        defaults.set(foods, forKey: "FoodItemsArray")
        defaults.set(calories, forKey: "CaloriesArray")
        defaults.set(caloriesInTotal, forKey: "InTotal")
        CoreDataHelperHistory.saveHistory(history: history!)

        // deleting the entry altogether if it has nil values
        // or just prevent peopl
 
        
    }
    
}


// FIXME: Refactor and move to util file
extension String {
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue
    }
    func toInt() -> Int? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.intValue
        
    }
    func isInt() -> Bool {
        
        if let intValue = Int(self) {
            
            if intValue >= 0 {
                return true
            }
        }
        
        return false
    }
    
    func isFloat() -> Bool {
        
        if let floatValue = Float(self) {
            
            if floatValue >= 0 {
                return true
            }
        }
        
        return false
    }
    
    func isDouble() -> Bool {
        
        if let doubleValue = Double(self) {
            
            if doubleValue >= 0 {
                return true
            }
        }
        
        return false
    }
    
    func numberOfCharacters() -> Int {
        return self.characters.count
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTableViewCell", for: indexPath) as! FoodTableViewCell
        print(calories.count)
        let food = foods[indexPath.row]
        let calorie = calories[indexPath.row]
        cell.foodName.text = food
        cell.calories.text = String(calorie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            
            totalCalories = totalCalories + calories[indexPath.row]
            totalCaloriesLabel.text = String(totalCalories)
            caloriesInTotal = caloriesInTotal - calories[indexPath.row]
            calorieAmount.text = String(caloriesInTotal)
            calories.remove(at: indexPath.row)
            foods.remove(at: indexPath.row)
            
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;
    }
    
    
}


