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
    func get20YearHistoricalData(ticker: String, isOneYear: Bool = true, result: @escaping (_ stockDataTuple:([Double]?,[(String,Int)]?,Error?)) -> Void) {
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
                  
                    result((nil,nil,error))
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
                    
                        result((_prices, _dates, nil))
                        
                    }
                    
                }
            })
            
            
            task.resume()
        }
        
    }
    
}
