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
        let limit = "1000"
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
            print(data); print(response); print(error)
            if error != nil {
                
                result(nil)
            }
            else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [[Any]] {
                        print("json \(json)")
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
                    } else {
                        print("json error")
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
    static var dataSetBTC: DataSet?
    
    private static func getFetchBinanceSymbols(forTicker ticker: String) -> (String, String?)? {
        let _symbols = Binance.binanceFetchSymbols[ticker.uppercased()]
        guard let symbols = _symbols else { return nil}
        
        if symbols.count == 1 {
            return (symbols[0],nil)
        }
        else  {
            return (ticker + "BTC", "BTCUSDT")
        }
    }
    
    static func fetchBinanceDollarPrice(forTicker ticker: String, callback: @escaping (_ stockData: DataSet?) -> Void) {
        guard let (firstSymbol, secondSymbol) = Binance.getFetchBinanceSymbols(forTicker: ticker) else { callback(nil); return}
        getOneYearHistoricalData(symbol: firstSymbol) { dataSet in
            guard let firstDataSet = dataSet else {callback(nil); return}
            if let second = secondSymbol {
                
                func computeAndSendCallback() {
                    var price = [Double]()
                    guard let data = dataSetBTC else {callback(nil); return}
                    let lowerCount = min(data.price.count, firstDataSet.price.count)
                    let dataMidIndex = data.price.count - lowerCount
                    let firstDataMidIndex = firstDataSet.price.count - lowerCount
                    for i in 0..<lowerCount{
                        price.append(data.price[dataMidIndex + i] * firstDataSet.price[firstDataMidIndex + 1])
                    }
                    let months = firstDataSet.month.count < data.month.count ? firstDataSet.month : data.month
                    let days = firstDataSet.day.count < data.day.count ? firstDataSet.day : data.day
                    CacheManager.shared.cacheData(ticker: ticker.uppercased(), prices: price, days: days, months: months)
                    callback(DataSet(ticker: ticker.uppercased(), price: price, month: months, day: days))
                }
                
                if dataSetBTC == nil {
                    getOneYearHistoricalData(symbol: "BTCUSDT") { _dataSet in
                        
                        guard let secondDataSet = _dataSet else {callback(nil); return }
                        Binance.dataSetBTC = secondDataSet
                        computeAndSendCallback()
                    }
                    
                } else {
                    computeAndSendCallback()
                }
                
                
            } else {
                
                CacheManager.shared.cacheData(ticker: ticker.uppercased(), prices: firstDataSet.price, days: firstDataSet.day, months: firstDataSet.month)
                callback(DataSet(ticker: ticker.uppercased(), price: firstDataSet.price, month: firstDataSet.month, day: firstDataSet.day))
                
            }
            
        }
    }
    
    public static func isCryptoTickerSupported(ticker: String) -> Bool {
        var returnValue = false
        Crypto.allCases.forEach { enumeratedValue in
            
            if enumeratedValue.rawValue.uppercased() == ticker.uppercased() {
                returnValue = true
            }
            
        }
        return returnValue
    }
    
    static let binanceFetchSymbols: [String: [String]] = [
        // blank arrays can be translated by BTC
        "ETH": ["ETHUSDT"],
        "BTC": ["BTCUSDT"],
        "EOS": ["EOSUSDT"],
        "XLM":["XLMUSDT"],
        "IOST":[],
        "BCC":["BCCUSDT"],
        "TRX":["TRXUSDT"],
        "BNB":["BNBUSDT"],
        "ADA":["ADAUSDT"],
        "XRP":["XRPUSDT"],
        "QKC":[],
        "NEO":["NEOUSDT"],
        "LTC":["LTCUSDT"],
        "ICX":["ICXUSDT"],
        "ARN":[],
        "ZRX":[],
        "ZIL":[],
        "KEY":[],
        "NPXS":[],
        "ONT":["ONTUSDT"],
        "IOTA":["IOTAUSDT"],
        "ETC":["ETCUSDT"],
        "TUSD":["TUSDUSDT"],
        "REP":[],
        "NAS":[],
        "ADX":[],
        "NANO":[],
        "BAT":[],
        "XMR":[],
        "HOT":[],
        "DASH":[],
        "XVG":[],
        "GTO":[],
        "IOTX":[],
        "INS":[],
        "VEN":[],
        "WAN":[],
        "DENT":[],
        "LINK":[],
        "KMD":[],
        "LOOM":[],
        "STRAT":[],
        "SNT":[],
        "GVT":[],
        "ZEC":[],
        "MFT":[],
        "STORM":[],
        "WTC":[],
        "ENJ":[],
        "BQX":[],
        "ARDR":[],
        "ENG":[],
        "NULS":["NULSUSDT"],
        "NCASH":[],
        "GRS":[],
        "ZEN":[],
        "SC":[],
        "AION":[],
        "QTUM":[],
        "EDO":[],
        "CVC":[],
        "QSP":[],
        "SUB":[],
        "MTL":[],
        "BTG":[],
        "MANA":[],
        "NXS":[],
        "CDT":[],
        "BRD":[],
        "STEEM":[],
        "BLZ":[],
        "RCN":[],
        "POE":[],
        "BCPT":[],
        "OMG":[],
        "XEM":[],
        "POWR":[],
        "WINGS":[],
        "AGI":[],
        "SALT":[],
        "SKY":[],
        "GNT":[],
        "VIB":[],
        "TNB":[],
        "STORJ":[],
        "WRP":[],
        "MDA":[],
        "AE":[],
        "MCO":[],
        "PPT":[],
        "ARK":[],
        "GXS":[],
        "POA":[],
        "ELF":[],
        "WAVES":[],
        "THETA":[],
        "AST":[],
        "CMT":[],
        "RPX":[],
        "BCD":[],
        "DATA":[],
        "LSK":[],
        "BTS":[],
        "PIVX":[],
        "TRIG":[],
        "SYS":[],
        "AMB":[],
        "LEND":[],
        "DNT":[],
        "HSR":[],
        "APPC":[],
        "KNC":[],
        "CND":[],
        "CHAT":[],
        "GAS":[],
        "FUN":[],
        "REQ":[],
        "OAX":[],
        "NEBL":[],
        "OST":[],
        "QLC":[],
        "FUEL":[],
        "SNM":[],
        "NAV":[],
        "XZC":[],
        "ICN":[],
        "LRC":[],
        "YOYO":[],
        "DLT":[],
        "BCN":[],
        "WABI":[],
        "VIBE":[],
        "CLOAK":[],
        "RDN":[],
        "RLC":[],
        "WPR":[],
        "MOD":[],
        "DGD":[],
        "TNT":[],
        "EVX":[],
        "BNT":[],
        "SNGLS":[],
        "MTH":[],
        "VIA":[],
        "LUN":[]
    ]
}

