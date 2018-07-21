//
//  Alerts.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/17/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//
import Foundation
final class Alerts {
    internal static var shared: Alerts = Alerts()
    
    private init() {
        var alertTemp: [String: alertTuple] = [:]
        var alertOrderTemp: [String] = []
        DispatchQueue.main.async {
            let _rawDictionary = MyFileManager.read(named: "stockAlerts")
            if let rawDictionary = _rawDictionary {
                for (alertKey, value) in rawDictionary {
                    
                    if let dictionaryArray = value as? [String: Any] {
                        if let name = dictionaryArray["name"] as? String,
                            let isGreaterThan = dictionaryArray["isGreaterThan"] as? Bool,
                            let price = dictionaryArray["price"] as? String,
                            let deleted = dictionaryArray["deleted"] as? Bool,
                            let email = dictionaryArray["email"] as? Bool,
                            let flash = dictionaryArray["flash"] as? Bool,
                            let sms = dictionaryArray["sms"] as? Bool,
                            let ticker = dictionaryArray["ticker"] as? String,
                            let triggered = dictionaryArray["triggered"] as? String,
                            let push = dictionaryArray["push"] as? Bool,
                            let urgent = dictionaryArray["urgent"] as? Bool,
                            let timestamp = dictionaryArray["timestamp"] as? Int {
                            
                            alertTemp[alertKey] = (name:name,isGreaterThan:isGreaterThan,price:price,deleted:deleted,email:email,flash:flash,sms:sms,ticker:ticker,triggered:triggered,push:push,urgent:urgent,timestamp:timestamp)
                            print("HERE?")
                            alertOrderTemp.append(alertKey)
                        }
                        
                    }
                }
                UserInfo.alerts = alertTemp
                DashboardViewController.shared.collectionView?.reloadData()
                UserInfo.stockAlertsOrder = alertOrderTemp.sorted(by: <).filter { $0.isStockAlertKey }
                UserInfo.cryptoAlertsOrder = alertOrderTemp.sorted(by: <).filter { $0.isCryptoAlertKey }
            }
        }
    }
    
    internal func saveCurrentAlerts() {
        DispatchQueue.main.async {
            var dictionaryStocks = [String:[String: Any]]()
            for (alertKey, value) in UserInfo.alertsWithOrder {
                
                dictionaryStocks[alertKey] = [
                    "name": value.name,
                    "isGreaterThan": value.isGreaterThan,
                    "price": value.price,
                    "deleted": value.deleted ,
                    "email": value.email,
                    "flash": value.flash,
                    "sms": value.sms,
                    "ticker": value.ticker,
                    "triggered": value.triggered,
                    "push": value.push,
                    "urgent": value.urgent,
                    "timestamp": value.timestamp,
                    "order": value.order
                ]
                
                _ = MyFileManager.write(filename: "stockAlerts", input: dictionaryStocks)
            }
        }
    }
    
    internal static func eraseStockAlertFile() {
        _ = MyFileManager.write(filename: "stockAlerts", input: [:])
    }
    
    
}
