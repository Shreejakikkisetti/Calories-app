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
    var totalCalories: Int = 0
    var cals: Int = 0
    var caloriesInTotal: Int = 0
    var profile: Profile?
    var history : History!
    var historyArray = [History]()
    var warningcount = false
    
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
    
    
    
    var numInt: Int = 0
    var foodItem: String = ""
    
    
    var foods = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var calories = [Int](){
        didSet{
            tableView.reloadData()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profile = CoreDataHelper.retrieveMyProfile()

        guard let passedProfile = profile else {return}
        
        cals = Int(passedProfile.cals)
        var sum: Int = 0
        for i in calories{
            sum += i
        }
        
        totalCalories = Int(passedProfile.cals) - sum
        if totalCalories <= 0{

            totalCaloriesLabel.text = "0"
        }
        else{
            totalCaloriesLabel.text = String(totalCalories)
            
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self

        if let food = defaults.array(forKey: "FoodItemsArray") as? [String] {
            foods = food
        }
        if let calorie = defaults.array(forKey: "CaloriesArray") as? [Int] {
            calories = calorie
        }
        if let c = defaults.integer(forKey: "totalCaloriesLabel") as? Int {
            totalCalories = c
        }
        if let c = defaults.integer(forKey: "InTotal") as? Int {
            caloriesInTotal = c
        }
        if let c = defaults.bool(forKey: "warningcount") as? Bool {
            warningcount = c
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
                
                if let numDbl = num.toDouble(){
                    let dbl = numDbl
                    let isInteger = floor(dbl) == dbl
                    if numDbl >= 0 && numDbl < 10000 && isInteger {
                    numInt = Int(numDbl)

                    //update the total calories and update the total calories label
                    //HELP HERE
                    totalCalories = totalCalories - numInt
                        print("totalCalories\(totalCalories)")
                    caloriesInTotal = caloriesInTotal + numInt
                    calorieAmount.text = String(caloriesInTotal)
                    
                    //check if the new entry is not putting the total calories over the daily limit
                    if(totalCalories >= 0) {
                        totalCaloriesLabel.text = String(totalCalories)
                    }else {
                        totalCaloriesLabel.text = "0"
                        if warningcount == false || totalCalories <= 0{
                            wentOver()
                        }
                        else{

                        }
                    }
                    
                    //regardless of too many calories or not, record the new entry
                    foods.append(foodItem)
                    calories.append(numInt)
                    defaults.set(totalCaloriesLabel.text, forKey: "totalCaloriesLabel")
                    defaults.set(totalCalories, forKey: "totalCaloriesLabel")
                    defaults.set(foods, forKey: "FoodItemsArray")
                    defaults.set(calories, forKey: "CaloriesArray")
                    defaults.set(caloriesInTotal, forKey: "InTotal")
                    defaults.set(warningcount, forKey: "warningcount")
                    print("warning count \(warningcount)")
                    tableView.reloadData()
                    
                    //reset the text fields
                    foodItemTextField.text = ""
                    caloriesTextField.text = ""
                    }
                    else {
                        incorrectCalories()
                    }
                } else {
                    incorrectCalories()
                }
                print(foods)
                print(calories)
                
            }
        }
        }
    func wentOver () {
        totalCaloriesLabel.text = "0"
        if warningcount == false {
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
        defaults.set(warningcount, forKey: "warningcount")
        }
        defaults.set(warningcount, forKey: "warningcount")
    }
    
    func incorrectCalories() {
        let alert = UIAlertController(title: "Incorrect calorie amount", message: "Make sure you put an integer whole number for the calories", preferredStyle: UIAlertControllerStyle.alert)
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
    @IBAction func NewDay(_ sender: UIButton) {
        totalCaloriesLabel.text = String(cals)
        history = CoreDataHelperHistory.retrieveMyHistory()
        totalCalories = Int(Int(cals))
        foods.removeAll()
        calories.removeAll()
        history.date = Date() // assigns the current time and date
        print(caloriesInTotal)
        history.calories = Int32(caloriesInTotal)

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
 
        warningcount = false
    }
    
}


// FIXME: Refactor and move to util file
extension String {

    func toInt() -> Int? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.intValue
        
    }
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue
        
    }
    func isInt() -> Bool {
        
        if let intValue = Int(self) {
            
            if intValue >= 0 {
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

    func isFloat() -> Bool {
        
        if let floatValue = Float(self) {
            
            if floatValue >= 0 {
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
            if totalCalories >= 0{
            totalCaloriesLabel.text = String(totalCalories)
            }
            else{
                totalCaloriesLabel.text = "0"
            }
            if caloriesInTotal <= 0{
                calorieAmount.text = "0"
                caloriesInTotal = 0
            }
            if foods.count == 0 && calories.count == 0 {
                caloriesInTotal = 0
            }
            caloriesInTotal = caloriesInTotal - calories[indexPath.row]
            calorieAmount.text = String(caloriesInTotal)
            calories.remove(at: indexPath.row)
            foods.remove(at: indexPath.row)
            defaults.set(foods, forKey: "FoodItemsArray")
            defaults.set(calories, forKey: "CaloriesArray")
            defaults.set(totalCaloriesLabel.text, forKey: "totalCaloriesLabel")
            defaults.set(totalCalories, forKey: "totalCaloriesLabel")
            defaults.set(caloriesInTotal, forKey: "InTotal")
            tableView.reloadData()
            
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;
    }
    
    
}



