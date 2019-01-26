//
//  Practice.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/9/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

public struct UserInfo {
    
    public static var flashOn: Bool = false
    public static var smsOn: Bool = false
    public static var emailOn: Bool = false
    public static var pushOn: Bool = false
    public static var allOn: Bool = false
    public static var intelligenceOn: Bool = false
    
    public static var token: String = "none"
    
    public static var yesterday: Double = 0.0
    
    public static var cachedInThisSession = [String]()
    
    public static var oneYearDictionary: [String:[Double]] = ["":[0.0]]
    
    public static var tenYearDictionary: [String:[Double]] = ["":[0.0]]
    
    public static var tickerArray = [String]() {
        didSet {
            AppLoadingData.loadCachedHistoricalDataForTickerArray()
        }
    }
    
    public static var cryptoTickerArray: [String] {
        return tickerArray.filter { Binance.isCryptoTickerSupported(ticker: $0) }
    }
    
    public static var stockTickerArray: [String] {
        return tickerArray.filter { !Binance.isCryptoTickerSupported(ticker: $0) }
    }
    public static var currentUserUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    public static func signInAnonymously() {
        Auth.auth().signInAnonymously { (data, error) in
            if let uid = data?.user.uid {
                print("sign in anonymously")
                print(uid)
            }
        }
    }
    
    public static var month = ["","","","","","","","","","","",""]
    
    public static var phone = "none"
    
    public static var email = "none"
    
    public static var brokerName = "none"
    
    public static var cryptoBrokerName = "none"
    
    public static var username = "none"
    
    public static var fullName = "none"
    
    public static var premium = false
    
    public static var vultureSubscriber = false
    
    public static var brokerURL = "none"
    
    public static var weeklyAlerts: [String:Int] = ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
    
    public static var userAlerts : [String:String] = [:] 
    
    /// all alerts funnel through here, this property gets updated with cached alerts then overwritten by network alerts. The order is taken locally from a cache into alerts ordered arrays and a alertsWithOrder array gets created from these (this is one directional flow of data, when alerts add or delete the array gets updated and alerts dictionary then populates everything from there automatically.
    internal static var alerts = [String:alertTuple]() { // set this dictionary but don't get from it
        didSet {
            UserInfo.populateAlertsWithOrder()
            UserInfo.cryptoAlerts = UserInfo.alerts.filter { $0.key.isCryptoAlertKey }
            UserInfo.stocksAlerts = UserInfo.alerts.filter { $0.key.isStockAlertKey }
        }
    }
    
    internal static var currentAlerts: [String:alertTuple] { // get from this dictionary or rather the two below it
        get {
            if UserInfo.isStockMode {
                return UserInfo.stocksAlerts
            } else {
                return UserInfo.cryptoAlerts
            }
        }
    }
    
    public static var stocksAlerts = [String:alertTuple]()
    public static var cryptoAlerts = [String:alertTuple]()
    
    public static var stockAlertsOrder = [String]()
    public static var cryptoAlertsOrder = [String]()
    public static var currentAlertsInOrder: [String] {
        get {
            if UserInfo.isStockMode {
                return UserInfo.stockAlertsOrder
            } else {
                return UserInfo.cryptoAlertsOrder
            }
        }
        set {
            if UserInfo.isStockMode {
                UserInfo.stockAlertsOrder = newValue
            } else {
                UserInfo.cryptoAlertsOrder = newValue
            }
        }
    }
    
    internal static var alertsWithOrder = [String:alertTupleAndOrder]() {
        didSet {
            UserInfo.tickerArray = alertsWithOrder.map { ($0.value.ticker, $0.value.order) }.sorted { $0.1 < $1.1 }.map { $0.0 }
            DashboardViewController.shared.refreshCompareGraph()
            Alerts.shared.saveCurrentAlerts()
            
        }
    }
    
    static var dashboardMode: Mode = .stocks {
        didSet {
            UserDefaults.standard.set(isCryptoMode ? true : false, forKey: "isCryptoDashboard")
        }
    }
    
    static var isCryptoMode: Bool {
        return dashboardMode == .crypto
    }
    static var isStockMode: Bool {
        return dashboardMode == .stocks
    }
    
}

enum Mode: String {
    case stocks, crypto
}

// alerts that are crypto must be saved with a key stat starts with the six character string "crypto". this is how they are filtered
extension String {
    var isStockAlertKey: Bool { return self[0...5] != "crypto" }
    var isCryptoAlertKey: Bool { return self[0...5] == "crypto" }
}

extension UserInfo {
    
    public static func populateAlertsWithOrder() {
        let alerts = UserInfo.alerts
        var newAlertsWithOrder: [String:alertTupleAndOrder] = [:]
        outerloop: for (key, value) in alerts {
            
            var alertsOrder: [String] {
                if key.isStockAlertKey {
                    return UserInfo.stockAlertsOrder
                } else {
                    return UserInfo.cryptoAlertsOrder
                }
            }
            
            if alertsOrder.contains(key),
                let index = alertsOrder.index(of: key) {
                newAlertsWithOrder[key] =  (name:value.name,isGreaterThan:value.isGreaterThan,price:value.price,deleted:value.deleted,email:value.email,flash:value.flash,sms:value.sms,ticker:value.ticker,triggered:value.triggered,push:value.push,urgent:value.urgent,timestamp:value.timestamp,order:index)
            } else {
                var alertsOrder2: [String] = alerts.map { $0.key }
                alertsOrder2.sort(by: >)
                newAlertsWithOrder.removeAll()
                let i = alertsOrder2.index(of: key)!
                for (key, value) in alerts {
                    newAlertsWithOrder[key] =  (name:value.name,isGreaterThan:value.isGreaterThan,price:value.price,deleted:value.deleted,email:value.email,flash:value.flash,sms:value.sms,ticker:value.ticker,triggered:value.triggered,push:value.push,urgent:value.urgent,timestamp:value.timestamp,order: i)
                }
                break outerloop
            }
        }
        
        UserInfo.alertsWithOrder = newAlertsWithOrder
    }
    
    public static func saveNotificationToken() {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
                FiretailDatabase.shared.saveUserInfoToFirebase(key: "token", value: result.token)
            }
        }
    }
}

public typealias alertTuple = (name:String,isGreaterThan:Bool,price:String,deleted:Bool,intelligent:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int)

public typealias alertTupleAndOrder = (name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int,order:Int)

