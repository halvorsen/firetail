//
//  AlertSort.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/2/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import Foundation

final class AlertSort {
    static let shared: AlertSort = AlertSort()
    // dictionarys containing alert order
    internal var cryptoArray: [String] = []
    internal var stockArray: [String] = [] {
        didSet {
            print("StockArray: \(stockArray)")
        }
    }
    
    internal var cryptoDictionary: [String: Int] = [:] {
        didSet {
//          _ =  MyFileManager.writeAlertOrderFile(filename: "Crypto", input: cryptoDictionary)
        }
    }
    internal var stockDictionary: [String: Int] = [:] {
        didSet {
//          _ =  MyFileManager.writeAlertOrderFile(filename: "Stock", input: stockDictionary)
        }
    }
    
    private init() {
//
//        if let dictionary = MyFileManager.readAlertOrderFile(named: "Crypto") {
//            cryptoDictionary = dictionary
//            cryptoArray = dictionary.map {($0.key, $0.value)}.sorted {$0.1 < $1.1}.map {$0.0}
//        }
//
//        if let dictionary = MyFileManager.readAlertOrderFile(named: "Stock") {
//            stockDictionary = dictionary
//            stockArray = dictionary.map {($0.key, $0.value)}.sorted {$0.1 < $1.1}.map {$0.0}
//        }
        
       check()
        //TODO: Add this check for crypto:
//        if cryptoDictionary.count != UserInfo.alertsCrypto.count {
//            print("crypto data models have become unsynced, resetting order")
//            // reorders by timestamp and spits out array of alert name strings in ascending timestamp order
//            setSortedStockAlerts(array: UserInfo.alertsCrypto.map { ($0.key, $0.value.timestamp) }.sorted {$0.1 < $1.1}.map {$0.0})
//        }
        
    }
    
    internal func check() {
        if stockDictionary.count != UserInfo.alerts.count {
            print("stock data models have become unsynced, resetting order")
            // reorders by timestamp and spits out array of alert name strings in ascending timestamp order
            setSortedStockAlerts(array: UserInfo.alerts.map { ($0.key, $0.value.timestamp) }.sorted {$0.1 < $1.1}.map {$0.0})
        }
        
        for key in cryptoArray + stockArray {
            if UserInfo.alerts[key] == nil {
                print("stock data models have become unsynced, resetting order (2)")
                // reorders by timestamp and spits out array of alert name strings in ascending timestamp order
                setSortedStockAlerts(array: UserInfo.alerts.map { ($0.key, $0.value.timestamp) }.sorted {$0.1 < $1.1}.map {$0.0})
                break
            }
        }
    }
    
    internal func getSortedCryptoAlerts() -> [String] {
        return cryptoDictionary.sorted { $0.value < $1.value }.map { $0.key }
    }
    
    internal func getSortedStockAlerts() -> [String] {
        return stockDictionary.sorted { $0.value < $1.value }.map { $0.key }
    }
    
    internal func setSortedCryptoAlerts(array: [String]) {
        cryptoArray = array
        cryptoDictionary.removeAll()
        for item in array.enumerated() {
            cryptoDictionary[item.element] = item.offset
        }
//        _ =  MyFileManager.writeAlertOrderFile(filename: "Crypto", input: cryptoDictionary)
    }
    
    internal func setSortedStockAlerts(array: [String]) {
        stockArray = array
        stockDictionary.removeAll()
        for item in array.enumerated() {
            stockDictionary[item.element] = item.offset
        }
        Alerts.shared.saveCurrentAlerts()
//        _ =  MyFileManager.writeAlertOrderFile(filename: "Stock", input: stockDictionary)
    }
    
    internal func addToStack(alert: String) {
        addToIndex(0, alert: alert)
    }
    
    internal func addToIndex(_ index: Int, alert: String) {
        if alert[0...5] == "Crypto" {
            cryptoArray.insert(alert, at: index)
            cryptoDictionary.removeAll()
            for alert in cryptoArray.enumerated() {
                cryptoDictionary[alert.element] = alert.offset
            }
//            _ =  MyFileManager.writeAlertOrderFile(filename: "Crypto", input: cryptoDictionary)
        }
        else {
            stockArray.insert(alert, at: index)
            stockDictionary.removeAll()
            for alert in stockArray.enumerated() {
                stockDictionary[alert.element] = alert.offset
            }
            Alerts.shared.saveCurrentAlerts()
//            _ =  MyFileManager.writeAlertOrderFile(filename: "Stock", input: stockDictionary)
        }
    }
    
    internal func delete(_ alert: String) {
        if alert[0...5] == "Crypto" {
            guard let index = cryptoDictionary[alert] else { return }
            cryptoArray.remove(at: index)
            cryptoDictionary.removeAll()
            for alert in cryptoArray.enumerated() {
                cryptoDictionary[alert.element] = alert.offset
            }
//            _ =  MyFileManager.writeAlertOrderFile(filename: "Crypto", input: cryptoDictionary)
        }
        else {
            guard let index = stockDictionary[alert] else { return }
          
            stockArray.remove(at: index)
            stockDictionary.removeAll()
            for alert in stockArray.enumerated() {
                stockDictionary[alert.element] = alert.offset
            }
            Alerts.shared.saveCurrentAlerts()
//            _ =  MyFileManager.writeAlertOrderFile(filename: "Stock", input: stockDictionary)
        }
    }
    
    internal func moveItem(alert: String, at: Int, to: Int) {
        if alert[0...5] == "Crypto" {
            cryptoArray = rearrange(array: cryptoArray, at: at, to: to)
            cryptoDictionary.removeAll()
            for alert in cryptoArray.enumerated() {
                cryptoDictionary[alert.element] = alert.offset
            }
//            _ =  MyFileManager.writeAlertOrderFile(filename: "Crypto", input: cryptoDictionary)
        }
        else {
            stockArray = rearrange(array: stockArray, at: at, to: to)
            stockDictionary.removeAll()
            for alert in stockArray.enumerated() {
                stockDictionary[alert.element] = alert.offset
            }
            Alerts.shared.saveCurrentAlerts()
//            _ =  MyFileManager.writeAlertOrderFile(filename: "Stock", input: stockDictionary)
        }
        
    }
    
   
    
}
