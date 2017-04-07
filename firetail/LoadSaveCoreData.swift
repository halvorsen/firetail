//
//  LoadSaveCoreData.swift
//  Firetail
//
//  Created by Aaron Halvorsen on 3/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import CoreData
import UIKit
import FirebaseCore
import Firebase

class LoadSaveCoreData {
    
    var alertID: [String] {
        var aaa = [String]()
        for i in 0..<Set.alertCount {
            switch i {
            case 0...9:
                aaa.append("alert00" + String(i))
            case 10...99:
                aaa.append("alert0" + String(i))
            case 100...999:
                aaa.append("alert" + String(i))
            default:
                break
            }
        }
        return aaa
    }
    
//    private func deleteAllData(entity: String) {
//        let appDel = (UIApplication.shared.delegate as! AppDelegate)
//        let context = appDel.persistentContainer.viewContext
//        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
//        do { try context.execute(DelAllReqVar) }
//        catch { print(error) }
//    }
    
    func resaveBlocks(blocks: [AlertBlockView]) {
        Set.userAlerts.removeAll()
        for i in 0..<blocks.count {
            Set.userAlerts[alertID[i]] = blocks[i].blockLongName
        }
        
//        deleteAllData(entity: "Block")
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        for block in blocks {
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "Block", into: context)
//        entity.setValue(block.stockTickerGlobal, forKey: "ticker")
//        entity.setValue(block.currentPriceGlobal, forKey: "alertPrice")
//        entity.setValue(block.emailGlobal, forKey: "alertEmail")
//        entity.setValue(block.smsGlobal, forKey: "alertSMS")
//        entity.setValue(block.flashGlobal, forKey: "alertFlash")
//        entity.setValue(block.urgentGlobal, forKey: "alertUrgent")
//        
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//        }
    }
    
    
//    func savePurchase(purchase: String) {
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "Purchase", into: context)
//        entity.setValue(true, forKey: "premium")
//        do {
//            try context.save()
//        } catch {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
    func saveUsername(username: String) {
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
            
            Set.username = resultsNameRequest.last!.value(forKey: "username") as! String
            
        }
        
    }
    
    
//    func loadPremiumAccess() -> Bool {
//        var resultsPremiumRequest = [AnyObject]()
//        var bo = false
//        let appDel = (UIApplication.shared.delegate as! AppDelegate)
//        let context = appDel.persistentContainer.viewContext
//        
//        let premiumRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchase")
//        
//        do { resultsPremiumRequest = try context.fetch(premiumRequest) } catch  {
//            print("Could not cache the response \(error)")
//        }
//        
//        if resultsPremiumRequest.count > 0 {
//            
//            bo = resultsPremiumRequest.last!.value(forKey: "premium") as! Bool
//            
//        }
//        
//        return bo
//    }
    
//    func saveBlock(stockTicker: String, currentPrice: Double, sms: Bool, email: Bool, flash: Bool, urgent: Bool) {
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "Block", into: context)
//        entity.setValue(stockTicker, forKey: "ticker")
//        entity.setValue(currentPrice, forKey: "alertPrice")
//        entity.setValue(email, forKey: "alertEmail")
//        entity.setValue(sms, forKey: "alertSMS")
//        entity.setValue(flash, forKey: "alertFlash")
//        entity.setValue(urgent, forKey: "alertUrgent")
//        
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
//    func saveBlockAmount(amount: Int) {
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "BlockAmount", into: context)
//        entity.setValue(Int16(amount), forKey: "value")
//        do { try context.save() } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
//    func amount() -> Int {
//        var resultsBlockAmounts = [AnyObject]()
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        let requestBlockAmounts = NSFetchRequest<NSFetchRequestResult>(entityName: "BlockAmount")
//        
//        do { resultsBlockAmounts = try context.fetch(requestBlockAmounts) } catch  {
//            print("Could not cache the response \(error)")
//        }
//        if resultsBlockAmounts.count > 0 {
//            let r = resultsBlockAmounts.last!.value(forKey: "value") as! Int
//            
//            return r
//        } else {
//            return 0}
//    }
    
