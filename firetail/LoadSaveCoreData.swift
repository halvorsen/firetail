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

    
    func resaveBlocks(blocks: [AlertBlockView]) {
        Set.userAlerts.removeAll()
        for i in 0..<Set.alertCount {
            Set.userAlerts[alertID[i]] = blocks[i].blockLongName
        }
        

    }

    
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
    


    public static func saveUserInfoToFirebase(username:String,fullName:String,email:String,phone:String,premium:Bool,numOfAlerts:Int,brokerName:String,brokerURL:String,weeklyAlerts:[String:Int],userAlerts:[String:String], token: String) {
        
      //  let ref = FIRDatabase.database().reference(withPath: "users")

        let rootRef = FIRDatabase.database().reference()

      //  let childRef = FIRDatabase.database().reference(withPath: "users")

        let itemsRef = rootRef.child("users")

        let userRef = itemsRef.child(username)
        let weeklyAlertsRef = userRef.child("weeklyAlerts")
        let userAlertsRef = userRef.child("userAlerts")
        let dict1=["username":username,"fullName":fullName,"email":email,"phone":phone,"premium":premium,"numOfAlerts":numOfAlerts,"brokerName":brokerName,"brokerURL":brokerURL, "token":token] as [String : Any]
        let dict2 = weeklyAlerts as [String : Any]
        let dict3 = userAlerts as [String : Any]
        
        userRef.setValue(dict1)
        weeklyAlertsRef.setValue(dict2)
        userAlertsRef.setValue(dict3)
        
        
    }
    
    func saveAlertToFirebase(username: String, ticker: String,price: Double, isGreaterThan: Bool, deleted: Bool, email: Bool,sms: Bool,flash: Bool,urgent: Bool, triggered: Bool, push: Bool, alertLongName: String) {
        
     //   let ref = FIRDatabase.database().reference(withPath: "alerts")
        
        let rootRef = FIRDatabase.database().reference()
        
     //   let childRef = FIRDatabase.database().reference(withPath: "alerts")
        
        let itemsRef = rootRef.child("alerts")

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
