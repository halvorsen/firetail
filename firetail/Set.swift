//
//  Practice.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/9/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase

public struct Set1 {
    
    public static var token: String {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            return refreshedToken
        } else {
            return "none"
        }
    }
    
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
        LoadSaveCoreData.saveUserInfoToFirebase(username: Set1.username, fullName: Set1.fullName, email: Set1.email, phone: Set1.phone, premium: Set1.premium, numOfAlerts: Set1.alertCount, brokerName: Set1.brokerName, brokerURL: Set1.brokerURL, weeklyAlerts: Set1.weeklyAlerts, userAlerts: Set1.userAlerts, token: Set1.token)
 
    }
}
