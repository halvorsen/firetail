//
//  AppLoadingData.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/22/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore

let updatedDataKey = "com.rightBrothers.updatedData"
class AppLoadingData {
    
    var fetchedTickers = [String]()
    let alphaAPI = Alpha()
    
    internal static func loadStockPricesFromCoreData() {
        let dataSets = CacheManager().loadData()
        print("dataSets:")
        print(dataSets)
        guard Set1.tickerArray.count > 0 else {return}
        var count = 0
        for i in 0..<Set1.tickerArray.count {
            loop: for dataSet in dataSets.reversed() {
                if dataSet.ticker == Set1.tickerArray[i] {
                    count += 1
                    Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                    Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                    if count > 10 {
                        break loop
                    }
                }
                
            }
        }
    }
    
    private func fetchAllButFirst3Stocks() {
        var count = 0
        if Set1.tickerArray.count > 3 {
            count = Set1.tickerArray.count
        }
        guard count > 3 else {return}
        var savedCount = 3
        for i in 3..<count {
            if !fetchedTickers.contains(Set1.tickerArray[i]) {
                
                fetchedTickers.append(Set1.tickerArray[i])
                alphaAPI.get20YearHistoricalData(ticker: Set1.tickerArray[i], isOneYear: false) { dataSet in
                    
                    if dataSet == nil {
                        self.alphaAPI.get20YearHistoricalData(ticker: Set1.tickerArray[i], isOneYear: false) { dataSet in
                            savedCount += 1
                            if let dataSet = dataSet {
                                Set1.cachedInThisSession.append(dataSet.ticker)
                                Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                                Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                            }
                            if savedCount >= count {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                            }
                        }
                    } else {
                        savedCount += 1
                        if let dataSet = dataSet {
                            Set1.cachedInThisSession.append(dataSet.ticker)
                            Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                            Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                        }
                        if savedCount >= count {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                        }
                    }
                }
            } else {
                savedCount += 1
            }
        }
    }
    
    func fetchAllStocks() {
        var savedCount = 3
        guard Set1.tickerArray.count > 0 else {return}
        for i in 0..<Set1.tickerArray.count {
            
            if !fetchedTickers.contains(Set1.tickerArray[i]) {
                fetchedTickers.append(Set1.tickerArray[i])
                alphaAPI.get20YearHistoricalData(ticker: Set1.tickerArray[i], isOneYear: false) { dataSet in
                    
                    if dataSet == nil {
                        self.alphaAPI.get20YearHistoricalData(ticker: Set1.tickerArray[i], isOneYear: false) { dataSet in
                            savedCount += 1
                            if let dataSet = dataSet {
                                Set1.cachedInThisSession.append(dataSet.ticker)
                                Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                                Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                            }
                            if savedCount >= Set1.tickerArray.count {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                            }
                        }
                    } else {
                        savedCount += 1
                        if let dataSet = dataSet {
                            Set1.cachedInThisSession.append(dataSet.ticker)
                            Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                            Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                        }
                        if savedCount >= Set1.tickerArray.count {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                        }
                    }
                }
            } else {
                savedCount += 1
            }
        }
    }
    
    private func fetch(callback: @escaping () -> Void) {
        var count = 3
        if Set1.tickerArray.count < 3 {
            guard Set1.tickerArray.count > 0 else {return}
            count = Set1.tickerArray.count
        }
        var savedCount = 0
        for i in 0..<count {
            guard i < Set1.tickerArray.count else {return}
            alphaAPI.get20YearHistoricalData(ticker: Set1.tickerArray[i], isOneYear: false) { dataSet in
                if dataSet == nil {
                    self.alphaAPI.get20YearHistoricalData(ticker: Set1.tickerArray[i], isOneYear: false) { dataSet in
                        if let dataSet = dataSet {
                            Set1.cachedInThisSession.append(dataSet.ticker)
                            Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                            Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                            savedCount += 1
                            if savedCount == count {
                                DispatchQueue.global(qos: .background).async {
                                    self.fetchAllButFirst3Stocks()
                                }
                                NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                                
                                callback()
                            }
                        }
                    }
                } else {
                    if let dataSet = dataSet {
                        Set1.cachedInThisSession.append(dataSet.ticker)
                        Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                        Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                        savedCount += 1
                        if savedCount == count {
                            DispatchQueue.global(qos: .background).async {
                                self.fetchAllButFirst3Stocks()
                            }
                            NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                            
                            callback()
                        }
                    }
                }
            }
        }
    }
    
    //loads the firebase stock info for the username - storing in Set1
    //if there are no alerts it segues to add stock ticker
    
    func loadUserInfoFromFirebase(firebaseUsername: String, callback: @escaping () -> Void) {
        Set1.tickerArray.removeAll()
        
        let ref = Database.database().reference()
        print(firebaseUsername)
        ref.child("users").child(firebaseUsername).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("value: \(value)")
            Set1.fullName = value?["fullName"] as? String ?? "none"
            Set1.email = value?["email"] as? String ?? Set1.username
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
                                Set1.tickerArray.append(_ticker)
                                let _push = value?["push"] as? Bool ?? false
                                let _urgent = value?["urgent"] as? Bool ?? false
                                let _triggered = value?["triggered"] as? String ?? "false"
                                let _timestamp = value?["data1"] as? Int ?? 1
                                Set1.alerts[uA[alertID[i]]!] = (_name, _isGreaterThan, _price, _deleted, _email, _flash, _sms, _ticker, _triggered, _push, _urgent, _timestamp)
                            }
                            totalCount += 1
                            
                            if Set1.userAlerts.count == totalCount {
                                
                                if Set1.tickerArray.count != 0 {
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        self.fetch() {}
                                    }
                                    
                                }
                                print("done success")
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