//    func loadBlocks() -> (t: [String],p: [Double],email: [Bool],sms: [Bool],flash: [Bool],urgent: [Bool]) {
//        var resultsBlocks = [AnyObject]()
//        var resultsBlockAmounts = [AnyObject]()
//        var tickers = [String]()
//        var alertPrices = [Double]()
//        var alertEmails = [Bool]()
//        var alertSMSs = [Bool]()
//        var alertFlashs = [Bool]()
//        var alertUrgents = [Bool]()
//        
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        let requestBlocks = NSFetchRequest<NSFetchRequestResult>(entityName: "Block")
//        //fb() //testing the saving to firebase
//        do { resultsBlocks = try context.fetch(requestBlocks) } catch  {
//            print("Could not cache the response \(error)")
//        }
//        let requestBlockAmounts = NSFetchRequest<NSFetchRequestResult>(entityName: "BlockAmount")
//        
//        do { resultsBlockAmounts = try context.fetch(requestBlockAmounts) } catch  {
//            print("Could not cache the response \(error)")
//        }
//        if resultsBlocks.count > 0 {
//            let loadedBlockAmount = resultsBlockAmounts.last!.value(forKey: "value") as! Int
//            
//            for result in resultsBlocks.suffix(loadedBlockAmount) { //gets the last few blocks
//                if let ticker = result.value(forKey: "ticker") as! String? {tickers.append(ticker)}
//                if let alertPrice = result.value(forKey: "alertPrice") as! Double? {alertPrices.append(alertPrice)}
//                if let alertEmail = result.value(forKey: "alertEmail") as! Bool? {alertEmails.append(alertEmail)}
//                if let alertSMS = result.value(forKey: "alertSMS") as! Bool? {alertSMSs.append(alertSMS)}
//                if let alertFlash = result.value(forKey: "alertFlash") as! Bool? {alertFlashs.append(alertFlash)}
//                if let alertUrgent = result.value(forKey: "alertUrgent") as! Bool? {alertUrgents.append(alertUrgent)}
//                
//            }
//            Set.alertCount = tickers.count
//            return (tickers,alertPrices,alertEmails,alertSMSs,alertFlashs,alertUrgents)
//        } else {
//            return ([""],[0.0],[false],[false],[false],[false])
//        }
//    }
 
       
//    func loadUserAlertsFromFirebase(alerts: [String]) {// -> (isGreaterThan: [Bool], price: [Double], deleted: [Bool], email: [Bool], flash: [Bool], sms: [Bool], ticker: [String], push: [Bool], urgent: [Bool], triggered: [Bool]) {

//        var isGreaterThan = [Bool]()
//        var price = [Double]()
//        var deleted = [Bool]()
//        var email = [Bool]()
//        var flash = [Bool]()
//        var sms = [Bool]()
//        var ticker = [String]()
//        var push = [Bool]()
//        var urgent = [Bool]()
//        var triggered = [Bool]()
        
//        let ref = FIRDatabase.database().reference()
        
       
        
//        for alert in alerts {
//        ref.child("alerts").child(alert).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let _deleted = value?["deleted"] as? Bool ?? false
//            
//            if !_deleted {
//            
//            let value = snapshot.value as? NSDictionary
//            let _isGreaterThan = value?["isGreaterThan"] as? Bool ?? false
//         //   isGreaterThan.append(_isGreaterThan)
//            let _price = value?["price"] as? Double ?? 0.0
//           // price.append(_price)
//            
//         //   deleted.append(_deleted)
//            let _email = value?["email"] as? Bool ?? false
//         //   email.append(_email)
//            let _flash = value?["flash"] as? Bool ?? false
//          //  flash.append(_flash)
//            let _sms = value?["sms"] as? Bool ?? false
//          //  sms.append(_sms)
//            let _ticker = value?["ticker"] as? String ?? ""
//         //   ticker.append(_ticker)
//            let _push = value?["push"] as? Bool ?? false
//         //   push.append(_push)
//            let _urgent = value?["urgent"] as? Bool ?? false
//         //   urgent.append(_urgent)
//            let _triggered = value?["triggered"] as? Bool ?? false
//         //   triggered.append(_triggered)
//            Set.alerts[alert] = (_isGreaterThan, _price, _deleted, _email, _flash, _sms, _ticker, _triggered, _push, _urgent)
//            }
//     
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        }
        
           // return (isGreaterThan, price, deleted, email, flash, sms, ticker, push, urgent, triggered)
