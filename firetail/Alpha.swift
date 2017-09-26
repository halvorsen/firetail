//
//  Alpha.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/7/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
// API KEY: PG1MGP38L4K05H5T

//https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=MSFT&outputsize=full&apikey=PG1MGP38L4K05H5T

import Foundation

class Alpha {
    let cacheManager = CacheManager()
    func get20YearHistoricalData(ticker: String, isOneYear: Bool = true, result: @escaping (_ stockData: DataSet?) -> Void) {
        var _prices = [Double]()
        var _dates = [(String,Int)]()
        var rawDates = [String]()
        let monthStrings =
            ["zero","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(ticker.uppercased())&outputsize=full&apikey=PG1MGP38L4K05H5T")
        if let url = url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    
                    result(nil)
                }
                else {
                    
                    var json = [String: [String:Any]]()
                    do {
                        
                        if let _json = try JSONSerialization.jsonObject(with: data!) as? [String: [String:Any]] {
                            json = _json
                            
                        }
                    }
                    catch {
                        print("error in JSONSerialization")
                        result(nil)
                    }
                    
                    for (keyRoot,valueRoot) in json {
                        if keyRoot == "Time Series (Daily)" {
                            
                            for (date,_) in valueRoot {
                                rawDates.append(date)
                                
                            }
                        }
                    }
                    
                    let sortedDates = rawDates.sorted()
                    
                    if let datas = json["Time Series (Daily)"] {
                        
                        for dateString in sortedDates {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-mm-dd"
                            dateFormatter.locale = Locale.init(identifier: "en_GB")
                            let dateObj = dateFormatter.date(from: dateString)!
                            
                            let calendar = Calendar.autoupdatingCurrent
                            let components = calendar.dateComponents([.year,.month,.day], from: dateObj)
                            let month = components.month
                            let day = components.day
                            _dates.append((monthStrings[month!],day!))
                            if let packet = datas[dateString] as? [String:String] {
                                
                                for (key,value) in packet {
                                    if key == "5. adjusted close" {
                                        
                                        _prices.append(Double(value)!)
                                        
                                    }
                                }
                            }
                        }
                        //caching 10 years no matter what
                        var cacheprices = [Double]()
                        var cachedates = [(String,Int)]()
                        
                        if _prices.count > 2521  {
                            cacheprices = Array(_prices[(_prices.count-2520)..<_prices.count])
                            cachedates = Array(_dates[(_dates.count-2520)..<_dates.count])
                        }
                        var cachedays = [Int]()
                        var cachemonths = [String]()
                        for i in 0..<_prices.count {
                            cachedays.append(cachedates[i].1)
                            cachemonths.append(cachedates[i].0)
                        }
                        self.cacheManager.saveStockData(ticker: ticker, prices: cacheprices, days: cachedays, months: cachemonths)
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
                    
                }
            })
            
            
            task.resume()
        }
        
    }
    
    //    struct DataSet {
    //
    //        var ticker: String
    //        var price: [Double]
    //        var month: [String]
    //        var day: [Int]
    //
    //    }
    
    func populateSet1Month() {
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
        
        Set1.month = _mo
    }
    
    
}
