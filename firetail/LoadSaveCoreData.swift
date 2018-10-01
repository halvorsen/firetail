//
//  LoadSaveCoreData.swift
//  Firetail
//
//  Created by Aaron Halvorsen on 3/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import CoreData
import Foundation
import FirebaseCore
import Firebase
import FirebaseDatabase

final class LoadSaveCoreData {
    
    var alertID: [String] {
        var aaa = [String]()
        for i in 0..<UserInfo.userAlerts.count {
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

    func resaveUser(alerts: [String]) {
        var _userAlerts = [String:String]()

        for i in 0..<alerts.count {
           
            _userAlerts[alertID[i]] = alerts[i]
        }
        UserInfo.userAlerts = _userAlerts
    }
    
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


    func saveUsername(username: String) {
        
        let context = persistentContainer.viewContext
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
   
        let context = persistentContainer.viewContext
        
        let nameRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Info")
        
        do { resultsNameRequest = try context.fetch(nameRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        
        if resultsNameRequest.count > 0 {
            UserInfo.username = resultsNameRequest.last!.value(forKey: "username") as! String
        }
 
    }

    public static func saveUserInfoToFirebase(username:String,fullName:String,email:String,phone:String,premium:Bool, vultureSubscriber:Bool,numOfAlerts:Int,brokerName:String,cryptoBrokerName:String,brokerURL:String,weeklyAlerts:[String:Int],userAlerts:[String:String], token: String) {
        
        let rootRef = Database.database().reference()

        let itemsRef = rootRef.child("users")

        let userRef = itemsRef.child(username)
        let weeklyAlertsRef = userRef.child("weeklyAlerts")
        let userAlertsRef = userRef.child("userAlerts")
        let dict1=["username":username,"fullName":fullName,"email":email,"phone":phone,"premium":premium, "vultureSubscriber":vultureSubscriber,"numOfAlerts":numOfAlerts,"brokerName":brokerName,"cryptoBrokerName":cryptoBrokerName,"brokerURL":brokerURL, "token":token] as [String : Any]
        let dict2 = weeklyAlerts as [String : Any]
        let dict3 = userAlerts as [String : Any]
        
        userRef.setValue(dict1)
        weeklyAlertsRef.setValue(dict2)
        userAlertsRef.setValue(dict3)
    }
    
    func saveAlertToFirebase(username: String, ticker: String,price: Double, isGreaterThan: Bool, deleted: Bool, email: Bool,sms: Bool,flash: Bool,urgent: Bool, triggered: String, push: Bool, alertLongName: String, priceString: String, data1: String = "", data2: String = "", data3: String = "", data4: String = "", data5: String = "") {
        
        let rootRef = Database.database().reference()
        
        let itemsRef = rootRef.child("alerts")

        let alertRef = itemsRef.child(alertLongName)
        let dict = ["id":alertLongName,"isGreaterThan":isGreaterThan,"price":price,"deleted":deleted,"email":email,"flash":flash,"sms":sms,"ticker":ticker.uppercased(),"push":push, "urgent":urgent,"triggered":triggered,"username":UserInfo.username, "priceString":priceString, "data1":data1, "data2":data2, "data3":data3, "data4":data4, "data5":data5] as [String : Any]
        alertRef.setValue(dict)
        
    }
   
}

//Fields under path alerts/alertID/
//“id”:<String>,
//“isGreaterThan”:<Bool>,
//“price”:<Double>,
//“deleted”:<Bool>,
//“email”:<Bool>,
//“flash”:<Bool>,
//“sms”:<Bool>,
//“ticker”:<String>,
//“push”:<Bool>,
//“urgent”:<Bool>,
//“triggered”:<String>, <— #note: this has changed to String
//“username”:<String>,
//"priceString”:<String>,
//“data1”:<String>,
//“data2”:<String>,
//“data3”:<String>,
//“data4”:<String>,
//“data5”:<String>

//Structure of FIREBASE Database
//“users”:{
//    “ja1459361875666":{ (First two alphanumberic symbols of email address and timestamp)
//          "id":"ja145..."
//        “username”:“email@address.com”,
//        “fullName”:“John Vincent”,
//        “email”:“john@gmail.com”,
//        “phone”:“6155388532",
//        “premium”: true,
//        “alertCount”: “24”,
//        “brokerName”: “USAA”,
//        "cryptoBrokerName": "binance"
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
//        “isGreaterThan”:true,
//        “price”:“220”,
//        "priceString":"$220.00",
//        “deleted”:false,
//        “email”:true,
//        “flash”:false,
//        “sms”:false,
//        “ticker”:“tsla”,
//        “triggered”:false,
//        “push”:true,
//        “urgent”:false,
//        “data1”:"",
//        “data2”:"",
//        “data3”:"",
//        “data4”:"",
//        “data5”:""
//    },
//    “fb030817173501"
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
