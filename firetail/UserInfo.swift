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
    
    public static func logoutFirebase() {
        try! Auth.auth().signOut()
    }
    
    public static var flashOn: Bool = false
    public static var smsOn: Bool = false
    public static var emailOn: Bool = false
    public static var pushOn: Bool = false
    public static var allOn: Bool = false
    
    public static var token: String = "none"
    
    public static var currentPrice: Double = 0.0
    
    public static var yesterday: Double = 0.0
    
    public static var cachedInThisSession = [String]()
    
    public static var oneYearDictionary: [String:[Double]] = ["":[0.0]]
    
    public static var tenYearDictionary: [String:[Double]] = ["":[0.0]]
    
    public static var tickerArray = [String]() {
        didSet {
            AppLoadingData.loadCachedHistoricalDataForTickerArray()
        }
    }
    
    public static var month = ["","","","","","","","","","","",""]
    
    public static var phone = "none"
    
    public static var email = "none"
    
    public static var brokerName = "none"
    
    public static var username = "none"
    
    public static var fullName = "none"
    
    public static var premium = false
    
    public static var numOfAlerts = [Int]()
    
    public static var brokerURL = "none"
    
    public static var createdAt = "none"
    
    public static var weeklyAlerts: [String:Int] = ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
    
    public static var userAlerts : [String:String] = [:] 
    
    public static var alerts = [String:(name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int)]() {
        didSet {
            Alerts.shared.saveCurrentAlerts()
            UserInfo.populateAlertsWithOrder()
        }
    }
    
    public static var alertsOrder = [String]()
    
    public static var alertsWithOrder = [String:(name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int,order:Int)]() {
        didSet {
            UserInfo.tickerArray = alertsWithOrder.map { ($0.value.ticker, $0.value.order) }.sorted { $0.1 < $1.1 }.map { $0.0 }
            DashboardViewController.shared.refreshAlertsAndCompareGraph()
        }
    }
    
    public static func populateAlertsWithOrder() {
        let alerts = UserInfo.alerts
        let alertsOrder = UserInfo.alertsOrder
        var newAlertsWithOrder: [String:(name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int,order:Int)] = [:]
        outerloop: for (key, value) in alerts {
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
       
    
    public static func saveUserInfo() {
        guard UserInfo.email != "none" else {UserInfo.email = UserInfo.username; return}
        LoadSaveCoreData.saveUserInfoToFirebase(username: UserInfo.username, fullName: UserInfo.fullName, email: UserInfo.email, phone: UserInfo.phone, premium: UserInfo.premium, numOfAlerts: UserInfo.userAlerts.count, brokerName: UserInfo.brokerName, brokerURL: UserInfo.brokerURL, weeklyAlerts: UserInfo.weeklyAlerts, userAlerts: UserInfo.userAlerts, token: UserInfo.token)
    }
}

typealias alertTuple = (name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int)
typealias alertTupleAndOrder = (name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int,order:Int)

