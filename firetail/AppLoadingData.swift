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
        guard UserInfo.tickerArray.count > 0 else {return}
        var count = 0
        for i in 0..<UserInfo.tickerArray.count {
            loop: for dataSet in dataSets.reversed() {
                if dataSet.ticker == UserInfo.tickerArray[i] {
                    count += 1
                    UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                    UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                    if count > 10 {
                        break loop
                    }
                }
                
            }
        }
    }
    
    private func fetchAllButFirst3Stocks() {
        var count = 0
        if UserInfo.tickerArray.count > 3 {
            count = UserInfo.tickerArray.count
        }
        guard count > 3 else {return}
        var savedCount = 3
        for i in 3..<count {
            if !fetchedTickers.contains(UserInfo.tickerArray[i]) {
                
                fetchedTickers.append(UserInfo.tickerArray[i])
                alphaAPI.get20YearHistoricalData(ticker: UserInfo.tickerArray[i], isOneYear: false) { dataSet in
                    
                    if dataSet == nil {
                        self.alphaAPI.get20YearHistoricalData(ticker: UserInfo.tickerArray[i], isOneYear: false) { dataSet in
                            savedCount += 1
                            if let dataSet = dataSet {
                                UserInfo.cachedInThisSession.append(dataSet.ticker)
                                UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                                UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                            }
                            if savedCount >= count {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                            }
                        }
                    } else {
                        savedCount += 1
                        if let dataSet = dataSet {
                            UserInfo.cachedInThisSession.append(dataSet.ticker)
                            UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                            UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
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
        guard UserInfo.tickerArray.count > 0 else {return}
        for i in 0..<UserInfo.tickerArray.count {
            
            if !fetchedTickers.contains(UserInfo.tickerArray[i]) {
                fetchedTickers.append(UserInfo.tickerArray[i])
                alphaAPI.get20YearHistoricalData(ticker: UserInfo.tickerArray[i], isOneYear: false) { dataSet in
                    
                    if dataSet == nil {
                        self.alphaAPI.get20YearHistoricalData(ticker: UserInfo.tickerArray[i], isOneYear: false) { dataSet in
                            savedCount += 1
                            if let dataSet = dataSet {
                                UserInfo.cachedInThisSession.append(dataSet.ticker)
                                UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                                UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                            }
                            if savedCount >= UserInfo.tickerArray.count {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                            }
                        }
                    } else {
                        savedCount += 1
                        if let dataSet = dataSet {
                            UserInfo.cachedInThisSession.append(dataSet.ticker)
                            UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                            UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                        }
                        if savedCount >= UserInfo.tickerArray.count {
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
        if UserInfo.tickerArray.count < 3 {
            guard UserInfo.tickerArray.count > 0 else {return}
            count = UserInfo.tickerArray.count
        }
        var savedCount = 0
        for i in 0..<count {
            guard i < UserInfo.tickerArray.count else {return}
            alphaAPI.get20YearHistoricalData(ticker: UserInfo.tickerArray[i], isOneYear: false) { dataSet in
                if dataSet == nil {
                    self.alphaAPI.get20YearHistoricalData(ticker: UserInfo.tickerArray[i], isOneYear: false) { dataSet in
                        if let dataSet = dataSet {
                            UserInfo.cachedInThisSession.append(dataSet.ticker)
                            UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                            UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
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
                        UserInfo.cachedInThisSession.append(dataSet.ticker)
                        UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                        UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
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
    
    //loads the firebase stock info for the username - storing in UserInfo
    //if there are no alerts it segues to add stock ticker
    
    func loadUserInfoFromFirebase(firebaseUsername: String, callback: @escaping () -> Void) {
        UserInfo.tickerArray.removeAll()
        
        let ref = Database.database().reference()
        print(firebaseUsername)
        ref.child("users").child(firebaseUsername).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("value: \(value)")
            UserInfo.fullName = value?["fullName"] as? String ?? "none"
            UserInfo.email = value?["email"] as? String ?? UserInfo.username
            UserInfo.phone = value?["phone"] as? String ?? "none"
            UserInfo.premium = value?["premium"] as? Bool ?? false
            UserInfo.brokerName = value?["brokerName"] as? String ?? "none"
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
                for i in (0..<UserInfo.userAlerts.count).reversed() {
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
                                UserInfo.tickerArray.append(_ticker)
                                let _push = value?["push"] as? Bool ?? false
                                let _urgent = value?["urgent"] as? Bool ?? false
                                let _triggered = value?["triggered"] as? String ?? "false"
                                let _timestamp = value?["data1"] as? Int ?? 1
                                UserInfo.alerts[uA[alertID[i]]!] = (_name, _isGreaterThan, _price, _deleted, _email, _flash, _sms, _ticker, _triggered, _push, _urgent, _timestamp)
                            }
                            totalCount += 1
                            
                            if UserInfo.userAlerts.count == totalCount {
                                
                                if UserInfo.tickerArray.count != 0 {
                                    
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


