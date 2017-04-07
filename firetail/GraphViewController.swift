//
//  ViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//



import BigBoard
import UIKit
import Charts

public struct MyVariables {
    static var gingerBreadMan = CGMutablePath()
}

public var gingerBreadMan = CGMutablePath()

class GraphViewController: ViewSetup {
    // var myTimer = Timer()
    let customColor = CustomColor()
    var enter = UIButton()
    var graphViewSeen = StockGraphView2()
    var stockName = String()
    var tap = UITapGestureRecognizer()
    // var pan = UIPanGestureRecognizer()
    //  var graphViews = [String:StockGraphView?]()
    var graphViews = [String:StockGraphView2?]()
    
    var stockHeader = UILabel()
    var currentPrice = UILabel()
    var backArrow = UIButton()
    var passedString = "Patriots"
    let trade = UIButton()
    var newTextKey = String()
    var currentTextKey = "1y"
    let layer = CAShapeLayer()
    
    //var progressHUD = ProgressHUD(text: "")
    var start = CGFloat()
    var switchable = true
    var first = true
    let list = ["1y","5y","Max","1d","5d","1m","3m"]
    var orderOfGraphs = ["1y":0,"5y":1,"Max":2,"1d":3,"5d":4,"1m":5,"3m":6]
    var orderofGraphsInverse = [Int:String]()
    let orderOfLabels = ["Max":0,"5y":1,"1y":2,"3m":3,"1m":4,"5d":5,"1d":6]
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
        "Robinhood":"https://www.robinhood.com/signup/login/"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PodVariable.gingerBreadMan.removeAll()
        Label.changeValues.removeAll()
        Label.percentageValues.removeAll()
        self.view.backgroundColor = customColor.black33
        //        pan = UIPanGestureRecognizer(target: self, action: #selector(GraphViewController.respondToPan(_:)))
        //        view.addGestureRecognizer(pan)
        addLabelsAndButtons()
        tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.pickGraph(_:)))
        view.addGestureRecognizer(tap)
        addLabel(name: stockHeader, text: "", textColor: .white, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 18, x: 0, y: 0, width: 750, height: 136, lines: 1)
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
    var activityView = UIActivityIndicatorView()
    override func viewWillAppear(_ animated: Bool) {

        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        activityView.alpha = 0.0
        self.view.addSubview(activityView)
        UIView.animate(withDuration: 3.0) {
            self.activityView.alpha = 1.0
        }
        showGraph()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.graphViewSeen.alpha = 1.0; self.loading.alpha = 1.0}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainView: DashboardViewController = segue.destination as! DashboardViewController
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromGraphToMain", sender: self)
    }
    
    @objc private func trade(_ sender: UIButton) {
        if Set.brokerName != "none" {
        UIApplication.shared.openURL(URL(string: brokersDictionary[Set.brokerName]!)!)
        }
    }
    
    @objc private func pickGraph(_ tap: UITapGestureRecognizer) {
        
        var layerAnimation = CABasicAnimation(keyPath: "path")
        layerAnimation.duration = 0.7
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layerAnimation.fillMode = kCAFillModeBoth
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.fromValue = PodVariable.gingerBreadMan[orderOfGraphs[currentTextKey]!]
        
        var center = tap.location(in: view!)
        center.y -= 388*screenHeight/1334
        
        for xLabel in (graphViewSeen.xs) {
            if xLabel.frame.contains(center) {
                graphViewSeen.xs[orderOfLabels[currentTextKey]!].textColor = customColor.labelGray
                newTextKey = xLabel.text!
                graphViewSeen.xs[orderOfLabels[newTextKey]!].textColor = customColor.yellow
                layerAnimation.toValue = PodVariable.gingerBreadMan[orderOfGraphs[newTextKey]!]
                
                currentTextKey = newTextKey
                layer.add(layerAnimation, forKey: nil)
                graphViewSeen.change.text = Label.changeValues[orderOfGraphs[newTextKey]!]
                graphViewSeen.percentChange.text = Label.percentageValues[orderOfGraphs[newTextKey]!]
                if Label.percentageValuesIsPositive[orderOfGraphs[newTextKey]!] {
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "upArrow")
                } else {
                    graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
                }
                for i in 0..<graphViewSeen.ys.count {
                    switch i {
                    case 0: graphViewSeen.ys[i].text = yVals[newTextKey]!.4
                    case 1: graphViewSeen.ys[i].text = yVals[newTextKey]!.3
                    case 2: graphViewSeen.ys[i].text = yVals[newTextKey]!.2
                    case 3: graphViewSeen.ys[i].text = yVals[newTextKey]!.1
                    case 4: graphViewSeen.ys[i].text = yVals[newTextKey]!.0
                    default: break
                    }
                    
                }
            }
        }
    }
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: false, alignment: .center)
        
    }
    var i = 0
    var yVals = [String:(l1:String,l2:String,l3:String,l4:String,l5:String)]()
    
    func implementDrawSubviews(stockData: ([String],[StockData2?])) {
        let serialQueue = DispatchQueue(label: "queuename", qos: DispatchQoS.userInitiated)
        
        if stockData.1[self.i] != nil {
            
            let graphView = StockGraphView2(stockData: stockData.1[self.i]!, key: stockData.0[self.i], cubic: true)
            
            let ma = stockData.1[self.i]!.closingPrice.max()! //from unfiltered highs and lows
            let mi = stockData.1[self.i]!.closingPrice.min()! //from unfiltered
            let ma2 = graphView._outputValues.max()! //from averages for middle of graph
            let mi2 = graphView._outputValues.min()!// from averages for middle of graph
            
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
            
            graphView.isUserInteractionEnabled = false
            
            graphView.frame.origin.x = self.screenWidth
            
            self.view.addSubview(graphView)
            
            self.graphViews[stockData.0[self.i]] = graphView
            
            if stockData.0[self.i] == "1d" {
                
                self.currentPrice.text = String(format: "%.2f", stockData.1[self.i]!.closingPrice.last!)
            } else if stockData.0[self.i] == "3m" {
                
                delay(bySeconds: 1.0) {
                    self.checkDoneSquashing()} //bypasses animation
                // self.myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GraphViewController.checkDoneSquashing), userInfo: nil, repeats: true)
            }
            
            if self.i < 6 {
                self.i += 1
                delay(bySeconds: 0.3){
                    
                    self.implementDrawSubviews(stockData: stockData)
                    
                }
            }
        }
    }
    
    func showGraph() {
        
        graphViews = ["1y":nil,"5y":nil,"Max":nil,"1d":nil,"5d":nil,"1m":nil,"3m":nil]
        
        self.view.endEditing(true)
        if passedString != "Patriots" {
            
            stockName = passedString
            stockHeader.text = passedString.uppercased()
            
            
            
            callCorrectGraph2(stockName: self.stockName) {(_ stockData: ([String],[StockData2?])) -> Void in
                
                if stockData.0.count == 7 {
                    
                    for i in 0..<stockData.0.count {
                        self.orderOfGraphs[stockData.0[i]] = i
                        self.orderofGraphsInverse[i] = stockData.0[i]
                    }
                    
                    self.implementDrawSubviews(stockData: stockData)}
                
            }
        }
    }
    
    func checkDoneSquashing() {
        // if graphViewSeen.doneSquashing {
        loading.removeFromSuperview()
        add1YGraph()
 
        activityView.removeFromSuperview()
     
        backArrow.alpha = 0.0
        view.addSubview(backArrow) //this is because the way the graphs load app can crash if push back button before they load
        UIView.animate(withDuration: 0.3) {
            self.backArrow.alpha = 1.0
        }
        for (_,graph) in self.graphViews {
            if graph != nil && (graph?.isDescendant(of: self.view))! {
                graph!.removeFromSuperview()
            }
        }
        // }
    }
    
    func animateBase() {
        graphViewSeen.base.backgroundColor = customColor.yellow
        graphViewSeen.base.alpha = 1.0
        
        UIView.animate(withDuration: 0.6) {
            self.graphViewSeen.base.frame = CGRect(x: 0, y: 565*self.graphViewSeen.bounds.height/636, width: self.graphViewSeen.bounds.width, height: 70*self.graphViewSeen.bounds.height/636)}
    }
    
    
    private func add1YGraph() {
        
        if PodVariable.gingerBreadMan.count > 0 {
            animateBase()
            view.addSubview(graphViewSeen)
            
            layer.path = PodVariable.gingerBreadMan[orderOfGraphs["1y"]!]
            layer.fillColor = customColor.yellow.cgColor
            layer.shadowColor = customColor.black.cgColor
            layer.shadowOpacity = 1.0
            layer.shadowOffset = CGSize.zero
            layer.shadowRadius = 10
            layer.transform = CATransform3DMakeScale(1.0, 0.79, 1.0)
            graphViewSeen.layerView.frame = CGRect(x: 0, y: graphViewSeen.bounds.height, width: graphViewSeen.bounds.width, height: 1)
            graphViewSeen.layerView.clipsToBounds = true
            
            graphViewSeen.layerView.layer.addSublayer(layer)
            
            graphViewSeen.change.text = Label.changeValues[orderOfGraphs["1y"]!]
            graphViewSeen.percentChange.text = Label.percentageValues[orderOfGraphs["1y"]!]
            if Label.percentageValuesIsPositive[orderOfGraphs["1y"]!] {
                graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "upArrow")
            } else {
                graphViewSeen.upDownArrowView.image = #imageLiteral(resourceName: "downArrow")
            }
            trade.alpha = 0.0
            stockHeader.alpha = 0.0
            currentPrice.alpha = 0.0
            view.addSubview(currentPrice)
            view.addSubview(trade)
            view.addSubview(stockHeader)
            
            for i in 0..<graphViewSeen.ys.count {
                switch i {
                case 0: graphViewSeen.ys[i].text = yVals["1y"]!.4
                case 1: graphViewSeen.ys[i].text = yVals["1y"]!.3
                case 2: graphViewSeen.ys[i].text = yVals["1y"]!.2
                case 3: graphViewSeen.ys[i].text = yVals["1y"]!.1
                case 4: graphViewSeen.ys[i].text = yVals["1y"]!.0
                default: break
                }
                
            }
            
            UIView.animate(withDuration: 0.6) {self.graphViewSeen.layerView.frame = CGRect(x: 0, y: self.graphViewSeen.bounds.height/10, width: self.graphViewSeen.bounds.width, height: 5*self.graphViewSeen.bounds.height/6); self.trade.alpha = 1.0; self.stockHeader.alpha = 1.0; self.currentPrice.alpha = 1.0}
            
        } else {
            delay(bySeconds: 0.2) {self.add1YGraph()}
        }
    }
    
    
    var layerAnimation2 = CABasicAnimation(keyPath: "position.y")
    var layerAnimation3 = CABasicAnimation(keyPath: "position.y")
    
    func findKeyForValue(value: StockGraphView2, dictionary: [String:StockGraphView2?]) ->String?
    {
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
    // let serialQueue = DispatchQueue(label: "queuename")
    var keys = [String]()
    func callCorrectGraph2(stockName: String, result: @escaping (_ stockData: ([String],[StockData2?])) -> Void) {
        
        BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
            
            let list = ["1y","5y","Max","1d","5d","1m","3m"]
            
            let charts = ["1y":stock.mapOneYearChartDataModule,"5y":stock.mapFiveYearChartDataModule,"Max":stock.mapLifetimeChartDataModule,"1d":stock.mapOneDayChartDataModule,"5d":stock.mapFiveDayChartDataModule,"1m":stock.mapOneMonthChartDataModule,"3m":stock.mapThreeMonthChartDataModule]
            
            var stockDatas = [StockData2]()
            
            for key in list {
                
                var stockData = StockData2()
                stockData.text = key
                
                charts[key]!({
                    let chartsModule = ["1y":stock.oneYearChartModule,"5y":stock.fiveYearChartModule,"Max":stock.lifetimeChartModule,"1d":stock.oneDayChartModule,"5d":stock.fiveDayChartModule,"1m":stock.oneMonthChartModule,"3m":stock.threeMonthChartModule]
                    let asdf: BigBoardChartDataModule? = chartsModule[key]!
                    
                    if asdf != nil {
                        
                        
                        for point in (asdf?.dataPoints)! {
                            
                            stockData.dates.append(point.date)
                            stockData.closingPrice.append(point.close)
                            
                        }
                        
                        print("EEEEK")
                        print(key)
                        //                                        print(stockData.closingPrice)
                        //                                        print(stockData.dates)
                        //                                        print("LAST")
                        //                                        print(stockData.closingPrice.last!)
                        if key == "1m" {
                            // let z = stockData.1[self.i]!.closingPrice.count - 1
                            Set.yesterday = stockData.closingPrice.last!
                        }
                        
                        if key == "1d" {
                            Set.currentPrice = stockData.closingPrice.last!
                        }
                        
                        stockDatas.append(stockData)
                    }
                    //      self.delay(bySeconds: 0.3) {
                    
                    self.keys.append(key)
                    result((self.keys,stockDatas))
                    //       }
                    
                    // oneMonthChartModule is now mapped to the stock
                }, { (error) in
                    self.userWarning(title: "", message: error.description)
                    print(error)
                    result(([""],[nil]))
                })
            }
        }) { (error) in
            self.userWarning(title: "", message: error.description)
            print(error)
            result(([""],[nil]))
        }
    }
}


