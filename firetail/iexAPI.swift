//
//  iexAPI.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/29/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import Foundation

final class IEXAPI {
    
    static func get20YearHistoricalData(ticker: String, isOneYear: Bool = true, result: @escaping (_ stockData: DataSet?) -> Void) {
        var _prices = [Double]()
        var _dates = [(String,Int)]()
        var rawDates = [String]()
        let monthStrings =
            ["zero","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        
        let url = URL(string: "https://api.iextrading.com/1.0/stock/\(ticker.uppercased())/chart/5y?filter=date,close")
        if let url = url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
               
                if error != nil {
                    print("fetch returned error")
                    print(error!.localizedDescription)
                    
                    result(nil)
                }
                else {
                    var json = [[String:Any]]()
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data!)

                        if let _json = jsonObject as? [[String:Any]] {
                            json = _json
                        } else {
                            result(nil)
                        }
                    }
                    catch {
                        print("error in JSONSerialization2")
                        result(nil)
                    }
                    for jsonElement in json {
                        for (keyRoot,valueRoot) in jsonElement {
                            if keyRoot == "date",
                                let date = valueRoot as? String {
                                rawDates.append(date)
                            } else if keyRoot == "close",
                                let price = valueRoot as? Double {
                                _prices.append(price)
                            }
                        }
                    }

                        for dateString in rawDates {

                            guard dateString.count > 8 else { return }
                            let _month = dateString[5...6]
                            let _day = dateString[8...9]
                            if let month = Int(_month),
                                let day = Int(_day) {

                                _dates.append((monthStrings[month],day))
                            }
                        }
                        //caching 10 years no matter what
                        var cacheprices = [Double]()
                        var cachedates = [(String,Int)]()

                        if _prices.count > 2521  {
                            cacheprices = Array(_prices[(_prices.count-2520)..<_prices.count])
                            cachedates = Array(_dates[(_dates.count-2520)..<_dates.count])
                        } else {
                            cacheprices = _prices
                            cachedates = _dates
                        }
                        var cachedays = [Int]()
                        var cachemonths = [String]()
                        for i in 0..<cacheprices.count {
                            cachedays.append(cachedates[i].1)
                            cachemonths.append(cachedates[i].0)
                        }
                        CacheManager.shared.cacheData(ticker: ticker, prices: cacheprices, days: cachedays, months: cachemonths)
                        //end caching

                        if isOneYear {

                            if _prices.count > 253  {
                                _prices = Array(_prices[(_prices.count-253)..<_prices.count])
                                _dates = Array(_dates[(_dates.count-253)..<_dates.count])
                            }
                        } else { //ten years
                            if _prices.count > 2521  {
                                _prices = Array(_prices[(_prices.count-2520)..<_prices.count])
                                _dates = Array(_dates[(_dates.count-2520)..<_dates.count])
                            }
                        }
                        var _days = [Int]()
                        var _months = [String]()
                        for i in 0..<_prices.count {
                            _days.append(_dates[i].1)
                            _months.append(_dates[i].0)
                        }

                        result(DataSet(ticker: ticker, price: _prices, month: _months, day: _days))
                    
                }
            })
            
            
            task.resume()
        }
        
    }
    
   static func populateUserInfoMonth() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let mo = ["","January," + " " + String(year - 1),
                  "Febrary," + " " + String(year - 1),
                  "March," + " " + String(year - 1),
                  "April," + " " + String(year - 1),
                  "May," + " " + String(year - 1),
                  "June," + " " + String(year - 1),
                  "July," + " " + String(year - 1),
                  "August," + " " + String(year - 1),
                  "September," + " " + String(year - 1),
                  "October," + " " + String(year - 1),
                  "November," + " " + String(year - 1),
                  "December," + " " + String(year - 1),
                  "January," + " " + String(year),
                  "Febrary," + " " + String(year),
                  "March," + " " + String(year),
                  "April," + " " + String(year),
                  "May," + " " + String(year),
                  "June," + " " + String(year),
                  "July," + " " + String(year),
                  "August," + " " + String(year),
                  "September," + " " + String(year),
                  "October," + " " + String(year),
                  "November," + " " + String(year),
                  "December," + " " + String(year)]
        var _mo = [String]()
        let dComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        for i in 0..<13 {
            _mo.append(mo[dComponent.month! + i])
        }
        UserInfo.month = _mo
    }
}
