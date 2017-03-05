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
    
    var progressHUD = ProgressHUD(text: "Loading")
    var start = CGFloat()
    var switchable = true
    var first = true
    let list = ["1y","5y","Max","1d","5d","1m","3m"]
    let dict: [String:Int] = ["1y":0,"5y":1,"Max":2,"1d":3,"5d":4,"1m":5,"3m":6]
    let dict2: [String:Int] = ["Max":0,"5y":1,"1y":2,"3m":3,"1m":4,"5d":5,"1d":6]
    var createdList = [String]()
    
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        progressHUD = ProgressHUD(text: passedString.uppercased())
        self.view.addSubview(progressHUD)
        self.view.backgroundColor = UIColor.black
        showGraph()
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
        layerAnimation.fromValue = PodVariable.gingerBreadMan[dict[currentTextKey]!]
        
        var center = tap.location(in: view!)
        center.y -= 388*screenHeight/1334
        
        for xLabel in (graphViewSeen.xs) {
            if xLabel.frame.contains(center) {
                graphViewSeen.xs[dict2[currentTextKey]!].textColor = customColor.labelGray
                newTextKey = xLabel.text!
                graphViewSeen.xs[dict2[newTextKey]!].textColor = customColor.yellow
                layerAnimation.toValue = PodVariable.gingerBreadMan[dict[newTextKey]!]
                currentTextKey = newTextKey
                layer.add(layerAnimation, forKey: nil)
                graphViewSeen.change.text = Label.changeValues[dict[newTextKey]!]
                graphViewSeen.percentChange.text = Label.percentageValues[dict[newTextKey]!]
            }
        }
    }
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: true, alignment: .center)
        
    }
    
    func showGraph() {
        createdList.removeAll()
        graphViews = ["1y":nil,"5y":nil,"Max":nil,"1d":nil,"5d":nil,"1m":nil,"3m":nil]
        
        self.view.endEditing(true)
        if passedString != "Patriots" {
            
            stockName = passedString
            stockHeader.text = passedString.uppercased()
            view.addSubview(stockHeader)
            
            // get all the stock information for each of the 7 graphs//
            for i in 0..<graphViews.count {
                
                delay(bySeconds: Double(i)*0.2 + 0.2) {
                    callCorrectGraph2(stockName: self.stockName, chart: self.list[i]) {(_ stockData: StockData2?) -> Void in
                        self.createdList.append(self.list[i])
                        
                        if let data = stockData {
                            // generate the graph Views //
                            let graphView = StockGraphView2(stockData: data, key: self.list[i], cubic: true)
                            graphView.isUserInteractionEnabled = false
                            self.graphViews[self.list[i]] = graphView
                            graphView.frame.origin.x = self.screenWidth
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
                            } else if self.list[i] == "5y"{
                                self.add1YGraph()
//                                for path in PodVariable.gingerBreadMan {
//                                    gingerBreadMan.move(to: CGPoint(x: 0, y: 0))
//                                }
                            }
                            
                            
                            
                        }
                        self.progressHUD.removeFromSuperview()
                        
                    }
                }
            }
            let a = StockData2()
            graphViewSeen = StockGraphView2(stockData: a, key: "", cubic: false)
            
            graphViewSeen.xs[2].textColor = customColor.yellow
            
            
        }
        
    }
    private func add1YGraph() {
        //go into linechartrenderer.swift in chart framework to mess with CGPaths. Need to translate the path but i think i need to change it back to bezier to do so, not sure if I can do that then translate path by ..... let toOrigin = CGAffineTransformMakeTranslation(-center.x, -center.y) .....  path.applyTransform(toOrigin)
        if PodVariable.gingerBreadMan.count > 0 {
        view.addSubview(graphViewSeen)
        layer.path = PodVariable.gingerBreadMan[0]
        layer.fillColor = customColor.yellow.cgColor
        graphViewSeen.layer.addSublayer(layer)
        graphViewSeen.change.text = Label.changeValues[dict["1y"]!]
        graphViewSeen.percentChange.text = Label.percentageValues[dict["1y"]!]
        } else {
            delay(bySeconds: 0.1) {self.add1YGraph()}
        }
    }
    
    
    var layerAnimation2 = CABasicAnimation(keyPath: "position.y")
    var layerAnimation3 = CABasicAnimation(keyPath: "position.y")
//    func getShapes() {
//        var i = 0
//        
//        
//        for path in PodVariable.gingerBreadMan {
//            
//            layer.path = path
//            layer.fillColor = UIColor.red.cgColor
//            graphViews[createdList[i]]!!.layer.addSublayer(layer)
//            if createdList[i] == "1y" {
//                //                let layer2 = CAShapeLayer()
//                //                layer2.path = PodVariable.gingerBreadMan[4]
//                //                layer2.fillColor = UIColor.red.cgColor
//                delay(bySeconds: 1.5) {
//                    self.layerAnimation.duration = 0.7
//                    self.layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
//                    self.layerAnimation.fillMode = kCAFillModeBoth
//                    self.layerAnimation.isRemovedOnCompletion = false
//                    self.layerAnimation.fromValue = PodVariable.gingerBreadMan[0]
//                    self.layerAnimation.toValue = PodVariable.gingerBreadMan[4]
//                    self.layer.add(self.layerAnimation, forKey: nil)
//                    //                    self.delay(bySeconds: 0.3) {
//                    //                        self.layerAnimation2.duration = 0.2
//                    //                        self.layerAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//                    //                        self.layerAnimation2.fillMode = kCAFillModeBoth
//                    //                        self.layerAnimation2.isRemovedOnCompletion = false
//                    //                        self.layerAnimation2.byValue = -10
//                    //                        layer.add(self.layerAnimation2, forKey: nil)
//                    self.delay(bySeconds: 0.4) {
//                        self.layerAnimation3.duration = 0.5
//                        self.layerAnimation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
//                        self.layerAnimation3.fillMode = kCAFillModeBoth
//                        self.layerAnimation3.isRemovedOnCompletion = false
//                        self.layerAnimation3.byValue = 15
//                        self.layer.add(self.layerAnimation3, forKey: nil)
//                        self.delay(bySeconds: 0.4) {
//                            self.layerAnimation2.duration = 1.0
//                            self.layerAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
//                            self.layerAnimation2.fillMode = kCAFillModeBoth
//                            self.layerAnimation2.isRemovedOnCompletion = false
//                            self.layerAnimation2.byValue = -7
//                            self.layer.add(self.layerAnimation2, forKey: nil)
//                            self.delay(bySeconds: 0.8) {
//                                self.layerAnimation3.duration = 2.0
//                                self.layerAnimation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
//                                self.layerAnimation3.fillMode = kCAFillModeBoth
//                                self.layerAnimation3.isRemovedOnCompletion = false
//                                self.layerAnimation3.byValue = 2
//                                self.layer.add(self.layerAnimation3, forKey: nil)
//                            }
//                        }
//                        
//                        //                        }
//                    }
//                    
//                    
//                }
//            }
//            i += 1
//        }
//    }
    
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
    
    
}


