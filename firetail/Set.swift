//
//  Practice.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/9/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

public struct Set {
    
    public static var currentPrice: Double = 0.0
    
    public static var yesterday: Double = 0.0
    
    public static var alertCount: Int = 0
    
    public static var oneYearDictionary: [String:[Double]] = ["":[0.0]]
    
    public static var ti = [String]()
    
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
    
    public static var userAlerts = [String:String]()
    
    public static var alerts = [String:(name:String,isGreaterThan:Bool,price:Double,deleted:Bool,email:Bool,flash:Bool,sms:Bool,ticker:String,triggered:Bool,push:Bool,urgent:Bool)]()
    
    public static func saveUserInfo() {
    LoadSaveCoreData.saveUserInfoToFirebase(username: Set.username, fullName: fullName, email: Set.email, phone: Set.phone, premium: Set.premium, numOfAlerts: Set.alertCount, brokerName: Set.brokerName, brokerURL: Set.brokerURL, weeklyAlerts: Set.weeklyAlerts, userAlerts: Set.userAlerts)
 
    }
}
