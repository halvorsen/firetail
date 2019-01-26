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
final class AppLoadingData {
    
    var fetchedTickers = [String]()

    internal static func loadCachedHistoricalDataForTickerArray() {
        let dataSets = CacheManager().loadData()
        guard UserInfo.tickerArray.count > 0 else {return}
        
        for i in 0..<UserInfo.tickerArray.count {
            for dataSet in dataSets {
                if dataSet.ticker == UserInfo.tickerArray[i] {
                    if Binance.isCryptoTickerSupported(ticker: dataSet.ticker) {
                        UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(1000))
                        UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(365))
                    }
                    UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                    UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                }
            }
        }
    }
    
    static func fetchAllStocks() {
        var savedCount = 0
        guard UserInfo.tickerArray.count > 0 else {return}
        Binance.dataSetBTC = nil
        for i in 0..<UserInfo.tickerArray.count {
            let symbol = UserInfo.tickerArray[i]
            if Binance.isCryptoTickerSupported(ticker: symbol) {
                Binance.fetchBinanceDollarPrice(forTicker: symbol) { (dataSet) in
                    if let dataSet = dataSet {
                        UserInfo.cachedInThisSession.append(symbol)
                        UserInfo.tenYearDictionary[symbol] = Array(dataSet.price.suffix(1000))
                        UserInfo.oneYearDictionary[symbol] = Array(dataSet.price.suffix(365))
                    }
                    savedCount += 1
                    if savedCount >= UserInfo.tickerArray.count {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                        
                    }
                }
            } else {
                
                IEXAPI.get20YearHistoricalData(ticker: symbol, isOneYear: false) { dataSet in
                    if let dataSet = dataSet {
                        UserInfo.cachedInThisSession.append(symbol)
                        UserInfo.tenYearDictionary[symbol] = Array(dataSet.price.suffix(2520))
                        UserInfo.oneYearDictionary[symbol] = Array(dataSet.price.suffix(252))
                    }
                    savedCount += 1
                    if savedCount >= UserInfo.tickerArray.count {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: updatedDataKey), object: self)
                    }
                }
            }
        }
    }
}
