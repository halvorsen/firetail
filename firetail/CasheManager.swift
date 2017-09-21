//
//  CashingManager.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/20/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import CoreData

class casheManager {

    func saveStockData(ticker: String, data: ([(price:Double,month:String,day:Int)])) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity1", into: context)
        entity.setValue(ticker, forKey: "string1")
        entiry.setValue(data, forKey: "trans1")
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
    
    struct DataSet {
        
        var ticker: String
        var price: [Double]
        var dateData: [(month:String,day:Int)]
        
    }
    
    func loadData() -> [DataSet] {
        var resultsDataRequest = [AnyObject]()
        var data = [DataSet]()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let dataRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        
        do { resultsDataRequest = try context.fetch(nameRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        
        if resultsDataRequest.count > 0 {
            for result in resultsDataRequest {
            let ticker = resultsDataRequest.value(forKey: "string1") as! String
            let data = resultsDataRequest.value(forKey: "trans1") as! [(price:Double,month:String,day:Int)]
                print("ticker: \(ticker)")
                print("data: \(data)")
            }
        }
    }
    
    func eraseData() {
        
        
    }
    
}
