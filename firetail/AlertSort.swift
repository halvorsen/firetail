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
    private var cryptoArray: [String] = []
    private var stockArray: [String] = []
    
    private var cryptoDictionary: [String: Int] = [:] {
        didSet {
          _ =  MyFileManager.writeAlertOrderFile(filename: "Crypto", input: cryptoDictionary)
        }
    }
    private var stockDictionary: [String: Int] = [:] {
        didSet {
          _ =  MyFileManager.writeAlertOrderFile(filename: "Stock", input: stockDictionary)
        }
    }
    
    init() {
        
        if let dictionary = MyFileManager.readAlertOrderFile(named: "Crypto") {
            cryptoDictionary = dictionary
        }
        
        if let dictionary = MyFileManager.readAlertOrderFile(named: "Stock") {
            stockDictionary = dictionary
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
        for item in array.enumerated() {
            cryptoDictionary[item.element] = item.offset
        }
    }
    
    internal func setSortedStockAlerts(array: [String]) {
        stockArray = array
        for item in array.enumerated() {
            stockDictionary[item.element] = item.offset
        }
    }
    
    internal func addToStack(alert: String) {
        addToIndex(0, alert: alert)
    }
    
    internal func addToIndex(_ index: Int, alert: String) {
        if alert[0...5] == "Crypto" {
            cryptoArray.insert(alert, at: index)
            for alert in stockArray.enumerated() {
                cryptoDictionary[alert.element] = alert.offset
            }
        }
        else {
            stockArray.insert(alert, at: index)
            for alert in stockArray.enumerated() {
                stockDictionary[alert.element] = alert.offset
            }
        }
    }
    
}
