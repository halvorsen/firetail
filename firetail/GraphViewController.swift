//
//  ViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import Charts
import ReachabilitySwift

public struct MyVariables {
    static var gingerBreadMan = CGMutablePath()
}

public var gingerBreadMan = CGMutablePath()

class GraphViewController: ViewSetup, UIGestureRecognizerDelegate {
    
    let customColor = CustomColor()
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
    let list = ["1y","5y","10y","1d","5d","1m","3m"]
    var orderOfGraphs = ["1y":0,"5y":1,"10y":2,"1d":3,"5d":4,"1m":5,"3m":6]
    var orderofGraphsInverse = [Int:String]()
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
       
        PodVariable.gingerBreadMan.removeAll()
        Label.changeValues.removeAll()
        Label.percentageValues.removeAll()
        self.view.backgroundColor = customColor.black33
        addLabelsAndButtons()
//        tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.pickGraph(_:)))
//        view.addGestureRecognizer(tap)
//        graphViewSeen.addGestureRecognizer(tap)
        addLabel(name: stockHeader, text: "", textColor: .white, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 18, x: 0, y: 0, width: 750, height: 136, lines: 1)
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                
                stockHeader.frame.origin.y += 15
                
            }
            
        }
        addLabel(name: currentPrice, text: "", textColor: .white, textAlignment: .left, fontName: "Roboto-Light", fontSize: 40, x: 60, y: 180, width: 400, height: 106, lines: 1)
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.back(_:)), addSubview: false)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        addLabel(name: loading, text: "", textColor: .white, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 20, x: 0, y: (1334-150), width: 750, height: 150, lines: 1)
        loading.layer.zPosition = 15
        loading.alpha = 0.0
        view.addSubview(loading)
        
        let a = StockData2()
        graphViewSeen = StockGraphView2(stockData: a, key: "", cubic: false)
        graphViewSeen.xs[2].textColor = customColor.yellow
    }
    @objc var activityView = UIActivityIndicatorView()
    override func viewWillAppear(_ animated: Bool) {
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        activityView.alpha = 0.0
        self.view.addSubview(activityView)
        UIView.animate(withDuration: 1.0) {
            self.activityView.alpha = 1.0
        }
        showGraph()
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickGraph(touches.first!)
    }
    
    @objc func showGraph() {
        
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
                            self.orderofGraphsInverse[i] = stockData.0[i]
                        }
                        
                        self.implementDrawSubviews(stockData: stockData)}
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
            reachabilityAddNotification()
        
        UIView.animate(withDuration: 0.5) {
            self.graphViewSeen.alpha = 1.0; self.loading.alpha = 1.0}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromGraphToMain", sender: self)
    }
    
    @objc private func trade(_ sender: UIButton) {
        if Set1.brokerName != "none" {
            guard let name = brokersDictionary[Set1.brokerName],
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
    
        guard let order = orderOfGraphs[currentTextKey],
            PodVariable.gingerBreadMan.count > order else {return}
        layerAnimation.fromValue = PodVariable.gingerBreadMan[order]
   
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
                graphViewSeen.xs[currentOrder].textColor = customColor.labelGray
                newTextKey = xText
                graphViewSeen.xs[newOrder].textColor = customColor.yellow
                layerAnimation.toValue = PodVariable.gingerBreadMan[newGraphs]

                currentTextKey = newTextKey
                layer.add(layerAnimation, forKey: nil)
                graphViewSeen.change.text = Label.changeValues[newGraphs]
                if let symbol = Label.changeValues[newGraphs].first {
                    if symbol == "-" {
                        graphViewSeen.percentChange.textColor = customColor.red
                        graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                    } else {
                        graphViewSeen.percentChange.textColor = customColor.yellow
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
        
            graphViewSeen.xs[currentOrder].textColor = customColor.labelGray

            graphViewSeen.xs[newOrder].textColor = customColor.yellow
            layerAnimation.toValue = PodVariable.gingerBreadMan[newGraphs]
            
            currentTextKey = newTextKey
            layer.add(layerAnimation, forKey: nil)
            graphViewSeen.change.text = Label.changeValues[newGraphs]
            if let symbol = Label.changeValues[newGraphs].first {
                if symbol == "-" {
                    graphViewSeen.percentChange.textColor = customColor.red
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                } else {
                    graphViewSeen.percentChange.textColor = customColor.yellow
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
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: false, alignment: .center)
        
    }
    @objc var i = 0
    var yVals = [String:(l1:String,l2:String,l3:String,l4:String,l5:String)]()
    
    func implementDrawSubviews(stockData: ([String],[StockData2?])) {
        guard let data1 = stockData.1[self.i],
            let closeMax = data1.closingPrice.max(),
            let closeMin = data1.closingPrice.min() else {return}
    
            let graphView = StockGraphView2(stockData: data1, key: stockData.0[self.i], cubic: true)
            
            let ma = closeMax //from unfiltered highs and lows
            let mi = closeMin //from unfiltered
            
            guard let ma2 = graphView._outputValues.max(), //from averages for middle of graph
                let mi2 = graphView._outputValues.min() else {return}// from averages for middle of graph
            
            //basically what this does to the yellow detailed graphs is gives the actual max and min values as the top and bottom y labels. the graph is all averages execpt for the current price, last point on graph, which is the current prices. As you can imagine this makes for a graph that isn't totally lined up with it's legends but gives you a good point at the end and top and bottom, then everything else is approximation curve through averaged prices
            
            let range = ma - mi
            
            switch range {
            case 0...0.06:
                self.yVals[stockData.0[self.i]] = (String(format: "%.2f", ma),"","","",String(format: "%.2f", mi))
            case 0.061...0.6:
                self.yVals[stockData.0[self.i]] = (String(format: "%.2f", ma), String(format: "%.2f", mi2 + 3*(ma2-mi2)/4), String(format: "%.2f", mi2 + 2*(ma2-mi2)/4),String(format: "%.2f", mi2 + (ma2-mi2)/4),String(format: "%.2f", mi))
            case 0.61...7:
                self.yVals[stockData.0[self.i]] = (String(format: "%.1f", ma)+"0", String(format: "%.1f", mi2 + 3*(ma2-mi2)/4)+"0", String(format: "%.1f", mi2 + 2*(ma2-mi2)/4)+"0",String(format: "%.1f", mi2 + (ma2-mi2)/4)+"0",String(format: "%.1f", mi)+"0")
            default:
                self.yVals[stockData.0[self.i]] = (String(Int(ma)), String(Int(mi2 + 3*(ma2-mi2)/4)), String(Int(mi2 + 2*(ma2-mi2)/4)),String(Int(mi2 + (ma2-mi2)/4)),String(Int(mi)))
            }
        
            graphView.frame.origin.x = self.screenWidth
            
            self.view.addSubview(graphView)
            
            self.graphViews[stockData.0[self.i]] = graphView
            
            if stockData.0[self.i] == "1d" {
                
                self.currentPrice.text = String(format: "%.2f", closeMax)
            } else if stockData.0[self.i] == "3m" {
                
                delay(bySeconds: 1.0) {
                    self.checkDoneSquashing()} //bypasses animation
            }
            
            if self.i < 6 {
                self.i += 1
                delay(bySeconds: 0.3){
                    
                    self.implementDrawSubviews(stockData: stockData)
                    
                }
            }
        
    }
    
   
    
    @objc func checkDoneSquashing() {
        guard PodVariable.gingerBreadMan.count == 7 else {
            self.performSegue(withIdentifier: "fromGraphToMain", sender: self)
            return
        } //sometimes, for some reason, not all the calayers load, and this can crash the app. probably better to try to reload the layers instead of kicking the user back to the dashboard. but for now... 7th layer is the former 1 day layer
        loading.removeFromSuperview()
        add1YGraph()
        
        activityView.removeFromSuperview()
        
        backArrow.alpha = 0.0
        view.addSubview(backArrow) //this is because the way the graphs load app can crash if push back button before they load
        UIView.animate(withDuration: 0.3) {
            self.backArrow.alpha = 1.0
        }
        for (_,_graph) in self.graphViews {
            guard let graph = _graph else {return}
            if graph.isDescendant(of: self.view) {
                graph.removeFromSuperview()
            }
        }
    }
    
    @objc func animateBase() {
        graphViewSeen.base.backgroundColor = customColor.yellow
        graphViewSeen.base.alpha = 1.0
        
        UIView.animate(withDuration: 0.6) {
            self.graphViewSeen.base.frame = CGRect(x: 0, y: 565*self.graphViewSeen.bounds.height/636, width: self.graphViewSeen.bounds.width, height: 70*self.graphViewSeen.bounds.height/636)}
    }
    
    
    private func add1YGraph() {
        
        if PodVariable.gingerBreadMan.count > 0 {
            animateBase()
            view.addSubview(graphViewSeen)
            guard let oneOrder = orderOfGraphs["1y"],
                PodVariable.gingerBreadMan.count > oneOrder else {return}
            layer.path = PodVariable.gingerBreadMan[oneOrder]
            layer.fillColor = customColor.yellow.cgColor
            layer.shadowColor = customColor.black.cgColor
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
                    graphViewSeen.percentChange.textColor = customColor.red
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                } else {
                    graphViewSeen.percentChange.textColor = customColor.yellow
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
            
            UIView.animate(withDuration: 0.6) {self.graphViewSeen.layerView.frame = CGRect(x: 0, y: self.graphViewSeen.bounds.height/10, width: self.graphViewSeen.bounds.width, height: 5*self.graphViewSeen.bounds.height/6); self.trade.alpha = 1.0; self.stockHeader.alpha = 1.0; self.currentPrice.alpha = 1.0}
            
        } else {
            delay(bySeconds: 0.2) {self.add1YGraph()}
        }
    }
    
    
    @objc var layerAnimation2 = CABasicAnimation(keyPath: "position.y")
    @objc var layerAnimation3 = CABasicAnimation(keyPath: "position.y")
    
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
    
    @objc var j = 0
    @objc var keys = [String]()
    func callCorrectGraph2(stockName: String, result: @escaping (_ stockData: ([String],[StockData2?])) -> Void) {
        let alphaAPI = Alpha()
        alphaAPI.get20YearHistoricalData(ticker: stockName.uppercased(), isOneYear: false) { dataSet in
          
            guard dataSet != nil else {
                self.performSegue(withIdentifier: "fromGraphToMain", sender: self)
                // had this error to "cancelled" once now just sending back to the Dashboard if an error occures. instead of showing an alert.
                return
            }
            guard let dataSet = dataSet else {return}
            //not seeing if dataSet has content in it, v1 had a guard to check that
            var __stockData = dataSet.price
            if dataSet.price[dataSet.price.count - 1] == dataSet.price[dataSet.price.count - 2] {
                __stockData.remove(at: dataSet.price.count - 1)
            }
            let list = ["1y","5y","10y","1d","5d","1m","3m"]
            let amount = __stockData.count
            var stockDatas = [StockData2]()
            //252 days in the trading year
            for timeSpan in list {
                var stockData2 = StockData2()
                switch timeSpan {
                case "1y":
                    if amount < 252 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount - 252)..<amount {
                            
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                case "5y":
                    if amount < 252*5 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount - 252*5)..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                case "10y":
                    if amount < 252*10 + 20 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount - 252*10 + 20)..<amount {
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
                    if amount < 252/12 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount-252/12)..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                case "3m":
                    if amount < 252/4 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount-252/4)..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                    result((list,stockDatas))
                default: break
                }
                
                
            }
            
            //FIXIT add error message
            //                }, { (error) in
            //                    self.userWarning(title: "", message: error.description)
            //                    print(error)
            //                    result(([""],[nil]))
            
        }
        
    }
    
    func callCorrectGraph2FromCache(stockName: String, result: @escaping (_ stockData: ([String],[StockData2?])) -> Void) {

            guard let tenYear = Set1.tenYearDictionary[stockName] else {self.performSegue(withIdentifier: "fromGraphToMain", sender: self);return}
            var __stockData = tenYear
       
            if tenYear[tenYear.count - 1] == tenYear[tenYear.count - 2] {
                __stockData.remove(at: tenYear.count - 1)
            }
            let list = ["1y","5y","10y","1d","5d","1m","3m"]
            let amount = __stockData.count
            var stockDatas = [StockData2]()
            //252 days in the trading year
            for timeSpan in list {
                var stockData2 = StockData2()
                switch timeSpan {
                case "1y":
                    if amount < 252 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount - 252)..<amount {
                            
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                case "5y":
                    if amount < 252*5 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount - 252*5)..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                case "10y":
                    if amount < 252*10 + 20 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount - 252*10 + 20)..<amount {
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
                    if amount < 252/12 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount-252/12)..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                case "3m":
                    if amount < 252/4 {
                        for i in 0..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    } else {
                        for i in (amount-252/4)..<amount {
                            stockData2.closingPrice.append(__stockData[i])
                        }
                    }
                    stockDatas.append(stockData2)
                    result((list,stockDatas))
                default: break
                }
                
                
            }
            
            //FIXIT add error message
            //                }, { (error) in
            //                    self.userWarning(title: "", message: error.description)
            //                    print(error)
            //                    result(([""],[nil]))
            
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}



