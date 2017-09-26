//
//  AppLoadingData.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/22/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore

let updatedDataKey = "com.rightBrothers.updatedData"
class AppLoadingData {
    let cacheManager = CacheManager()
    private func loadTop3StocksFromCoreData() -> Bool {
        let dataSets = cacheManager.loadData()
        if dataSets.count > 50 {
            cacheManager.eraseAllStockCashe()
        }
        var count = 3
        if Set1.ti.count < 3 {
            guard Set1.ti.count > 0 else {print("Set1.ti.count == 0");return false}
            count = Set1.ti.count
        }
        var savedCount = 0
        for i in 0..<count {
            loop: for dataSet in dataSets.reversed() {
                if dataSet.ticker == Set1.ti[i] {
                    Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252)) //Array(array.suffix(10))
                    savedCount += 1
                    if savedCount == count {
                        return true
                    }
                    break loop
                }
            }
        }
        return false
    }
    
    private func fetchAllButFirst3Stocks() { //stop fetching after 8 stocks
        var count = 3
        if Set1.ti.count > 3 {
            count = Set1.ti.count
        }
        for i in 3..<count {
            guard i < 9 else {return}
            let keyExists = Set1.oneYearDictionary[Set1.ti[i]] != nil
            if !keyExists {
            alphaAPI.get20YearHistoricalData(ticker: Set1.ti[i]) { dataSet in
                if let dataSet = dataSet {
                    Set1.oneYearDictionary[dataSet.ticker] = dataSet.price
                }
            }
            }
        }
    }
   

    let alphaAPI = Alpha()
    private func fetch(callback: @escaping () -> Void) {
        var count = 3
        if Set1.ti.count < 3 {
            guard Set1.ti.count > 0 else {print("Set1.ti.count == 0");return}
            count = Set1.ti.count
        }
        var savedCount = 0
        for i in 0..<count {
            alphaAPI.get20YearHistoricalData(ticker: Set1.ti[i]) { dataSet in
                if let dataSet = dataSet {
                    Set1.oneYearDictionary[dataSet.ticker] = dataSet.price
                    savedCount += 1
                    if savedCount == count {
                        self.fetchAllButFirst3Stocks()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                        print("finishedfetch1")
                        callback()
                    }
                }
            }
        }
    }

    //loads the firebase stock info for the username - storing in Set1
    //if there are no alerts it segues to add stock ticker
    
    func loadUserInfoFromFirebase(firebaseUsername: String, result: @escaping (_ haveNoAlerts: Bool) -> Void) {
        Set1.ti.removeAll()
        let ref = Database.database().reference()
        
        ref.child("users").child(firebaseUsername).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            Set1.fullName = value?["fullName"] as? String ?? "none"
            Set1.email = value?["email"] as? String ?? "none"
            Set1.phone = value?["phone"] as? String ?? "none"
            Set1.premium = value?["premium"] as? Bool ?? false
            Set1.brokerName = value?["brokerName"] as? String ?? "none"
            Set1.brokerURL = value?["brokerURL"] as? String ?? "none"
            Set1.weeklyAlerts = value?["weeklyAlerts"] as? [String:Int] ?? ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
            Set1.userAlerts = value?["userAlerts"] as? [String:String] ?? [:]
            
            
            if Set1.userAlerts.count > 0 {
                
                var alertID: [String] {
                    var aaa = [String]()
                    for i in 0..<Set1.userAlerts.count {
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
                let uA = Set1.userAlerts
                var totalCount = 0
                for i in (0..<Set1.userAlerts.count).reversed() {
                    if uA[alertID[i]] != nil {
                        ref.child("alerts").child(uA[alertID[i]]!).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let _deleted = value?["deleted"] as? Bool ?? false
                            
                            if !_deleted {
                                
                                let _name = uA[alertID[i]]!
                                let value = snapshot.value as? NSDictionary
                                let _isGreaterThan = value?["isGreaterThan"] as? Bool ?? false
                                let _price = value?["priceString"] as? String ?? ""
                                let _email = value?["email"] as? Bool ?? false
                                let _flash = value?["flash"] as? Bool ?? false
                                let _sms = value?["sms"] as? Bool ?? false
                                let _ticker = value?["ticker"] as? String ?? ""
                                Set1.ti.append(_ticker)
                                let _push = value?["push"] as? Bool ?? false
                                let _urgent = value?["urgent"] as? Bool ?? false
                                let _triggered = value?["triggered"] as? String ?? "false"
                                let _timestamp = value?["data1"] as? Int ?? 1
                                Set1.alerts[uA[alertID[i]]!] = (_name, _isGreaterThan, _price, _deleted, _email, _flash, _sms, _ticker, _triggered, _push, _urgent, _timestamp)
                            }
                            totalCount += 1
                            var haventSegued = true
                            if Set1.userAlerts.count == totalCount {
                                if Set1.ti.count != 0 {
                                    //at this point we know what stocks we need to fetch info need to fetch remote data on a backend thread and stored data immediately to segue
                                    
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        self.fetch() {
                                            print("finished fetch2")
                                            DispatchQueue.main.async {
                                            if haventSegued {
                                                print("finished fetch3")
                                            result(false)
                                            }
                                            }
                                        }
                                    }
                                    let success = self.loadTop3StocksFromCoreData()
                                    Set1.saveUserInfo()
                                    if success {
                                        haventSegued = false
                                        result(false)
                                    }
                                    
                                } else {
                                    Set1.saveUserInfo()
                                    haventSegued = false
                                    result(true)
                                }
                            }
                            
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                }
                Set1.saveUserInfo()
            } else {
                result(true)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
}
