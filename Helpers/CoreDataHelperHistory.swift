//
//  CoreDataHelperHistory.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 8/1/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//

import Foundation
import UIKit
import CoreData
struct CoreDataHelperHistory{
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    
    static func retreiveHistory() -> [History]{
        do{
            let fetchRequest = NSFetchRequest<History>(entityName: "History")
            let results = try CoreDataHelper.context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return[]
        }
        
    }
    static func saveHistory(history: History) {

        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func newHistory() -> History {
        let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context) as! History
        return history
        
    }
    static func retrieveMyHistory() -> History? {
        
        let idd = UserDefaults.standard.value(forKey: "IDD")
        if idd != nil {
            let idd = idd as! String
            let allHistory = CoreDataHelperHistory.retreiveHistory()
            let myHistory = allHistory.filter({$0.idd == idd})
            if !myHistory.isEmpty{
                return myHistory.first
            }
        }
        let history = newHistory()
        return history
        
    }
    static func delete(history: History) {
        context.delete(history)
        
        saveHistory(history: history)
    }
    static func deleteAll(history: [History]){
        for i in history {
            context.delete(i)
            saveHistory(history: i)
        }

    }
    
}
