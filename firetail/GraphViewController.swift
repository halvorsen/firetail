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
    var myTimer = Timer()
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
    
    //var progressHUD = ProgressHUD(text: "Loading")
    var start = CGFloat()
    var switchable = true
    var first = true
    let list = ["1y","5y","Max","1d","5d","1m","3m"]
    var orderOfGraphs = ["1y":0,"5y":1,"Max":2,"1d":3,"5d":4,"1m":5,"3m":6]
    var orderOfLabels = ["Max":0,"5y":1,"1y":2,"3m":3,"1m":4,"5d":5,"1d":6]
    // var createdList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PodVariable.gingerBreadMan.removeAll()
        Label.changeValues.removeAll()
        Label.percentageValues.removeAll()
        self.view.backgroundColor = customColor.background
        //        pan = UIPanGestureRecognizer(target: self, action: #selector(GraphViewController.respondToPan(_:)))
        //        view.addGestureRecognizer(pan)
        addLabelsAndButtons()
        tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.pickGraph(_:)))
        view.addGestureRecognizer(tap)
        addLabel(name: stockHeader, text: "", textColor: .white, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 18, x: 0, y: 0, width: 750, height: 136, lines: 1)
        addLabel(name: currentPrice, text: "", textColor: .white, textAlignment: .left, fontName: "Roboto-Light", fontSize: 40, x: 60, y: 180, width: 400, height: 106, lines: 1)
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        
        let a = StockData2()
        graphViewSeen = StockGraphView2(stockData: a, key: "", cubic: false)
        
        graphViewSeen.xs[2].textColor = customColor.yellow
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(graphViewSeen)
        graphViewSeen.alpha = 0.0
        self.graphViewSeen.bounce()
        //  progressHUD = ProgressHUD(text: passedString.uppercased())
        //  progressHUD.layer.zPosition = 5
        
        //   self.view.addSubview(progressHUD)
        self.view.backgroundColor = UIColor.black
        showGraph()
        graphViewSeen.animateIt()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.graphViewSeen.alpha = 1.0}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainView: MainViewController = segue.destination as! MainViewController
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromGraphToMain", sender: self)
    }
    
    @objc private func trade(_ sender: UIButton) {
        if trade.title(for: .normal) == "TRADE" {
            trade.setTitle("Not Connected", for: .normal)
        } else {
            trade.setTitle("TRADE", for: .normal)
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
            }
        }
    }
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: false, alignment: .center)
        
    }
    
    func showGraph() {
        print("WOW")
        graphViews = ["1y":nil,"5y":nil,"Max":nil,"1d":nil,"5d":nil,"1m":nil,"3m":nil]
        
        self.view.endEditing(true)
        if passedString != "Patriots" {
            
            stockName = passedString
            stockHeader.text = passedString.uppercased()
            
            
            let serialQueue = DispatchQueue(label: "serialqueue")
            
            callCorrectGraph2(stockName: self.stockName) {(_ stockData: [StockData2?]) -> Void in
                PodVariable.gingerBreadMan.count
                var i = 0
                print("stockdata count: \(stockData.count)")
                if stockData.count == 7 { //temp fix, need to fix callcorrectgraph2 to only send once
                for data in stockData {
                    self.delay(bySeconds: 0.3){
                        if data != nil {
                            
                            let graphView = StockGraphView2(stockData: data!, key: self.list[i], cubic: true)
                            graphView.isUserInteractionEnabled = false
                            
                            graphView.frame.origin.x = self.screenWidth
                            
                            self.view.addSubview(graphView)
                        
                            
                          //  graphView.removeFromSuperview()
                            
                            self.graphViews[self.list[i]] = graphView
                            if self.list[i] == "1d"{
                                print("asdfasdfasdfsd")
                                self.currentPrice.text = String(format: "%.2f", data!.closingPrice.last!)
                            } else if self.list[i] == "3m"{
                                
                                self.graphViewSeen.countinueBouncing = false
                                self.myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GraphViewController.checkDoneSquashing), userInfo: nil, repeats: true)
                                
                            }
                            
                            i += 1
                        }
                    }
                    
                        }
                    
                }
                
            }
            
            
        }
        
    }
    func checkDoneSquashing() {
        if graphViewSeen.doneSquashing {
            add1YGraph()
            myTimer.invalidate()
        }
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
            
            layer.path = PodVariable.gingerBreadMan[0]
            layer.fillColor = customColor.yellow.cgColor
            layer.shadowColor = customColor.black.cgColor  //UIColor.black.cgColor
            layer.shadowOpacity = 1.0
            layer.shadowOffset = CGSize.zero
            layer.shadowRadius = 10
            layer.transform = CATransform3DMakeScale(1.0, 0.79, 1.0)
            graphViewSeen.layerView.frame = CGRect(x: 0, y: graphViewSeen.bounds.height, width: graphViewSeen.bounds.width, height: 1)
            //graphViewSeen.layerView.sizeToFit()
            graphViewSeen.layerView.clipsToBounds = true
            
            graphViewSeen.layerView.layer.addSublayer(layer)
            graphViewSeen.change.text = Label.changeValues[0]
            graphViewSeen.percentChange.text = Label.percentageValues[0]
            trade.alpha = 0.0
            stockHeader.alpha = 0.0
            currentPrice.alpha = 0.0
            view.addSubview(currentPrice)
            view.addSubview(trade)
            view.addSubview(stockHeader)
            
            
            UIView.animate(withDuration: 0.6) {self.graphViewSeen.layerView.frame = CGRect(x: 0, y: self.graphViewSeen.bounds.height/10, width: self.graphViewSeen.bounds.width, height: 5*self.graphViewSeen.bounds.height/6); self.trade.alpha = 1.0; self.stockHeader.alpha = 1.0; self.currentPrice.alpha = 1.0}
            
            
        } else {
            delay(bySeconds: 0.1) {self.add1YGraph()}
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
    
    
    
}


