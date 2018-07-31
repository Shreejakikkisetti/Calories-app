//
//  CoreDataHelper.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 7/30/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import Foundation
import UIKit
import CoreData
struct CoreDataHelper{

        static let context: NSManagedObjectContext = {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError()
            }
            
            let persistentContainer = appDelegate.persistentContainer
            let context = persistentContainer.viewContext
            
            return context
        }()
    

    static func retreiveProfile() -> [Profile]{
        do{
            let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
            let results = try CoreDataHelper.context.fetch(fetchRequest)
           return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return[]
        }
        
    }
    static func saveProfile(profile: Profile) {
        UserDefaults.standard.set(profile.id, forKey: "ID")
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    static func retrieveMyProfile() -> Profile? {
        
        let id = UserDefaults.standard.value(forKey: "ID")
        if id != nil {
        let id = id as! String
        let allProfile = CoreDataHelper.retreiveProfile()
        let myprofile = allProfile.filter({$0.id == id})
        if !myprofile.isEmpty{
             return myprofile.first
        }
    }
            let profile = newProfile()
            return profile
        
}
    static func newProfile() -> Profile {
        let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as! Profile
        
        return profile
    }

}
