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
        
        var _prices = [Double]()
        var _dates = [(String,Int)]()
        var rawDates = [String]()
        let monthStrings =
            ["zero","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        
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
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print("fetch returned error")
                print(error!.localizedDescription)
                
                result(nil)
            }
            else {
                var json = [String: [String:Any]]()
                do {
                    if let _json = try JSONSerialization.jsonObject(with: data!) as? [String: [String:Any]] {
                        json = _json
                    } else {
                        result(nil)
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
