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
    @IBOutlet weak var heavy: UIButton!
    @IBOutlet weak var moderate: UIButton!
    @IBOutlet weak var light: UIButton!
    @IBOutlet weak var little: UIButton!
    @IBOutlet weak var weightTextBox: UITextField!
    @IBOutlet weak var ageTextBox: UITextField!
    @IBOutlet weak var heightTextBox: UITextField!
    var weight: Int?
    var age: Int?
    var height: Int?
    var saveCheck = false
    static var MyCaloriesAmount: Int = 0
    
    var activityValue = 0.0
    var segmentedControlIndex: Int?
    var weightString = ""
    var profile : Profile!
    let white = UIColor(rgb: 0xF9F8F0)  // BE5300 is the hex value
    let darkPink = UIColor(rgb: 0x8884FF)

    

    
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

        if ((profile.activityRate?.isEmpty) == false){
            check = true
        }
        
    }

    
    @IBOutlet var profileView: UIView!
    var littleBool = false
    var lightBool = false
    var moderateBool = false
    var heavyBool = false

    
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

        check = true
        gndercheck = true
        weightTextBox.text = ""
        ageTextBox.text = ""
        heightTextBox.text = ""
        light.backgroundColor = white
        little.backgroundColor = white
        moderate.backgroundColor = white
        heavy.backgroundColor = white

        little.setTitleColor(darkPink, for: .normal)
        light.setTitleColor(darkPink, for: .normal)
        moderate.setTitleColor(darkPink, for: .normal)
        heavy.setTitleColor(darkPink, for: .normal)


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
       
        // verify everything is correctly formatted
    
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
            /*
             let dbl = 2.4
             let isInteger = floor(dbl) == dbl
             
             }
            */
            if let wDbl = w.toDouble(), let aDbl = a.toDouble(), let hDbl = h.toDouble() {
                
                let wdbl = wDbl
                let isWeightInteger = floor(wdbl) == wdbl
                
                let adbl = aDbl
                let isAgeInteger = floor(adbl) == adbl
                
                let hdbl = hDbl
                let isHeightInteger = floor(hdbl) == hdbl
                if wDbl > 8 && hDbl > 8 && aDbl > 0 && isWeightInteger && isAgeInteger && isHeightInteger && wDbl < 2000 && aDbl < 300 && hDbl < 300 {
                if (weightTextBox.text?.count)!>=1 && (ageTextBox.text?.count)!>=1  && (heightTextBox.text?.count)!>=1 {
                    saveButtonAlert()
                    weight = Int(wDbl)
                    weightString = String(weight!)
                    age = Int(aDbl)//CHANGE
                    height = Int(hDbl)
                    var BMR = 0.0
                    profile?.weight = Int32(weight!)
                    profile?.height = Int32(height!)
                    profile?.age = Int32(age!)
                    if genderCheck == "Female"{
                        var weighttemp  = 4.35 * Double(weight!)
                        var heighttemp = 4.7 * Double(height!)
                        var agetemp = 4.7 * Double(age!)
                        BMR = 655 + weighttemp + heighttemp - agetemp
                    }
                        
                    else {
                        var weighttemp  = 6.23 * Double(weight!)
                        var heighttemp = 12.7 * Double(height!)
                        var agetemp = 6.8 * Double(age!)
                        BMR = 66 + (weighttemp) + (heighttemp) - (agetemp)
                    }
                    
                    ProfileViewController.MyCaloriesAmount = Int(BMR * activityValue)
                    print(ProfileViewController.MyCaloriesAmount)
                    print("hello")
                    profile.cals = Int32(ProfileViewController.MyCaloriesAmount)
                    CoreDataHelper.saveProfile(profile: profile)
                    print("\(profile.cals) : -----" )

                }
                   
                }
                else {
                  inaccurateInfo()
                    return
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
        let alert = UIAlertController(title: "Saved!", message: "Congratualations, you have saved all your information accurately, click ok and navigate to the home button to continue!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.performSegue(withIdentifier: "toSHowCal", sender: nil)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func inaccurateInfo() {
        let alert = UIAlertController(title: "Inacurrate Information", message: "Make sure all your numbers are sensible positive integers", preferredStyle: UIAlertControllerStyle.alert)
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
       // if little.backgroundColor == UIColor.red && little.isTouchInside {
         //  little.backgroundColor = UIColor.white
      //  }
    }
    
    @IBAction func unwindtoChoosingMethod(_ segue: UIStoryboardSegue){
        
    }
    

    @IBAction func questionAsked(_ sender: UIButton) {

    }
    enum activities: String {
        case little = "little to none"
        case light = "light(1-3 days)"
        case moderate = "moderate(3-5 days)"
        case heavy = "heavy(6-7 days)"
    }
    func littleAction() {
        littleBool = true
        lightBool = false
        moderateBool = false
        heavyBool = false

        profile?.activityRate = "little"
        if littleBool == true{
            little.backgroundColor = darkPink
            light.backgroundColor = white
            moderate.backgroundColor = white
            heavy.backgroundColor = white

            
            little.setTitleColor(white, for: .normal)
            light.setTitleColor(darkPink, for: .normal)
            moderate.setTitleColor(darkPink, for: .normal)
            heavy.setTitleColor(darkPink, for: .normal)

            
            
        }
        activityValue = 1.2
    }
    func lightAction() {
        littleBool = false
        lightBool = true
        moderateBool = false
        heavyBool = false

        profile?.activityRate = "light"
        if lightBool == true{
            little.backgroundColor = white
            light.backgroundColor = darkPink
            moderate.backgroundColor = white
            heavy.backgroundColor = white
            
            little.setTitleColor(darkPink, for: .normal)
            light.setTitleColor(white, for: .normal)
            moderate.setTitleColor(darkPink, for: .normal)
            heavy.setTitleColor(darkPink, for: .normal)

        }
        activityValue = 1.375
    }
    func moderateAction() {
        littleBool = false
        lightBool = false
        moderateBool = true
        heavyBool = false

        profile?.activityRate = "moderate"
        if moderateBool == true{
            little.backgroundColor = white
            light.backgroundColor = white
            moderate.backgroundColor = darkPink
            heavy.backgroundColor = white

            
            little.setTitleColor(darkPink, for: .normal)
            light.setTitleColor(darkPink, for: .normal)
            moderate.setTitleColor(white, for: .normal)
            heavy.setTitleColor(darkPink, for: .normal)

        }
        activityValue = 1.55
    }
    
    func heavyAction() {
        littleBool = false
        lightBool = false
        moderateBool = false
        heavyBool = true

        profile?.activityRate = "heavy"
        if heavyBool == true{
            little.backgroundColor = white
            light.backgroundColor = white
            moderate.backgroundColor = white
            heavy.backgroundColor = darkPink

            
            little.setTitleColor(darkPink, for: .normal)
            light.setTitleColor(darkPink, for: .normal)
            moderate.setTitleColor(darkPink, for: .normal)
            heavy.setTitleColor(white, for: .normal)

        }
        activityValue = 1.725
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
        default :
            print("hi")

        }
    }

    func getCals() -> Int{
        print(profile?.cals)
         print(ProfileViewController.MyCaloriesAmount)
        print("my logic works")
        if let p = profile?.cals {
            return Int(p)
        }
        return 100
    }
    
    


    
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
extension UIColor {
    
    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
