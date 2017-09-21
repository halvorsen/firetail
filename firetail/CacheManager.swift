//
//  CashingManager.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/20/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import CoreData
import Foundation

struct DataSet {
    
    var ticker: String
    var price: [Double]
    var month: [String]
    var day: [Int]
    
}

class CacheManager {
    
    private var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "firetail")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveStockData(ticker: String, prices: [Double], days: [Int], months: [String]) {
        
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity1", into: context)
        entity.setValue(ticker, forKey: "string1")
        entity.setValue(prices, forKey: "prices")
        entity.setValue(days, forKey: "days")
        entity.setValue(months, forKey: "months")
        do {
            try context.save()
        } catch {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
 
    func loadData() -> [DataSet] {
        var resultsDataRequest = [AnyObject]()
        var data = [DataSet]()
        
        let context = persistentContainer.viewContext
        
        let dataRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        
        do { resultsDataRequest = try context.fetch(dataRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        
        if resultsDataRequest.count > 0 {
            for result in resultsDataRequest {
                if let ticker = result.value(forKey: "string1") as? String,
                let myPrices = result.value(forKey: "prices") as? [Double],
                    let myDays = result.value(forKey: "days") as? [Int],
                    let myMonths = result.value(forKey: "months") as? [String] {
        
                let dataEntry = DataSet(ticker: ticker, price: myPrices, month: myMonths, day: myDays)
                data.append(dataEntry)
                print("ticker: \(ticker)")
                print("days: \(myDays)")
                print("months: \(myMonths)")
                print("prices: \(myPrices)")
                }
                
            }
        }
        return data
    }
    
    func eraseAllStockCashe() {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)  //(deleteRequest, withContext: context)
        } catch let error as NSError {
            // TODO: handle the error
        }

        
    }
    
}
