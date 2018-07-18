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
    
    public static var tickerArray = [String]()
    
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
    
    public static var alerts = [String:(name:String,isGreaterThan:Bool,price:String,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:String,push:Bool,urgent:Bool,timestamp:Int)]()
    
    public static func saveUserInfo() {
        guard UserInfo.email != "none" else {UserInfo.email = UserInfo.username; return}
        LoadSaveCoreData.saveUserInfoToFirebase(username: UserInfo.username, fullName: UserInfo.fullName, email: UserInfo.email, phone: UserInfo.phone, premium: UserInfo.premium, numOfAlerts: UserInfo.userAlerts.count, brokerName: UserInfo.brokerName, brokerURL: UserInfo.brokerURL, weeklyAlerts: UserInfo.weeklyAlerts, userAlerts: UserInfo.userAlerts, token: UserInfo.token)
    }
}  

