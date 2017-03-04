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
    let customColor = CustomColor()
    var enter = UIButton()
    
    var stockName = String()
    var tap = UITapGestureRecognizer()
    // var pan = UIPanGestureRecognizer()
    //  var graphViews = [String:StockGraphView?]()
    var graphViews = [String:StockGraphView2?]()
    //CubicChartView() //BarChartView()
    var stockHeader = UILabel()
    var currentPrice = UILabel()
    var backArrow = UIButton()
    var passedString = "Patriots"
    let trade = UIButton()
    var newTextKey = String()
    var currentTextKey = "1y"
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    var progressHUD = ProgressHUD(text: "Loading")
    override func viewWillAppear(_ animated: Bool) {
        progressHUD = ProgressHUD(text: passedString.uppercased())
        self.view.addSubview(progressHUD)
        self.view.backgroundColor = UIColor.black
        showGraph()
    }
    var start = CGFloat()
    var switchable = true
    //    @objc private func respondToPan(_ gesture: UIPanGestureRecognizer) {
    //
    //        if gesture.state == UIGestureRecognizerState.began {
    //            let p = gesture.location(in: view)
    //            start = p.x
    //        }
    //
    //        if gesture.state == UIGestureRecognizerState.changed {
    //            let q = gesture.location(in: view)
    //            if q.x < start && switchable {
    //                switchable = false
    //                rotateRight()
    //            }
    //            if q.x > start && switchable {
    //                switchable = false
    //                rotateLeft()
    //            }
    //
    //        }
    //        if gesture.state == UIGestureRecognizerState.ended {
    //            switchable = true
    //        }
    //
    //    }
    //    let duration: Double = 0.2
    //    private func rotateLeft() {
    //        switch currentTextKey {
    //        case "1y":
    //            graphViews["5y"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["5y"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "5y"
    //        case "5y":
    //            graphViews["Max"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["Max"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "Max"
    //        case "Max":
    //            graphViews["1d"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["1d"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "1d"
    //        case "1d":
    //            graphViews["5d"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["5d"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "5d"
    //        case "5d":
    //            graphViews["1m"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["1m"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "1m"
    //        case "1m":
    //            graphViews["3m"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["3m"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "3m"
    //        case "3m":
    //            graphViews["1y"]!!.frame.origin.x = -screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x += self.screenWidth; self.graphViews["1y"]!!.frame.origin.x += self.screenWidth}
    //            currentTextKey = "1y"
    //        default: break
    //        }
    //    }
    //
    //    private func rotateRight() {
    //        switch currentTextKey {
    //        case "1y":
    //            graphViews["3m"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["3m"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "3m"
    //        case "5y":
    //            graphViews["1y"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["1y"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "1y"
    //        case "Max":
    //            graphViews["5y"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["5y"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "5y"
    //        case "1d":
    //            graphViews["Max"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["Max"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "Max"
    //        case "5d":
    //            graphViews["1d"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["1d"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "1d"
    //        case "1m":
    //            graphViews["5d"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["5d"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "5d"
    //        case "3m":
    //            graphViews["1m"]!!.frame.origin.x = screenWidth
    //            UIView.animate(withDuration: duration) {self.graphViews[self.currentTextKey]!!.frame.origin.x -= self.screenWidth; self.graphViews["1m"]!!.frame.origin.x -= self.screenWidth}
    //            currentTextKey = "1m"
    //        default: break
    //        }
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let mainView: MainViewController = segue.destination as! MainViewController
        
        //mainView.tagLevelIdentifier = tagLevelIdentifier
        
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
        getShapes()
        var center = tap.location(in: view!)
        center.y -= 388*screenHeight/1334
        for (_,gView) in graphViews {
            if gView?.frame.origin.x == 0 {
                for xLabel in (gView?.xs)! {
                    if xLabel.frame.contains(center) {
                        
                        newTextKey = xLabel.text!
                        
                        graphViews[currentTextKey]!!.removeFromSuperview()
                        
                        if graphViews[newTextKey] != nil {
                            if graphViews[newTextKey]! != nil {
                                     view.addSubview(graphViews[newTextKey]!!)
                            }}
                        currentTextKey = newTextKey
                    }
                }
            }
        }
    }
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: true, alignment: .center)
        
    }
    
    
    
    //    func _showGraph() {
    //
    //
    //        self.view.endEditing(true)
    //        if passedString != "Patriots" {
    //
    //            stockName = passedString
    //            stockHeader.text = passedString.uppercased()
    //            view.addSubview(stockHeader)
    //
    //
    //                callCorrectGraph2(stockName: stockName) {(_ stockDataArray: [StockData2]?) -> Void in
    //
    //                    if let data = stockDataArray?[0] {
    //
    //                        let graphView = StockGraphView2(stockData: data)
    //                        graphView.isUserInteractionEnabled = false
    //                        self.view.addSubview(graphView)
    //
    //                       //add graphviews
    //                    }
    //                    self.progressHUD.removeFromSuperview()
    //
    //                }
    //
    //        }
    //
    //    }
    let list = ["1y","5y","Max","1d","5d","1m","3m"]
    let dict: [String:Int] = ["1y":0,"5y":1,"Max":2,"1d":3,"5d":4,"1m":5,"3m":6]
    var createdList = [String]()
    func showGraph() {
        graphViews = ["1y":nil,"5y":nil,"Max":nil,"1d":nil,"5d":nil,"1m":nil,"3m":nil]
        
        self.view.endEditing(true)
        if passedString != "Patriots" {
            
            stockName = passedString
            stockHeader.text = passedString.uppercased()
            view.addSubview(stockHeader)
          
            // get all the stock information for each of the 7 graphs//
            for i in 0..<graphViews.count {
                print("Uno")
                delay(bySeconds: Double(i)*0.2) {
                callCorrectGraph2(stockName: self.stockName, chart: self.list[i]) {(_ stockData: StockData2?) -> Void in
                 self.createdList.append(self.list[i])
                    
                    if let data = stockData {
                        // generate the graph Views //
                        let graphView = StockGraphView2(stockData: data, key: self.list[i])
                        graphView.isUserInteractionEnabled = false
                        self.graphViews[self.list[i]] = graphView
                        self.view.addSubview(graphView)
                        
                        print("Key \(self.findKeyForValue(value: graphView, dictionary: self.graphViews)!)")
                        if self.list[i] == "1y" {
                            self.view.addSubview(self.stockHeader)
                            self.view.addSubview(self.currentPrice)
                            
                            self.view.addSubview(self.currentPrice)
                        } else if self.list[i] == "1d"{
                            self.currentPrice.text = String(format: "%.2f", data.closingPrice.last!)
                            //                            graphView.frame.origin.x = self.screenWidth
//                                                        self.view.addSubview(graphView)
                        } else {
                            //                            graphView.frame.origin.x = self.screenWidth
//                                                        self.view.addSubview(graphView)
                        }
                 

                        
                    }
                    self.progressHUD.removeFromSuperview()
                    
                }
                }
            }
            
        }
        
    }
    var layerAnimation = CABasicAnimation(keyPath: "path")
    func getShapes() {
        var i = 0
        for path in PodVariable.gingerBreadMan {
            let layer = CAShapeLayer()
            layer.path = path
            layer.fillColor = UIColor.red.cgColor
            graphViews[createdList[i]]!!.layer.addSublayer(layer)
            
            
            if createdList[i] == "1y" {
                let layer2 = CAShapeLayer()
                layer2.path = PodVariable.gingerBreadMan[4]
                layer2.fillColor = UIColor.red.cgColor
                delay(bySeconds: 1.5) {
                    print("START!!!!!!!!!!")
                    
                    // Setup animation values that dont change
                    self.layerAnimation.duration = 1
                    // Sets the animation style. You can change these to see how it will affect the animations.
                    self.layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    self.layerAnimation.fillMode = kCAFillModeBoth
                    // Dont remove the shape when the animation has been completed
                    self.layerAnimation.isRemovedOnCompletion = false
                    
                    self.layerAnimation.fromValue = PodVariable.gingerBreadMan[0]
                    self.layerAnimation.toValue = PodVariable.gingerBreadMan[4]
                    layer.add(self.layerAnimation, forKey: "animatePath")
                }
            }
            i += 1
        }
    }
    
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
    
    //    func clearDataFromOldGraph() {
    //
    //            for (_, value) in graphViews {
    //                value?.removeFromSuperview()
    //            }
    //            // (graphViews[0]).removeFromSuperview()
    //        
    //    }
    
    
    
    
}


