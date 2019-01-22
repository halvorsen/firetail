//
//  Database.swift
//  firetail
//
//  Created by Aaron Halvorsen on 1/21/19.
//  Copyright © 2019 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase

final class FiretailDatabase {
    
    static var shared: FiretailDatabase = FiretailDatabase()
    
    func migrateFromV1toV2() {
        
    }
    
    func persistSubscriber(_ isSubscriber: Bool, expirationTimestamp: TimeInterval, originalTransactionID: String) {
        guard let user = Auth.auth().currentUser, var email = user.email else { return }
        email = email.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child("users").child(email).child("vultureSubscriber").setValue(isSubscriber)
        Database.database().reference().child("users").child(email).child("vultureExpiration").setValue(expirationTimestamp)
        Database.database().reference().child("users").child(email).child("originalTransactionID").setValue(originalTransactionID)
    }
    func persistDeprecatedSubscriber(_ isOldSubscriber: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("premium").setValue(isOldSubscriber)
    }
    
    func saveUserInfoToFirebase(username:String,fullName:String,email:String,phone:String,premium:Bool, vultureSubscriber:Bool,numOfAlerts:Int,brokerName:String,cryptoBrokerName:String,brokerURL:String,weeklyAlerts:[String:Int],userAlerts:[String:String], token: String) {
        
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
    
    func loadUserInfoFromFirebase(firebaseUsername: String, callback: @escaping () -> Void) {
        UserInfo.tickerArray.removeAll()
        
        let ref = Database.database().reference()
        
        ref.child("users").child(firebaseUsername).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            UserInfo.vultureSubscriber = value?["vultureSubscriber"] as? Bool ?? false
            UserInfo.fullName = value?["fullName"] as? String ?? "none"
            UserInfo.email = value?["email"] as? String ?? UserInfo.username
            UserInfo.phone = value?["phone"] as? String ?? "none"
            UserInfo.premium = value?["premium"] as? Bool ?? false
            UserInfo.brokerName = value?["brokerName"] as? String ?? "none"
            UserInfo.cryptoBrokerName = value?["cryptoBrokerName"] as? String ?? "none"
            UserInfo.brokerURL = value?["brokerURL"] as? String ?? "none"
            UserInfo.weeklyAlerts = value?["weeklyAlerts"] as? [String:Int] ?? ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
            UserInfo.userAlerts = value?["userAlerts"] as? [String:String] ?? [:]
            
            
            if UserInfo.userAlerts.count > 0 {
                
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
                let uA = UserInfo.userAlerts
                var totalCount = 0
                
                var alertTemp: [String: alertTuple] = [:]
                
                for i in (0..<UserInfo.userAlerts.count).reversed() {
                    if let alertLongID = uA[alertID[i]] {
                        ref.child("alerts").child(alertLongID).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let _deleted = value?["deleted"] as? Bool ?? false
                            
                            if !_deleted {
                                
                                let name = uA[alertID[i]]!
                                let value = snapshot.value as? NSDictionary
                                let isGreaterThan = value?["isGreaterThan"] as? Bool ?? false
                                let price = value?["priceString"] as? String ?? ""
                                let email = value?["email"] as? Bool ?? false
                                let flash = value?["flash"] as? Bool ?? false
                                let sms = value?["sms"] as? Bool ?? false
                                let ticker = value?["ticker"] as? String ?? ""
                                let push = value?["push"] as? Bool ?? false
                                let urgent = value?["urgent"] as? Bool ?? false
                                let triggered = value?["triggered"] as? String ?? "false"
                                let timestamp = value?["data1"] as? Int ?? 1
                                
                                alertTemp[alertLongID] = (name:name,isGreaterThan:isGreaterThan,price:price,deleted:false,email:email,flash:flash,sms:sms,ticker:ticker,triggered:triggered,push:push,urgent:urgent,timestamp:timestamp)
                                
                            }
                            totalCount += 1
                            
                            if UserInfo.userAlerts.count == totalCount {
                                UserInfo.alerts = alertTemp
                                DashboardViewController.shared.collectionView?.reloadData()
                                if UserInfo.tickerArray.count != 0 {
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        AppLoadingData.fetchAllStocks()
                                    }
                                    
                                }
                                callback()
                            }
                            
                        }) { (error) in
                            print(error.localizedDescription)
                            callback()
                        }
                    } else {
                        
                    }
                    
                }
                
            } else {
                callback()
            }
            
        }) { (error) in
            print(error.localizedDescription)
            callback()
        }
        
    }
    
    
}

/* **remove weeklyAlerts and Token from database
V2 of Database:
timestamp: Int,
firebaseuserdb: {
    uid: {
        email: String,
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        memberType: String,
        stockBroker: String,
        cryptoExchange: String,
        creationDate: String,
        alertData: {
            crypto2352092BTC:true,
            2352352234TSLA:false,
            .
            .
            .
        }
    },
    .
    .
    .
    nthUser: ...
},
firebasealertdb: {
    crypto23532453ETH: {
        data1 (timestamp?): Int,
        deleted: bool,
        notificationType: {
            flash: true,
            push: true,
            sms: true,
            email: true,
            urgent: false,
            intelligent: false
        }
        isGreaterThan: bool,
        price: Double,
        ticker: String,
        triggered: Bool
        owner: StringUID
    }
    .
    .
    .
    nthAlert: ...
}
*/