//    }

    func saveUserInfoToFirebase(username:String,fullName:String,email:String,phone:String,premium:Bool,numOfAlerts:Int,brokerName:String,brokerURL:String,weeklyAlerts:[String:Int],userAlerts:[String:String]) {

        let ref = FIRDatabase.database().reference(withPath: "users")

        let rootRef = FIRDatabase.database().reference()

        let childRef = FIRDatabase.database().reference(withPath: "users")

        let itemsRef = rootRef.child("users")

        let userRef = itemsRef.child(username)
        let weeklyAlertsRef = userRef.child("weeklyAlerts")
        let userAlertsRef = userRef.child("userAlerts")
        let dict1=["username":username,"fullName":fullName,"email":email,"phone":phone,"premium":premium,"numOfAlerts":numOfAlerts,"brokerName":brokerName,"brokerURL":brokerURL] as [String : Any]
        let dict2 = weeklyAlerts as [String : Any]
        let dict3 = userAlerts as [String : Any]
        
        userRef.setValue(dict1)
        weeklyAlertsRef.setValue(dict2)
        userAlertsRef.setValue(dict3)
        
        
    }
    
    func saveAlertToFirebase(username: String, ticker: String,price: Double, isGreaterThan: Bool, deleted: Bool, email: Bool,sms: Bool,flash: Bool,urgent: Bool, triggered: Bool, push: Bool, alertLongName: String) {
        
        let ref = FIRDatabase.database().reference(withPath: "alerts")
        
        let rootRef = FIRDatabase.database().reference()
        
        let childRef = FIRDatabase.database().reference(withPath: "alerts")
        
        let itemsRef = rootRef.child("alerts")

        print("Timestamp Alert Name: \(alertLongName)")
        let alertRef = itemsRef.child(alertLongName)
        let dict = ["isGreaterThan":isGreaterThan,"price":price,"deleted":deleted,"email":email,"flash":flash,"sms":sms,"ticker":ticker,"push":push, "urgent":urgent,"triggered":triggered] as [String : Any]
        alertRef.setValue(dict)
        
    }
   
}
//Structure of FIREBASE Database
//“users”:{
//    “ja1459361875666":{ (First two alphanumberic symbols of email address and timestamp)
//        “username”:“email@address.com”,
//        “fullName”:“John Vincent”,
//        “email”:“john@gmail.com”,
//        “phone”:“6155388532",
//        “premium”: true,
//        “alertCount”: “24”,
//        “brokerName”: “USAA”,
//        “brokerURL”: “http://www.usaa.com”,
//        “createdAt”:“02092017”,
//        “lastLogins”:{
//            “l1459361875666”:{ ( "l" + timestamp)
//                “loginAt”:“02/13/2017 03:40:40”,
//                “timestamp”: “1459361875666”,
//                “ipAddress”:“234.34.56.1”
//            },
//            “l2350235892350":{
//                “loginAt”:“02/12/2017 13:13:20",
//                “timestamp”: “2350235892350",
//                “ipAddress”:“156.12.36.1"
//            }
//        },
//        “weeklyAlerts”:{
//            “mon”:“2”,
//            “tues”:“1”,
//            “wed”:“0”,
//            “thur”:“0”,
//            “fri”:“0”
//        },
//        “userAlerts”:{
//            “alert001”:”tsla030817173322”, (alert order in app value paired with timestamp)
//            “alert002”:“fb692839290189”,
//        }
//    },
//    “aa1459361875667”: ...,
//    “su14593618756643": ...
//},
//“alerts”: {
//    “tsla030817173322”{
//        “isGreaterThan”:true, (alert triggered when market price "isGreaterThan" alert price
//        “price”:“220”,
//        “deleted”:false,
//        “email”:true,
//        “flash”:false,
//        “sms”:false,
//        “ticker”:“tsla”,
//        “triggered”:false,
//        “push”:true,
//        “urgent”:false,
//    },
//    “fb030817173501"{
//        “deleted”:false,
//        “email”:true,
//        “flash”:false,
//        “price”:“220”,
//        “sms”:false,
//        “ticker”:“tsla”,
//        “triggered”:true,
//        “push”:true,
//        “urgent”:false,
//    },
//    “goog352129879323": ...,
//    “f692839290189”: ...
//},
//“brokers”: {
//    “Ameritrade”{
//        “brokerName”:“TD Ameritrade”,
//        “brokerURL”:“https://invest.ameritrade.com/grid/p/site”
//        “noOfUsers”:2,
//        “members”:{
//            “user1":true,
//            “user3”:true
//        }
//    },
//    “Trade King"{
//        “brokerName”:“Trade King”,
//        “url”:“https://investor.tradeking.com/account-login”,
//        “noOfUsers”:1,
//        “members”:{
//            “user2”:true
//        }
//    },
//    “broker3": ...,
//    “bbroker4”: ...
//}
