//
//  LoadSaveCoreData.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import CoreData
import UIKit

class LoadSaveCoreData {
    
    func saveBlock(stockTicker: String, currentPrice: Double, sms: Bool, email: Bool, flash: Bool, urgent: Bool) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Block", into: context)
        entity.setValue(stockTicker, forKey: "ticker")
        entity.setValue(currentPrice, forKey: "alertPrice")
        entity.setValue(email, forKey: "alertEmail")
        entity.setValue(sms, forKey: "alertSMS")
        entity.setValue(flash, forKey: "alertFlash")
        entity.setValue(urgent, forKey: "alertUrgent")
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveBlockAmount(amount: Int) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "BlockAmount", into: context)
        entity.setValue(Int16(amount), forKey: "value")
        do { try context.save() } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func amount() -> Int {
        var resultsBlockAmounts = [AnyObject]()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let requestBlockAmounts = NSFetchRequest<NSFetchRequestResult>(entityName: "BlockAmount")
        
        do { resultsBlockAmounts = try context.fetch(requestBlockAmounts) } catch  {
            print("Could not cache the response \(error)")
        }
        if resultsBlockAmounts.count > 0 {
        let r = resultsBlockAmounts.last!.value(forKey: "value") as! Int
        
    return r
        } else {
            return 0}
    }
    
    func loadBlocks() -> (t: [String],p: [Double],email: [Bool],sms: [Bool],flash: [Bool],urgent: [Bool]) {
        var resultsBlocks = [AnyObject]()
        var resultsBlockAmounts = [AnyObject]()
        var tickers = [String]()
        var alertPrices = [Double]()
        var alertEmails = [Bool]()
        var alertSMSs = [Bool]()
        var alertFlashs = [Bool]()
        var alertUrgents = [Bool]()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let requestBlocks = NSFetchRequest<NSFetchRequestResult>(entityName: "Block")
        
        do { resultsBlocks = try context.fetch(requestBlocks) } catch  {
            print("Could not cache the response \(error)")
        }
        let requestBlockAmounts = NSFetchRequest<NSFetchRequestResult>(entityName: "BlockAmount")
        
        do { resultsBlockAmounts = try context.fetch(requestBlockAmounts) } catch  {
            print("Could not cache the response \(error)")
        }
        if resultsBlocks.count > 0 {
        let loadedBlockAmount = resultsBlockAmounts.last!.value(forKey: "value") as! Int
        
        for result in resultsBlocks.suffix(loadedBlockAmount) { //gets the last few blocks
            if let ticker = result.value(forKey: "ticker") as! String? {tickers.append(ticker)}
            if let alertPrice = result.value(forKey: "alertPrice") as! Double? {alertPrices.append(alertPrice)}
            if let alertEmail = result.value(forKey: "alertEmail") as! Bool? {alertEmails.append(alertEmail)}
            if let alertSMS = result.value(forKey: "alertSMS") as! Bool? {alertSMSs.append(alertSMS)}
            if let alertFlash = result.value(forKey: "alertFlash") as! Bool? {alertFlashs.append(alertFlash)}
            if let alertUrgent = result.value(forKey: "alertUrgent") as! Bool? {alertUrgents.append(alertUrgent)}
            
        }
        return (tickers,alertPrices,alertEmails,alertSMSs,alertFlashs,alertUrgents)
        } else {
            return ([""],[0.0],[false],[false],[false],[false])
        }
    }
    
    
}
