//
//  File.swift
//  firetail
//
//  Created by Aaron Halvorsen on 5/25/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

class Google {
    var _years = Int()
    var monthAndDay = [(String,Int)]()
    var closingPrices = [Double]()
    var basket = [Int:[(Double,String,Int)]]()
    var count = 0 {didSet{
        print("Count: \(count)")
        print("bool: \(count == _years + 1)")
        if count == _years + 1 {
            for i in (1..._years).reversed() {
                for (price,month,day) in basket[i]! {
                    closingPrices.append(price)
                    monthAndDay.append((month,day))
                }
            }
        }
        
        }
    }
    
    let practice = "http://www.google.com/finance/historical?q=NASDAQ:ADBE&startdate=Jan+01%2C+2009&enddate=Aug+2%2C+2012&output=csv"
    let monthStrings = ["zero","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    //date info in first column: "11-May-17"
    // func callCorrectGraph2(stockName: String, result: @escaping (_ stockData: ([String],[StockData2?])) -> Void) {
    func oneYearHistoricalPrices(years: Int, index: String, ticker: String, result: @escaping (_ stockDataTuple:([Double]?,[(String,Int)]?,Error?)) -> Void) {
        _years = years
        
        var oneYearAgo = DateComponents()
        var oneYearAgoPlusOne = DateComponents()
        var isNone = true
        
        var _error: Error?
        // if isNone {
        print("ENTERED GATE")
        //   isNone = false
        for i in (1...years).reversed() {
            oneYearAgo.year = -1
            oneYearAgoPlusOne.year = (-i+1)
            fetchFromGoogle(yearStart: i, dateComponentStart: oneYearAgo, dateComponentEnd: oneYearAgoPlusOne, ticker: ticker, index: index)
            if i == 1 {
                delay(bySeconds: 7.0) {
                    if self.count == years + 1 {
                        print("PASSNOW!!!!!!")
                        print((self.closingPrices,self.monthAndDay,_error))
                       result((self.closingPrices,self.monthAndDay,_error))
                    }
                }
            }
        }
        var price = [Double]()
        let url = URL(string: "http://www.google.com/finance/info?q=" + index + ":" + ticker)
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        //       print(stringData) //JSONSerialization
                        
                        
                        print("BANANA")
                        print(stringData)
                        let dataInArrays2 = self.csv(data: stringData)
                        //                                        if let dataInArrays2 = Double(dataInArrays[i][4]) {
                        //                                            let myd = dataInArrays2[i][0].characters.map { String($0) }
                        //                                            var m = String()
                        //                                            var d = String()
                        //                                            var dash = 0
                        //                                            for char in myd {
                        //                                                if char != "-" && dash == 0 {
                        //                                                    d.append(char)
                        //                                                } else if char != "-" && dash == 1 {
                        //                                                    m.append(char)
                        //                                                } else {
                        //                                                    dash += 1
                        //                                                }
                        //                                            }
                        //                                        }
                        //
                        //                                        monthAndDay.append((m,Int(d)!))
                        //                                        closingPrices.append(dataInArrays2)
                    }
                }
                self.basket[(years + 1)] = [(999.00,"day",1)]
                self.count += 1
            })
            
            task.resume()
        }
        
    }
    
    
    private func fetchFromGoogle(yearStart: Int, dateComponentStart: DateComponents, dateComponentEnd: DateComponents, ticker: String, index: String) {
        print("entered fetchfromgoogle func")
        let endDate = Calendar.current.date(byAdding: dateComponentEnd, to: Date())
        let endDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: endDate!)
        let startDate = Calendar.current.date(byAdding: dateComponentStart, to: endDate!)
        let startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate!)
        let startDateMonth = monthStrings[startDateComponents.month!]
        let startDateYear = String(describing: startDateComponents.year!)
        let startDateDay = String(describing: startDateComponents.day!)
        print("start \(String(describing: startDateComponents.day)), \(startDateDay)")
        let endDateMonth = monthStrings[endDateComponents.month!]
        let endDateYear = String(describing: endDateComponents.year!)
        let endDateDay = String(describing: endDateComponents.day!)
        let stringComponents: [String] = ["http://www.google.com/finance/historical?q=",index,":",ticker,"&startdate=",startDateMonth,"+",startDateDay,"%2C",startDateYear,"&enddate=",endDateMonth,"+",endDateDay,"%2C",endDateYear,"&output=csv"]
        
        let urlString = stringComponents.flatMap({$0}).joined()
        print(urlString)
        let url = URL(string: urlString)
        var priceData = [(Double,String,Int)]()
        
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                //   if error != nil {result((nil,nil,_error))}
                let _error = error
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        let dataInArrays = self.csv(data: stringData)
                        guard dataInArrays.count > 2 else {print("google data request error"); return}
                        for i in 1...(dataInArrays.count-2) {
                            if let _dataInArrays = Double(dataInArrays[i][4]) {
                                let myd = dataInArrays[i][0].characters.map { String($0) }
                                var m = String()
                                var d = String()
                                var dash = 0
                                for char in myd {
                                    if char != "-" && dash == 0 {
                                        d.append(char)
                                    } else if char != "-" && dash == 1 {
                                        m.append(char)
                                    } else {
                                        dash += 1
                                    }
                                }
                          
                                priceData.append((_dataInArrays,m,Int(d)!))
                                
                            }
                        }
                        self.basket[yearStart] = priceData
                        self.count += 1
                    }
                }
            })
            task.resume()
            
            
            
            
            
        }
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    private func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    private enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
}
