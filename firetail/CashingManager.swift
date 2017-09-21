//
//  CashingManager.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/20/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

class casheManager {

    func saveStockData(ticker: String, data: ([(price:Double,month:String,day:Int)])) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Info", into: context)
        entity.setValue(username, forKey: "username")
        do {
            try context.save()
        } catch {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func loadUsername() {
        var resultsNameRequest = [AnyObject]()
        
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let nameRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Info")
        
        do { resultsNameRequest = try context.fetch(nameRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        
        if resultsNameRequest.count > 0 {
            Set1.username = resultsNameRequest.last!.value(forKey: "username") as! String
        }
    }
    
}
