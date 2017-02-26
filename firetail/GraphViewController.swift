//
//  ViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//



import BigBoard
import UIKit
//import Charts

class GraphViewController: ViewSetup {
    let customColor = CustomColor()
    var enter = UIButton()
    
    var stockName = String()
    var tap = UITapGestureRecognizer()
    var graphViews = [String:StockGraphView?]()
    var stockHeader = UILabel()
    var currentPrice = UILabel()
    var backArrow = UIButton()
    var passedString = "Patriots"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor.background
        
        addLabelsAndButtons()
        tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.pickGraph(_:)))
        view.addGestureRecognizer(tap)
        addLabel(name: stockHeader, text: "", textColor: .white, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 18, x: 0, y: 0, width: 750, height: 136, lines: 1)
        addLabel(name: currentPrice, text: "", textColor: .white, textAlignment: .left, fontName: "Roboto-Light", fontSize: 40, x: 60, y: 180, width: 400, height: 106, lines: 1)
        addButton(name: backArrow, x: 30, y: 40, width: 36, height: 34, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showGraph()
    }
    
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
    
    let trade = UIButton()
    var newTextKey = String()
    var currentTextKey = "1y"
    
    @objc private func pickGraph(_ tap: UITapGestureRecognizer) {
       
        var center = tap.location(in: view!)
        center.y -= 388*screenHeight/1334
        for (_,gView) in graphViews {
            if gView?.frame.origin.x == 0 {
                for xLabel in (gView?.xs)! {
                    if xLabel.frame.contains(center) {
                     
                        newTextKey = xLabel.text!
                        
                        graphViews[currentTextKey]??.removeFromSuperview()
             
                        if graphViews[newTextKey] != nil {
                            if graphViews[newTextKey]! != nil {
                                view.addSubview(graphViews[newTextKey]!!)}}
                        currentTextKey = newTextKey
                    }
                }
            }
        }
    }
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: true)
        
    }

    func showGraph() {
        graphViews = ["1y":nil,"5y":nil,"Max":nil,"1d":nil,"5d":nil,"1m":nil,"3m":nil]
       
        self.view.endEditing(true)
        if passedString != "Patriots" {
   
            stockName = passedString
            stockHeader.text = passedString.uppercased()
            view.addSubview(stockHeader)
            
            for (key, value) in graphViews {
                callCorrectGraph(stockName: stockName, chart: key) {(_ stockData: StockData?) -> Void in
                    
                    if let data = stockData {
                        
                        let graphView = StockGraphView(stockData: data)
                        graphView.isUserInteractionEnabled = false
                        self.graphViews[key] = graphView
                        
                        if key == "1y" {
                            self.view.addSubview(graphView)
                            self.view.addSubview(self.stockHeader)
                            self.view.addSubview(self.currentPrice)
                            self.currentPrice.text = String(data.closingPrice.last!)
                            self.view.addSubview(self.currentPrice)
                        } else {
                            // graphView.frame.origin.x = self.screenWidth
                            //self.view.addSubview(graphView)
                        }
                        
                    }
                    
                }
                
            }

        }
        
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


