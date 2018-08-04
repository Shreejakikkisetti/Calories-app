//
//  ProfileViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 7/24/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var window: UIWindow?
    let defaults = UserDefaults.standard
    var genderVal = 0.0
    @IBOutlet weak var gender: UISegmentedControl!
    var genderCheck = ""
    @IBOutlet var activityButtons: [UIButton]!
    var check = false
    var gndercheck = true
    @IBOutlet weak var veryHeavy: UIButton!
    @IBOutlet weak var heavy: UIButton!
    @IBOutlet weak var moderate: UIButton!
    @IBOutlet weak var light: UIButton!
    @IBOutlet weak var little: UIButton!
    @IBOutlet weak var weightTextBox: UITextField!
    @IBOutlet weak var ageTextBox: UITextField!
    @IBOutlet weak var heightTextBox: UITextField!
    var weight: Double?
    var age: Int?
    var height: Double?
    var saveCheck = false
    static var MyCaloriesAmount: Double = 0
    
    var activityValue = 0.0
    var segmentedControlIndex: Int?
    var weightString = ""
    var profile : Profile!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
         // Do any additional setup after loading the view, typically from a nib.
 
        //ASK HERE
        self.profile = CoreDataHelper.retrieveMyProfile()
        if profile.age > 0{
            ageTextBox.text = String(profile.age)
        }
        else {
            ageTextBox.text = ""
        }
        if profile.weight > 0{
            weightTextBox.text = String(profile.weight)
        }
        else {
            weightTextBox.text = ""
        }
        if profile.height > 0{
            heightTextBox.text = String(profile.height)
        }
        else{
            heightTextBox.text = ""
        }
        caloriesLabel.text = String(profile.cals)
        if profile.gender == "Male"{
            gender.selectedSegmentIndex = 0
        }
        if profile.gender == "Female"{
            gender.selectedSegmentIndex = 1
        }
        if profile.activityRate == "light"{
            lightAction()
        }
        if profile.activityRate == "little"{
            littleAction()
        }
        if profile.activityRate == "moderate"{
            moderateAction()
        }
        if profile.activityRate == "heavy"{
            heavyAction()
        }
        if profile.activityRate == "veryHeavy"{
            veryHeavyAction()
        }