enum Crypto: String {
    case ETH, BTC, EOS, XLM, IOST, BCC, TRX, BNB, ADA, XRP, QKC, NEO, LTC, ICX, ARN, ZRX, ZIL, KEY, NPXS, ONT, IOTA, ETC, TUSD, REP, NAS, ADX, BAT, XMR, HOT, DASH, XVG, GTO, IOTX, INS, VEN, WAN, DENT, LINK, KMD, LOOM, STRAT, SNT, GVT, ZEC, MFT, STORM, WTC, ENJ, BQX, ARDR, ENG, NULS, NCASH, GRS, ZEN, SC, AION, QTUM, EDO, CVC, QSP, SUB, MTL, BTG, MANA, NXS, CDT, BRD, STEEM, BLZ, RCN, POE, BCPT, OMG, XEM, POWR, WINGS, AGI, SALT, SKY, GNT, VIB, TNB, STORJ, WRP, MDA, AE, MCO, PPT, ARK, GXS, POA, ELF, WAVES, THETA, AST, CMT, RPX, BCD, DATA, LSK, BTS, PIVX, TRIG, SYS, AMB, LEND, DNT, HSR, APPC, KNC, CND, CHAT, GAS, FUN, REQ, OAX, NEBL, OST, QLC, FUEL, SNM, NAV, XZC, ICN, LRC, YOYO, DLT, BCN, WABI, VIBE, CLOAK, RDN, RLC, WPR, MOD, DGD, TNT, EVX, BNT, SNGLS, NANO, MTH, VIA, LUN
}

extension Crypto: CaseIterable {}

#if swift(>=4.2)
#else
    protocol CaseIterable {
        associatedtype AllCases: Collection where AllCases.Element == Self
        static var allCases: AllCases { get }
    }
    extension CaseIterable where Self: Hashable {
        static var allCases: [Self] {
            return [Self](AnySequence { () -> AnyIterator<Self> in
                var raw = 0
                var first: Self?
                return AnyIterator {
                    let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                    if raw == 0 {
                        first = current
                    } else if current == first {
                        return nil
                    }
                    raw += 1
                    return current
                }
            })
        }
    }
#endif

