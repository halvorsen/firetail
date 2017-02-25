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

class GraphViewController: ViewSetup, UITextFieldDelegate {
    let customColor = CustomColor()
    var enter = UIButton()
    var sampleTextField = UITextField()
    var stockName = String()
    var stockLabel = UILabel()
    //    var barView = BarChartView()
    
    
    // let graphHeight: CGFloat = 388*UIScreen.main.bounds.height/1334
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor.background
       // addButton(name: enter, x: 0, y: 200, width: 750, height: 120, title: "Breakpoint", font: "HelveticaNeue-Bold", fontSize: 40, titleColor: .white, bgColor: customColor.yellow, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.enter(_:)), addSubview: true)
       // addLabel(name: stockLabel, text: "", textColor: customColor.yellow, textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 40, x: 0, y: 388, width: 300, height: 120, lines: 0)
        stockLabel.layer.zPosition = 1
        view.addSubview(stockLabel)
        
        sampleTextField = UITextField(frame: CGRect(x: 0,y: 0,width: screenWidth ,height: 100*screenHeight/1334))
        sampleTextField.placeholder = "Enter Stock Ticker"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sampleTextField.delegate = self
        sampleTextField.backgroundColor = customColor.background
        self.view.addSubview(sampleTextField)
        addLabelsAndButtons()
        // graphView.frame = CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334)
        // barView.frame = CGRect(x: 0, y: 500*screenHeight/1334, width: screenWidth, height: screenWidth)
        
    }
    @objc private func trade(_ sender: UIButton) {
        if trade.title(for: .normal) == "TRADE" {
        trade.setTitle("Not Connected", for: .normal)
        } else {
            trade.setTitle("TRADE", for: .normal)
        }
    }
    let trade = UIButton()
    
    
    
    
    private func addLabelsAndButtons() {
        
        addButton(name: trade, x: 0, y: 1194, width: 750, height: 1334-1194, title: "TRADE", font: "HelveticaNeue-Bold", fontSize: 18, titleColor: customColor.white, bgColor: customColor.black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.trade(_:)), addSubview: true)
        

        
        
    }
    
    func enter(_ sender: UIButton) {
        
        if sampleTextField.text != nil && sampleTextField.delegate != nil {
            
            stockName = sampleTextField.text!
            stockLabel.text = stockName
            
        }
    }
    
    var graphViews = [Any]()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        self.view.endEditing(true)
        if sampleTextField.text != nil {
            if graphViews.count > 0 {
                clearDataFromOldGraph()}
            stockName = sampleTextField.text!
            stockLabel.text = stockName
            print("entered0")
            
            
            callCorrectGraph(stockName: stockName, chart: "1d") {(_ stockData: StockData?) -> Void in
                if let data = stockData {
                let graphView = StockGraphView(stockData: data)
                self.view.addSubview(graphView)
                self.graphViews.append(graphView)
                }
            }
            
        }
        return false
    }
    
    func clearDataFromOldGraph() {
        if graphViews.count > 0 {
        (graphViews[0] as! StockGraphView).removeFromSuperview()
        }
        graphViews.removeAll()
    }
   
    
    
    
}


