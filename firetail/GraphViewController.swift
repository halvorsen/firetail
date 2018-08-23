//
//  ViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import ReachabilitySwift

var graphMutablePaths: [String:CGMutablePath] = [:]

final class GraphViewController: ViewSetup, UIGestureRecognizerDelegate {
    
    var enter = UIButton()
    var graphViewSeen = StockGraphView2()
    var stockName = String()
    var tap = UITapGestureRecognizer()
    var graphViews = [String:StockGraphView2?]()
    var stockHeader = UILabel()
    var currentPrice = UILabel()
    var backArrow = UIButton()
    var passedString = "Patriots"
    let trade = UIButton()
    var newTextKey = "3m"
    var currentTextKey = "1y"
    let layer = CAShapeLayer()
    var start = CGFloat()
    var switchable = true
    var first = true
    var orderOfGraphs = ["1y":0,"5y":1,"10y":2,"1d":3,"5d":4,"1m":5,"3m":6]
    let orderOfLabels = ["10y":0,"5y":1,"1y":2,"3m":3,"1m":4,"5d":5,"1d":6]
    var loading = UILabel()
    let brokersDictionary: [String:String] = [
        "Ameritrade":"https://invest.ameritrade.com/grid/p/site",
        "Etrade":"https://us.etrade.com/e/t/user/login",
        "Scottrade":"https://trading.scottrade.com/",
        "Schwab":"https://client.schwab.com/Login/SignOn/CustomerCenterLogin.aspx",
        "Merrill Edge":"https://olui2.fs.ml.com/login/login.aspx?sgt=3",
        "Trademonster":"https://www.trademonster.com/login.jsp",
        "Capital One Investing":"https://www.capitaloneinvesting.com/main/authentication/signin.aspx",
        "eOption":"http://www.eoption.com/client-login/",
        "Interactive Brokers":"https://gdcdyn.interactivebrokers.com/sso/Login",
        "Kapitall":"https://landing.kapitall.com/home/",
        "Lightspeed":"https://www.lightspeed.com/login/",
        "optionsXpress":"https://www.optionsxpress.com/login/login.aspx?r=1",
        "Zacks":"http://www.zackstrade.com/login/",
        "Trade King":"https://investor.tradeking.com/account-login",
        "Sogo Trade":"https://account.sogotrade.com/Account/Login.aspx",
        "Trading Block":"https://www.tradingblock.com/account/securitieslogin.aspx",
        "USAA":"https://www.usaa.com/inet/wc/investing-stocks-bonds-brokerage-main?akredirect=true",
        "Vangaurd":"https://investor.vanguard.com/my-account/log-on",
        "Wells Fargo":"https://connect.secure.wellsfargo.com/auth/login/present?origin=cob&LOB=CONS",
        "Robinhood":"https://www.robinhood.com/signup/login/",
        "Fidelity": "https://login.fidelity.com/ftgw/Fas/Fidelity/RtlCust/Login/Init",
        "TradeStation": "https://clientcenter.tradestation.com/",
        "Ally": "https://secure.ally.com/",
        "Bank of America": "https://www.bankofamerica.com/sitemap/hub/signin.go",
        "Firstrade": "https://invest.firstrade.com/cgi-bin/login",
        "Chase": "https://jpmorgan.chase.com/"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Label.changeValues.removeAll()
        Label.percentageValues.removeAll()
        self.view.backgroundColor = CustomColor.black33
        addLabelsAndButtons()
        addLabel(name: stockHeader, text: "", textColor: .white, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 18, x: 0, y: 0, width: 750, height: 136, lines: 1)
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                
                stockHeader.frame.origin.y += 15
                
            }
            
        }
        addLabel(name: currentPrice, text: "", textColor: .white, textAlignment: .left, fontName: "Roboto-Light", fontSize: 40, x: 60, y: 180, width: 400, height: 106, lines: 1)
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.back(_:)), addSubview: false)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
      
        
        let a = StockData2()
        graphViewSeen = StockGraphView2(stockData: a, key: "", cubic: false)
        graphMutablePaths["1y"] = AnimatedGraph.createGraphs(dataPoints: reduceDataPoints(original: a.closingPrice))
        graphViewSeen.xs[2].textColor = CustomColor.yellow
        view.addSubview(backArrow)
        showGraph()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickGraph(touches.first!)
    }
    
    func showGraph() {
        
        graphViews = ["1y":nil,"5y":nil,"10y":nil,"1d":nil,"5d":nil,"1m":nil,"3m":nil]
        
        self.view.endEditing(true)
        if passedString != "Patriots" {
            
            stockName = passedString
            stockHeader.text = passedString.uppercased()
            
            callCorrectGraph2FromCache(stockName: self.stockName) {(_ stockData: ([String],[StockData2?])) -> Void in
                DispatchQueue.main.async {
                    
                    if stockData.0.count == 7 {
                        
                        for i in 0..<stockData.0.count {
                            self.orderOfGraphs[stockData.0[i]] = i
                   
                        }
                        
                        self.implementDrawSubviews(stockData: stockData)}
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        reachabilityAddNotification()
        
    }
    
    @objc private func back(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func trade(_ sender: UIButton) {
        if UserInfo.brokerName != "none" {
            guard let name = brokersDictionary[UserInfo.brokerName],
                let url = URL(string: name) else { return }
            UIApplication.shared.open(url)
        } else {
            self.userWarning(title: "", message: "Add Broker in Firetail Settings")
            
        }
    }
    
    @objc private func pickGraph(_ touch: UITouch) {
        
        let layerAnimation = CABasicAnimation(keyPath: "path")
        layerAnimation.duration = 0.7
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layerAnimation.fillMode = kCAFillModeBoth
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.fromValue = graphMutablePaths[currentTextKey]
        let center = touch.location(in: graphViewSeen)
        for xLabel in (graphViewSeen.xs) {
            if xLabel.frame.contains(center) {
                newTextKey = xLabel.text!
                guard let currentOrder = orderOfLabels[currentTextKey],
                    let newOrder = orderOfLabels[newTextKey],
                    let newGraphs = orderOfGraphs[newTextKey],
                    let xText = xLabel.text,
                    graphViewSeen.xs.count > currentOrder,
                    graphViewSeen.xs.count > newOrder else {return}
                graphViewSeen.xs[currentOrder].textColor = CustomColor.labelGray
                newTextKey = xText
                graphViewSeen.xs[newOrder].textColor = CustomColor.yellow
                layerAnimation.toValue = graphMutablePaths[newTextKey]
                currentTextKey = newTextKey
                layer.add(layerAnimation, forKey: nil)
                graphViewSeen.change.text = Label.changeValues[newGraphs]
                if let symbol = Label.changeValues[newGraphs].first {
                    if symbol == "-" {
                        graphViewSeen.percentChange.textColor = CustomColor.red
                        graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                    } else {
                        graphViewSeen.percentChange.textColor = CustomColor.yellow
                        graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "upArrow")
                    }
                }
                graphViewSeen.percentChange.text = Label.percentageValues[newGraphs]
                guard let newY = yVals[newTextKey] else {return}
                for i in 0..<graphViewSeen.ys.count {
                    switch i {
                    case 0: graphViewSeen.ys[i].text = newY.4
                    case 1: graphViewSeen.ys[i].text = newY.3
                    case 2: graphViewSeen.ys[i].text = newY.2
                    case 3: graphViewSeen.ys[i].text = newY.1
                    case 4: graphViewSeen.ys[i].text = newY.0
                    default: break
                    }
                    
                }
                return
            }
        }
        
        if (center.y > 100*heightScalar && center.y < 550*widthScalar) {
            var xLabel = graphViewSeen.xs[0]
            
            switch currentTextKey {
            case "10y":
                xLabel = graphViewSeen.xs[1]
            case "5y":
                xLabel = graphViewSeen.xs[2]
            case "1y":
                xLabel = graphViewSeen.xs[3]
            case "3m":
                xLabel = graphViewSeen.xs[4]
            case "1m":
                xLabel = graphViewSeen.xs[5]
            case "5d":
                xLabel = graphViewSeen.xs[0]
            default:
                break
            }
            newTextKey = xLabel.text!
            guard let currentOrder = orderOfLabels[currentTextKey],
                let newOrder = orderOfLabels[newTextKey],
                let newGraphs = orderOfGraphs[newTextKey],
                graphViewSeen.xs.count > currentOrder,
                graphViewSeen.xs.count > newOrder else {return}
            
            graphViewSeen.xs[currentOrder].textColor = CustomColor.labelGray
            
            graphViewSeen.xs[newOrder].textColor = CustomColor.yellow
            layerAnimation.toValue = graphMutablePaths[newTextKey]
            currentTextKey = newTextKey
            layer.add(layerAnimation, forKey: nil)
            graphViewSeen.change.text = Label.changeValues[newGraphs]
            if let symbol = Label.changeValues[newGraphs].first {
                if symbol == "-" {
                    graphViewSeen.percentChange.textColor = CustomColor.red
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                } else {
                    graphViewSeen.percentChange.textColor = CustomColor.yellow
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "upArrow")
                }
            }
            graphViewSeen.percentChange.text = Label.percentageValues[newGraphs]
            guard let newY = yVals[newTextKey] else {return}
            
            for i in 0..<graphViewSeen.ys.count {
                switch i {
                case 0: graphViewSeen.ys[i].text = newY.4
                case 1: graphViewSeen.ys[i].text = newY.3
                case 2: graphViewSeen.ys[i].text = newY.2
                case 3: graphViewSeen.ys[i].text = newY.1
                case 4: graphViewSeen.ys[i].text = newY.0
                default: break
                }
                
            }
            
        }
        
    }
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: CustomColor.white, bgColor: CustomColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: false, alignment: .center)
        
    }
   
    var yVals = [String:(l1:String,l2:String,l3:String,l4:String,l5:String)]()
    
    func implementDrawSubviews(stockData: ([String],[StockData2?])) {
        for i in 0..<7 {
            guard let data1 = stockData.1[i],
                let closeMax = data1.closingPrice.max(),
                let closeMin = data1.closingPrice.min() else {return}
            
            let graphView = StockGraphView2(stockData: data1, key: stockData.0[i], cubic: true)
            graphMutablePaths[stockData.0[i]] = AnimatedGraph.createGraphs(dataPoints: reduceDataPoints(original:  data1.closingPrice))
            let ma = closeMax //from unfiltered highs and lows
            let mi = closeMin //from unfiltered
            
            guard let ma2 = graphView._outputValues.max(), //from averages for middle of graph
                let mi2 = graphView._outputValues.min() else {return}// from averages for middle of graph
            
            let range = ma - mi
            
            switch range {
            case 0...0.06:
                self.yVals[stockData.0[i]] = (String(format: "%.2f", ma),"","","",String(format: "%.2f", mi))
            case 0.061...0.6:
                self.yVals[stockData.0[i]] = (String(format: "%.2f", ma), String(format: "%.2f", mi2 + 3*(ma2-mi2)/4), String(format: "%.2f", mi2 + 2*(ma2-mi2)/4),String(format: "%.2f", mi2 + (ma2-mi2)/4),String(format: "%.2f", mi))
            case 0.61...7:
                self.yVals[stockData.0[i]] = (String(format: "%.1f", ma)+"0", String(format: "%.1f", mi2 + 3*(ma2-mi2)/4)+"0", String(format: "%.1f", mi2 + 2*(ma2-mi2)/4)+"0",String(format: "%.1f", mi2 + (ma2-mi2)/4)+"0",String(format: "%.1f", mi)+"0")
            default:
                self.yVals[stockData.0[i]] = (String(Int(ma)), String(Int(mi2 + 3*(ma2-mi2)/4)), String(Int(mi2 + 2*(ma2-mi2)/4)),String(Int(mi2 + (ma2-mi2)/4)),String(Int(mi)))
            }
            
            self.graphViews[stockData.0[i]] = graphView
            
                
                self.currentPrice.text = String(format: "%.2f", data1.closingPrice.last!)
            
        }
        
        doneLoading()
    }
    
    private func doneLoading() {
       
        loading.removeFromSuperview()
        add1YGraph()
        
    }
 
    
    @objc func animateBase() {
        graphViewSeen.base.backgroundColor = CustomColor.yellow
        graphViewSeen.base.alpha = 1.0
        
        UIView.animate(withDuration: 0.6) {
            self.graphViewSeen.base.frame = CGRect(x: 0, y: 565*self.graphViewSeen.bounds.height/636, width: self.graphViewSeen.bounds.width, height: 70*self.graphViewSeen.bounds.height/636)}
    }
    
    
    private func add1YGraph() {
        
        if let _ = graphMutablePaths["1y"] {
            animateBase()
            view.addSubview(graphViewSeen)
            guard let oneOrder = orderOfGraphs["1y"] else {return}
            layer.path = graphMutablePaths["1y"]
            layer.fillColor = CustomColor.yellow.cgColor
            layer.shadowColor = CustomColor.black.cgColor
            layer.shadowOpacity = 1.0
            layer.shadowOffset = CGSize.zero
            layer.shadowRadius = 10
            layer.transform = CATransform3DMakeScale(1.0, 0.79, 1.0)
            graphViewSeen.layerView.frame = CGRect(x: 0, y: graphViewSeen.bounds.height, width: graphViewSeen.bounds.width, height: 1)
            graphViewSeen.layerView.clipsToBounds = true
            graphViewSeen.layerView.layer.addSublayer(layer)
            
            graphViewSeen.change.text = Label.changeValues[oneOrder]
            graphViewSeen.percentChange.text = Label.percentageValues[oneOrder]
            if let symbol = Label.changeValues[oneOrder].first {
                if symbol == "-" {
                    graphViewSeen.percentChange.textColor = CustomColor.red
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                } else {
                    graphViewSeen.percentChange.textColor = CustomColor.yellow
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "upArrow")
                }
            }
            
            trade.alpha = 0.0
            stockHeader.alpha = 0.0
            currentPrice.alpha = 0.0
            view.addSubview(currentPrice)
            view.addSubview(trade)
            view.addSubview(stockHeader)
            guard let yVal = yVals["1y"] else {return}
            for i in 0..<graphViewSeen.ys.count {
                switch i {
                case 0: graphViewSeen.ys[i].text = yVal.4
                case 1: graphViewSeen.ys[i].text = yVal.3
                case 2: graphViewSeen.ys[i].text = yVal.2
                case 3: graphViewSeen.ys[i].text = yVal.1
                case 4: graphViewSeen.ys[i].text = yVal.0
                default: break
                }
                
            }
            
            UIView.animate(withDuration: 0.6) {self.graphViewSeen.layerView.frame = CGRect(x: 0, y: self.graphViewSeen.bounds.width*0.136, width: AnimatedGraph.GraphView.graphSize.width, height: AnimatedGraph.GraphView.graphSize.height); self.trade.alpha = 1.0; self.stockHeader.alpha = 1.0; self.currentPrice.alpha = 1.0}
            
        } else {
            delay(bySeconds: 0.2) {self.add1YGraph()}
        }
    }
    
    
    var layerAnimation2 = CABasicAnimation(keyPath: "position.y")
    var layerAnimation3 = CABasicAnimation(keyPath: "position.y")
    
    func findKeyForValue(value: StockGraphView2, dictionary: [String:StockGraphView2?]) ->String? {
        for (key, array) in dictionary
        {
            if array != nil {
                if (array! == value)
                {
                    return key
                }
            }
        }
        
        return nil
    }
    
    var j = 0
    var keys = [String]()
    var stockDaysInYear: Int {
        return Binance.isCryptoTickerSupported(ticker: passedString) ? 365 : 252
    } 
    func callCorrectGraph2FromCache(stockName: String, result: @escaping (_ stockData: ([String],[StockData2?])) -> Void) {
        
        guard let tenYear = UserInfo.tenYearDictionary[stockName] else {dismiss(animated: true);return}
        var __stockData = tenYear
       
        let list = ["1y","5y","10y","1d","5d","1m","3m"]
        let amount = __stockData.count
        var stockDatas = [StockData2]()
        //stockDaysInYear days in the trading year
        for timeSpan in list {
            var stockData2 = StockData2()
            switch timeSpan {
            case "1y":
                if amount < stockDaysInYear {
                    for i in 0..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                } else {
                    for i in (amount - stockDaysInYear)..<amount {
                        
                        stockData2.closingPrice.append(__stockData[i])
                    }
                }
                stockDatas.append(stockData2)
            case "5y":
                if amount < stockDaysInYear*5 {
                    for i in 0..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                } else {
                    for i in (amount - stockDaysInYear*5)..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                }
                stockDatas.append(stockData2)
            case "10y":
                if amount < stockDaysInYear*10 + 20 {
                    for i in 0..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                } else {
                    for i in (amount - stockDaysInYear*10 + 20)..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                }
                stockDatas.append(stockData2)
            case "1d":
                for i in (amount - 55)..<amount {
                    stockData2.closingPrice.append(__stockData[i])
                }
                //                    for i in (amount - 5)..<amount {
                //                        stockData2.closingPrice.append(stockData[i])
                //                    }
                // stockData2.closingPrice.append(stockData[amount - 1])
                stockDatas.append(stockData2)
            case "5d":
                if amount < 5 {
                    for i in 0..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                } else {
                    for i in (amount - 5)..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                }
                stockDatas.append(stockData2)
            case "1m":
                if amount < stockDaysInYear/12 {
                    for i in 0..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                } else {
                    for i in (amount-stockDaysInYear/12)..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                }
                stockDatas.append(stockData2)
            case "3m":
                if amount < stockDaysInYear/4 {
                    for i in 0..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                } else {
                    for i in (amount-stockDaysInYear/4)..<amount {
                        stockData2.closingPrice.append(__stockData[i])
                    }
                }
                stockDatas.append(stockData2)
                result((list,stockDatas))
            default: break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    func reduceDataPoints(original: [Double]) -> [Double] {
        
        if original.count == 5 {
            return [original[0],original[0],original[0],
                    original[1],original[1],original[1],
                    original[2],original[2],original[2],
                    original[3],original[3],original[3],
                    original[4],original[4],original[4]
            ]
        }
        let originalAmount = original.count
        guard original.count > 0 else {return []}
        var _original = original
        
        let setAmount: Int = originalAmount/15
        var outputValues = [Double](repeating: 0, count: 15)
        
        while _original.count%15 != 0 {
            _original.remove(at: 0)
            
        }
        for i in 0..<_original.count {
            
            let j = Int(i/setAmount)
            
            if j != 14 {
                
                outputValues[j] += _original[i]
            }
        }
        outputValues[14] = Double(setAmount)*original.last!
        
        return outputValues.map { $0 / Double(setAmount) }
        
    }
    
}
