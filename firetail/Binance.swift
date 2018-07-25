//
//  Binance.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/24/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

/*
 1fqdUoR6mfHjswvvDJkhSVrPobsZu65ceuPzRVqU6CZfhHkFI1DRZhhsxvT0hwfR
 Secret:
 SKJj0QbHE8KHnzBTPeOOUjNJNuMEhljg9HhWkgs04KnrODNKr2ZO84W9z3O0gH29
 */

import Foundation

final class Binance {
    
    static func getOneYearHistoricalData(symbol: String, result: @escaping (_ stockData: DataSet?) -> Void) {
        let interval = "1d"
        let limit = "365"
        var componentURL = URLComponents(string: "https://api.binance.com/api/v1/klines")!
        
        /*
 symbol    STRING    YES
 interval    ENUM    YES
 startTime    LONG    NO
 endTime    LONG    NO
 limit    INT    NO    Default 500; max 1000.
 */
        
        componentURL.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "interval", value: interval),
            URLQueryItem(name: "limit", value: limit),
        ]
        
        let request = URLRequest(url: componentURL.url!)
        /*
 [
 [
 1499040000000,      // Open time
 "0.01634790",       // Open
 "0.80000000",       // High
 "0.01575800",       // Low
 "0.01577100",       // Close
 "148976.11427815",  // Volume
 1499644799999,      // Close time
 "2434.19055334",    // Quote asset volume
 308,                // Number of trades
 "1756.87402397",    // Taker buy base asset volume
 "28.46694368",      // Taker buy quote asset volume
 "17928899.62484339" // Ignore.
 ]
 ]
 */
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
           
            if error != nil {
               
                result(nil)
            }
            else {
          
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [[Any]] {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = DateFormatter.Style.medium
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateStyle = DateFormatter.Style.short
                        let oneYearPriceArray = json.map { Double($0[4] as! String)! }
                        
                        let month: [String] = json.map { entry in
                           let timestampMS = entry[6] as! Double
                        let date = Date(timeIntervalSince1970: timestampMS/1000)
                            let localDate = dateFormatter.string(from: date)
                            let mon = localDate[0...2]
                            return mon
                        }
                        
                        let calendar = Calendar.current
                        
                        let day: [Int] = json.map { entry in
                            let timestampMS = entry[6] as! Double
                            let date = Date(timeIntervalSince1970: timestampMS/1000)
                           let day = calendar.component(.day, from: date)
                            return day
                        }
                       result( DataSet(ticker: symbol, price: oneYearPriceArray, month: month, day: day) )
                    }
                   
                }
                catch {
                    print("error in JSONSerialization")
                    result(nil)
                }
            }
        })
        
        task.resume()
        
    }
}