//        if ((profile.activityRate?.isEmpty)! == false){
//            check = true
//      }
        
    }

    
    @IBOutlet var profileView: UIView!
    var littleBool = false
    var lightBool = false
    var moderateBool = false
    var heavyBool = false
    var veryHeavyBool = false
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        print("Help button was pressed!")
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        //        let pg: PageViewController = PageViewController()
        //        pg.viewDidLoad()
        //        pg.configurePageControl()
        
        let pg: ViewController = ViewController()
        pg.viewDidLoad()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        weight = 0
        age = 0
        height = 0
        ProfileViewController.MyCaloriesAmount = 0
        activityValue = 0
        littleBool = false
        lightBool = false
        moderateBool = false
        heavyBool = false
        veryHeavyBool = false
        check = true
        gndercheck = true
        weightTextBox.text = ""
        ageTextBox.text = ""
        heightTextBox.text = ""
        light.backgroundColor = UIColor.white
        little.backgroundColor = UIColor.white
        moderate.backgroundColor = UIColor.white
        heavy.backgroundColor = UIColor.white
        veryHeavy.backgroundColor = UIColor.white
        profile.weight = 0
        profile.height = 0
        profile.age = 0
        profile.activityRate = ""
        profile.gender = "Male"
        profile.cals = 0
        weightTextBox.text = ""
        ageTextBox.text = ""
        heightTextBox.text = ""
        genderCheck = "Male"
        little.backgroundColor = UIColor.white
        caloriesLabel.text = ""
    }
    
    
    func notFavorited(button: UIButton) {
        button.isSelected = false
        button.backgroundColor = UIColor.white
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func genderSelected(_ sender: Any) {

        switch gender.selectedSegmentIndex{
        case 0:
            genderCheck = "Male"
            segmentedControlIndex = 0
            profile?.gender = "Male"
        default:
            genderCheck = "Female"
            segmentedControlIndex = 1
            profile?.gender = "Female"
        }

    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("SAVE BUTTON PRESSED")
        let allP = CoreDataHelper.retreiveProfile()
        
        
        if((weightTextBox.text?.count)! > 0 && (ageTextBox.text?.count)! > 0 && (heightTextBox.text?.count)! > 0 && check == true) {
        }
        else{
            
            let alert = UIAlertController(title: "Incomplete information", message: "Oops, it seems like you did not fill in everything, make sure you answer all the questions before saving!", preferredStyle: UIAlertControllerStyle.alert)
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
        
        if let w = weightTextBox.text, let a = ageTextBox.text, let h = heightTextBox.text {
            if let wDbl = w.toDouble(), a.isInt(), let hDbl = h.toDouble() {//CHANGE
                if wDbl > 8 && hDbl > 10 && a.toInt()! > 0{
                if (weightTextBox.text?.count)!>=1 && (ageTextBox.text?.count)!>=1  && (heightTextBox.text?.count)!>=1 {
                    saveButtonAlert()
                    weight = wDbl
                    weightString = String(weight!)
                    age = Int(a)//CHANGE
                    height = hDbl
                    var BMR = 0.0
                    profile?.weight = weight!
                    profile?.height = height!
                    profile?.age = Int16(age!)
                    if genderCheck == "Female"{
                        var weighttemp  = 4.35 * weight!
                        var heighttemp = 4.7 * height!
                        var agetemp = 4.7 * Double(age!)
                        BMR = 655 + weighttemp + heighttemp - agetemp
                    }
                        
                    else {
                        var weighttemp  = 6.23 * weight!
                        var heighttemp = 12.7 * height!
                        var agetemp = 6.8 * Double(age!)
                        BMR = 66 + (weighttemp) + (heighttemp) - (agetemp)
                    }
                    
                    ProfileViewController.MyCaloriesAmount = BMR * activityValue
                    print(ProfileViewController.MyCaloriesAmount)
                    print("hello")
                    profile.cals = ProfileViewController.MyCaloriesAmount
                    CoreDataHelper.saveProfile(profile: profile)
                    print("\(profile.cals) : -----" )
                    caloriesLabel.text = String(profile.cals)
                }
                }
                else {
                  inaccurateInfo()
                }
            }
                
            else {
                inaccurateInfo()
            }
            
            
        }
        if profile?.id == nil{
            profile?.id = UUID().uuidString
        }
        CoreDataHelper.saveProfile(profile: profile!)
        let allPr = CoreDataHelper.retreiveProfile()

}
    
    func saveButtonAlert() {
        let alert = UIAlertController(title: "Saved!", message: "Congratualations, you have saved all your information accurately, click ok and navigate to the home button on the botton to continue!", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func inaccurateInfo() {
        let alert = UIAlertController(title: "Inacurrate Information", message: "Oops, it seems like you did not enter accurate number values for some of your questions, go back and make sure you answered the questions properly", preferredStyle: UIAlertControllerStyle.alert)
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
    
    @IBAction func littleButtonPressed(_ sender: Any) {
        little.backgroundColor = UIColor.red
       // if little.backgroundColor == UIColor.red && little.isTouchInside {
         //  little.backgroundColor = UIColor.white
      //  }
    }
    
    
    

    @IBAction func questionAsked(_ sender: UIButton) {
        activityButtons.forEach { (button) in
            button.isHidden =  !button.isHidden
        }
    }
    enum activities: String {
        case little = "little to none"
        case light = "light(1-3 days)"
        case moderate = "moderate(3-5 days)"
        case heavy = "heavy(6-7 days)"
        case veryHeavy = "very heavey(2 times a day)"
    }
    func littleAction() {
        littleBool = true
        lightBool = false
        moderateBool = false
        heavyBool = false
        veryHeavyBool = false
        profile?.activityRate = "little"
        if littleBool == true{
            little.backgroundColor = UIColor.red
            light.backgroundColor = UIColor.white
            moderate.backgroundColor = UIColor.white
            heavy.backgroundColor = UIColor.white
            veryHeavy.backgroundColor = UIColor.white
            
        }
        activityValue = 1.2
    }
    func lightAction() {
        littleBool = false
        lightBool = true
        moderateBool = false
        heavyBool = false
        veryHeavyBool = false
        profile?.activityRate = "light"
        if lightBool == true{
            little.backgroundColor = UIColor.white
            light.backgroundColor = UIColor.red
            moderate.backgroundColor = UIColor.white
            heavy.backgroundColor = UIColor.white
            veryHeavy.backgroundColor = UIColor.white
        }
        activityValue = 1.375
    }
    func moderateAction() {
        littleBool = false
        lightBool = false
        moderateBool = true
        heavyBool = false
        veryHeavyBool = false
        profile?.activityRate = "moderate"
        if moderateBool == true{
            little.backgroundColor = UIColor.white
            light.backgroundColor = UIColor.white
            moderate.backgroundColor = UIColor.red
            heavy.backgroundColor = UIColor.white
            veryHeavy.backgroundColor = UIColor.white
        }
        activityValue = 1.55
    }
    
    func heavyAction() {
        littleBool = false
        lightBool = false
        moderateBool = false
        heavyBool = true
        veryHeavyBool = false
        profile?.activityRate = "heavy"
        if heavyBool == true{
            little.backgroundColor = UIColor.white
            light.backgroundColor = UIColor.white
            moderate.backgroundColor = UIColor.white
            heavy.backgroundColor = UIColor.red
            veryHeavy.backgroundColor = UIColor.white
        }
        activityValue = 1.725
    }
    
    func veryHeavyAction() {
        littleBool = false
        lightBool = false
        moderateBool = false
        heavyBool = false
        veryHeavyBool = true
        profile?.activityRate = "veryHeavy"
        if veryHeavyBool == true{
            little.backgroundColor = UIColor.white
            light.backgroundColor = UIColor.white
            moderate.backgroundColor = UIColor.white
            heavy.backgroundColor = UIColor.white
            veryHeavy.backgroundColor = UIColor.red
        }
        activityValue = 1.9
        
    }
    
    
    @IBAction func actionTapped(_ sender: UIButton) {
        check = true
        guard let title = sender.currentTitle, let action = activities(rawValue: title)else {
            return
        }
        
       
        
        switch action {
        case .little:
            littleAction()
        case .light:
           lightAction()
        case .moderate:
           moderateAction()
        case .heavy:
            heavyAction()
        default:
            veryHeavyAction()

    }
    }

    func getCals() -> Double{
        print(profile?.cals)
         print(ProfileViewController.MyCaloriesAmount)
        print("my logic works")
        if let p = profile?.cals {
            return p
        }
        return 100
    }
    
    
    /*
     @IBAction func button_clicked(_ sender: UIButton) {
     self.performSegue(withIdentifier: "segueToNext", sender: self)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "segueToNext" {
     if let destination = segue.destination as? Modo1ViewController {
     destination.nomb = nombres // you can pass value to destination view controller
     
     // destination.nomb = arrayNombers[(sender as! UIButton).tag] // Using button Tag
     }
     }
     }
 */

    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
