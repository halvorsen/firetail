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
    
    private let rootNode = Database.database().reference()
    private lazy var userNode = rootNode.child("userdb").child(currentUser?.uid ?? "none")
    private lazy var alertNode = rootNode.child("alertdb")
    private lazy var memberInfoNode = userNode.child("memberInfo")
    
    private var currentUser: User? {
          return Auth.auth().currentUser
    }
    
    func hasV2UserInfo(result: @escaping (_ hasV1: Bool) -> Void) {
        userNode.observeSingleEvent(of: .value) { snapshot in
            result( snapshot.value != nil )
        }
    }
    
    func hasV1UserInfo(result: @escaping (_ hasV1: Bool) -> Void) {
        rootNode.child("users").child(UserInfo.email.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)).observeSingleEvent(of: .value) { snapshot in
            result( snapshot.value != nil )
        }
    }
    
    func deleteV1UserInfo() {
        rootNode.child("users").child(UserInfo.email.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)).removeValue()
    }
    
    func migrateUserInfoFromV1toV2() {
        saveUserInfoToFirebase(key: "email", value: UserInfo.email)
        saveUserInfoToFirebase(key: "fullName", value: UserInfo.fullName)
        saveMembershipInfoToFirebase(key: "premiumOld", value: UserInfo.premium)
        saveUserInfoToFirebase(key: "brokerName", value: UserInfo.brokerName)
        saveUserInfoToFirebase(key: "userAlerts", value: UserInfo.userAlerts)
        deleteV1UserInfo()
    }
    
    func persistSubscriber(_ isSubscriber: Bool, expirationTimestamp: TimeInterval, originalTransactionID: String) {
        guard currentUser?.uid != nil else { return }
        memberInfoNode.child("vultureSubscriber").setValue(isSubscriber)
        memberInfoNode.child("vultureExpiration").setValue(expirationTimestamp)
        memberInfoNode.child("originalTransactionID").setValue(originalTransactionID)
    }
    
    func persistDeprecatedSubscriber(_ isOldSubscriber: Bool) {
        guard currentUser?.uid != nil else { return }
        memberInfoNode.child("premiumOld").setValue(isOldSubscriber)
    }
    
    func saveUserInfoToFirebase(key: String, value: Any) {
        userNode.child(key).setValue(value)
    }
    
    func saveUserMemberInfoToFirebase(key: String, value: Any) {
        userNode.child("memberInfo").child(key).setValue(value)
    }
    
    func saveMembershipInfoToFirebase(key: String, value: Any) {
        memberInfoNode.child(key).setValue(value)
    }
    
    func saveAlertToFirebase(username: String, ticker: String,price: Double, isGreaterThan: Bool, deleted: Bool, email: Bool,sms: Bool,flash: Bool,urgent: Bool, triggered: String, push: Bool, intelligent: Bool, alertLongName: String, priceString: String, timestamp: String) {
        guard currentUser?.uid != nil else { return }
        guard let uid = currentUser?.uid else { return }
        let value = [ // ##TODO add in subnodes according to ticker name if we chose
                alertLongName: [
                    "deleted": deleted,
                    "flash": flash,
                    "push": push,
                    "sms": sms,
                    "email": email,
                    "urgent": urgent,
                    "intelligent": intelligent,
                    "isGreaterThan": isGreaterThan,
                    "price": price,
                    "ticker": ticker,
                    "triggered": triggered,
                    "owner": uid, // once was an email with commas substituted
                    "timestamp": timestamp //once was data1
                ]
            ] as [String : Any]
        alertNode.child(alertLongName).setValue(value)
    }
    
    private func getWeeklyAlerts(_ alerts: [String:String]) -> [String: Int]? {
        var weeklyAlerts: [String: Int]?
        // ##TODO
        return weeklyAlerts
    }
    
    func loadUserInfoFromFirebase(callback: @escaping () -> Void) {
        UserInfo.tickerArray.removeAll()
        userNode.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userInfo = snapshot.value as? [String: Any] else { return }
            let memberInfo = userInfo["memberInfo"] as? [String: Any]
            UserInfo.token = userInfo["token"] as? String ?? "none"
            UserInfo.vultureSubscriber = memberInfo?["vultureSubscriber"] as? Bool ?? false
            UserInfo.fullName = userInfo["fullName"] as? String ?? "none"
            UserInfo.email = userInfo["email"] as? String ?? UserInfo.username
            UserInfo.phone = userInfo["phone"] as? String ?? "none"
            UserInfo.premium = memberInfo?["premiumOld"] as? Bool ?? false
            UserInfo.brokerName = userInfo["brokerName"] as? String ?? "none"
            UserInfo.cryptoBrokerName = userInfo["cryptoBrokerName"] as? String ?? "none"
            UserInfo.userAlerts = userInfo["userAlerts"] as? [String:String] ?? [:]
            UserInfo.weeklyAlerts = self.getWeeklyAlerts(UserInfo.userAlerts) ?? ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
            
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
                        self.alertNode.child(alertLongID).observeSingleEvent(of: .value, with: { (snapshot) in
                            let alertInfo = snapshot.value as? [String: Any]
                            if !(alertInfo?["deleted"] as? Bool ?? false) {
                                let notificationType = alertInfo?["notificationType"] as? [String: Any]
                                let name = uA[alertID[i]] ?? ""
                                let isGreaterThan = alertInfo?["isGreaterThan"] as? Bool ?? false
                                let price = alertInfo?["priceString"] as? String ?? ""
                                let email = notificationType?["email"] as? Bool ?? false
                                let flash = notificationType?["flash"] as? Bool ?? false
                                let sms = notificationType?["sms"] as? Bool ?? false
                                let ticker = alertInfo?["ticker"] as? String ?? ""
                                let push = notificationType?["push"] as? Bool ?? false
                                let urgent = notificationType?["urgent"] as? Bool ?? false
                                let intelligent = notificationType?["intelligent"] as? Bool ?? false
                                let triggered = alertInfo?["triggered"] as? String ?? "false"
                                let timestamp = alertInfo?["timestamp"] as? Int ?? 0
                                
                                alertTemp[alertLongID] = (name:name,isGreaterThan:isGreaterThan,price:price,deleted:false,intelligent:intelligent,email:email,flash:flash,sms:sms,ticker:ticker,triggered:triggered,push:push,urgent:urgent,timestamp:timestamp)
                                
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
/*
V2 of Database:
timestamp: Int,
userdb: { ---> *** structure of user json is same as before, starting at the root name ***
    uid: {
        email: String,
        fullName: String,
        email: String,
        phone: String,
        token: String,
        memberInfo: {
            premiumOld: Bool
            vultureSubscriber: Bool
            vultureExpiration: TimeInterval
            originalTransactionID: String
        },
        brokerName: String,
        cryptoBrokerName: String,
        creationDate: String,
        userAlerts: {
            alert000: crypto2352092BTC,
            alert001: 2352352234TSLA,
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
alert: { ---> *** structure of alert json is same as before ***
    crypto23532453ETH: {
        timestamp: Int, --> *** this was formally data1 ***
        deleted: bool,
        flash: true,
        push: true,
        sms: true,
        email: true,
        urgent: false,
        intelligent: false --> *** this is new ***
        isGreaterThan: bool,
        price: Double,
        ticker: String,
        triggered: Bool
        owner: StringUID --> *** now a firebase uid string, was email with comma replacements ***
    }
    .
    .
    .
    nthAlert: ...
 }
}
 If we wish, we can also put alerts in sub nodes to help with db searches
 alertSearch: {
    ETH: {
        crypto23532453ETH: true
        crypto253453458ETH: true
        .
        .
        .
        nthAlert
    }
 }
*/
