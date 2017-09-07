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
    func get20YearHistoricalData(ticker: String, done: @escaping (_ prices: [Double]?, _ dates: [(String,Int)]?, _ error: Error?) -> Void ) {
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
                }
                else {
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data!) as? [String: [String:Any]] {
                            
                            //,let datas = json["Time Series (Daily)"] as? [String:Any]
                            for (keyRoot,valueRoot) in json {
                                if keyRoot == "Time Series (Daily)" {
                                    for (date,packet) in valueRoot {
                                        rawDates.append(date)
                                        guard let packet = packet as? [String:Any] else {return}
                                    }
                                }
                            }
                            
                            let sortedDates = rawDates.sorted().reversed()
                            
                            
                            
                            if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any],
                                let datas = json["Time Series (Daily)"] as? [String:Any] {
                                
                                for dateString in sortedDates {
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-mm-dd"
                                    dateFormatter.locale = Locale.init(identifier: "en_GB")
                                    let dateObj = dateFormatter.date(from: dateString)!
                                    
                                    let calendar = Calendar.autoupdatingCurrent
                                    let components = calendar.dateComponents([.year,.month,.day], from: dateObj)
                                    let year = components.year
                                    let month = components.month
                                    let day = components.day
                                    _dates.append((monthStrings[month!],day!))
                                    if let packet = datas[dateString] as? [String:String] {
                                        for (key,value) in packet {
                                            if key == "5. adjusted close" {
                                                if let value = value as? String {
                                                    _prices.append(Double(value)!)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            
                            
                            done(_prices, _dates, nil)
                            
                            
                        }
                        
                        
                    }
                    catch {
                        print("error in JSONSerialization")
                    }
                }
            })
            
            
            task.resume()
        }
        
    }
    
}
