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
    var count = 0
    let monthStrings = ["zero","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    //date info in first column: "11-May-17"
    // func callCorrectGraph2(stockName: String, result: @escaping (_ stockData: ([String],[StockData2?])) -> Void) {
    func historicalPrices(years: Int, ticker: String, result: @escaping (_ stockDataTuple:([Double]?,[(String,Int)]?,Error?)) -> Void) {
        _years = years
        var index = ""
        if IndexListOfStocks.nasdaq.contains(ticker) {
            index = "NASDAQ"
        } else if IndexListOfStocks.nyse.contains(ticker) {
            index = "NYSE"
        } else if IndexListOfStocks.amex.contains(ticker) {
            index = "AMEX"
        }
        var start = DateComponents()
        var end = DateComponents()
        var _error: Error?
        
        start.year = -years
        end.year = 0
        fetchFromGoogle(yearStart: years, dateComponentStart: start, dateComponentEnd: end, ticker: ticker, index: index)
        
       
        let url = URL(string: "http://www.google.com/finance/info?q=" + index + ":" + ticker)
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                var stringData = String()
                if let data = data {
                    if let _stringData = String(data: data, encoding: String.Encoding.utf8) {
                        stringData = _stringData
                        //JSONSerialization
                    }
                }
                var stringPrice = String()
                let arrayData = Array(stringData.characters)
                dance: for i in 0..<arrayData.count {
                    if arrayData[i] == "l" {
                        if arrayData[i+1] == "\"" {
                             for j in 0...10 {
                                if arrayData[i+j+6] == "\"" {break dance}
                                stringPrice += String(arrayData[i+j+6])
                            }
                        }
                    }
                }
                
                let componentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                let monthToday = self.monthStrings[componentDate.month!]
                let dayToday = componentDate.day!
                guard Double(stringPrice) != nil else {return}
                self.basket[1] = [(Double(stringPrice)!,monthToday,dayToday)]
                
                self.count += 1
                var dontStop = true
                for i in 1...10 {
                self.delay(bySeconds: 1.0*Double(i)) {
                    if self.count == 2 && dontStop {
                        dontStop = false
                        for i in 0...1 {
                            for (price,month,day) in self.basket[i]!.reversed() {
                                self.closingPrices.append(price)
                                self.monthAndDay.append((month,day))
                            }
                        }
                        result((self.closingPrices,self.monthAndDay,_error))
                    }
                }
                }
            })
            
            task.resume()
        }
        
    }
    
    
    private func fetchFromGoogle(yearStart: Int, dateComponentStart: DateComponents, dateComponentEnd: DateComponents, ticker: String, index: String) {
       
        let endDate = Calendar.current.date(byAdding: dateComponentEnd, to: Date())
        let endDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: endDate!)
        let startDate = Calendar.current.date(byAdding: dateComponentStart, to: endDate!)
        let startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate!)
        let startDateMonth = monthStrings[startDateComponents.month!]
        let startDateYear = String(describing: startDateComponents.year!)
        let startDateDay = String(describing: startDateComponents.day!)
        let endDateMonth = monthStrings[endDateComponents.month!]
        let endDateYear = String(describing: endDateComponents.year!)
        let endDateDay = String(describing: endDateComponents.day!)
        let stringComponents: [String] = ["http://www.google.com/finance/historical?q=",index,":",ticker,"&startdate=",startDateMonth,"+",startDateDay,"%2C+",startDateYear,"&enddate=",endDateMonth,"+",endDateDay,"%2C+",endDateYear,"&output=csv"]
        
        let urlString = stringComponents.flatMap({$0}).joined()
        let url = URL(string: urlString)
        var priceData = [(Double,String,Int)]()
        
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                //   if error != nil {result((nil,nil,_error))}
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

                        self.basket[0] = priceData
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
