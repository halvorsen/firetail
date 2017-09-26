//
//  AddStockPriceViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import ReachabilitySwift

class AddStockPriceViewController: ViewSetup, UIScrollViewDelegate {
    var newAlertTicker = String()
    var newAlertTickerLabel = UILabel()
    var newAlertPrice = Double()
    let backArrow = UIButton()
    var graph = DailyGraphForAlertView()
    var container = UIScrollView()
    var customColor = CustomColor()
    var dial = UIScrollView()
    var displayValues = [Double]()
    var priceLabel = UILabel()
    var sett = UIButton()
    var alertPrice: Double = 0.00 {
        didSet{
            DispatchQueue.main.async {
                
                self.priceLabel.text = "$" + String(format: "%.2f", self.alertPrice) //getPickerData()
                let c = (self.priceLabel.text?.characters.map { String($0) })!
                let s = self.priceLabel.text!
                if c[c.count-2] == "." {
                    self.priceLabel.text = s + "0"
                }
                
                if self.alertPrice > 999.99 {
                    self.priceLabel.text = self.priceLabel.text!.chopPrefix(1)
                }
            }
        }
    }
    let stockSymbol = UILabel()
    var activityView = UIActivityIndicatorView()
    var lastPrice = Double()
    let setPriceAlert = UILabel()
    let arrow = UIImageView()
    var priceString = String()
    
    private func loadItAll() {
        
        let blockInBackground = UIView()
        blockInBackground.frame = CGRect(x: 0, y: 424*screenHeight/667, width: screenWidth, height: 70*screenHeight/667)
        blockInBackground.backgroundColor = customColor.black24
        
        
        arrow.frame = CGRect(x: 212*screenWidth/375, y: 456*screenHeight/667, width: 10*screenWidth/375, height: 11*screenWidth/375)
        
        
        addLabel(name: setPriceAlert, text: "Set Price Alert", textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Light", fontSize: 17, x: 56, y: 885, width: 300, height: 80, lines: 1)
        
        
        
        
        addLabel(name: newAlertTickerLabel, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "DroidSerif", fontSize: 20, x: 60, y: 606, width: 200, height: 56, lines: 1)
        
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 56, y: 657, width: 240, height: 80, lines: 1)
        
        
        container = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260*screenHeight/667))
        container.contentSize = CGSize(width: 3.8*screenWidth, height: container.bounds.height)
        container.backgroundColor = customColor.black33
        container.contentOffset =  CGPoint(x: 2.7*screenWidth, y: 0)
        container.clipsToBounds = false
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        
        
        priceLabel.frame = CGRect(x: 0, y: 450*screenHeight/667, width: 205*screenWidth/375, height: 25*screenHeight/667)
        priceLabel.font = UIFont(name: "Roboto-Bold", size: 17*fontSizeMultiplier)
        priceLabel.textAlignment = .right
        priceLabel.textColor = .white
       // priceLabel.text = ""
        
        
        dial.backgroundColor = customColor.black42
        dial.frame = CGRect(x: 0, y: 494*screenHeight/667, width: screenWidth, height: 103*screenWidth/375)
        dial.contentSize = CGSize(width: 400.182*screenWidth, height: dial.bounds.height)
        
        dial.contentOffset.x = screenWidth*4.285
        dial.showsHorizontalScrollIndicator = false
        dial.showsVerticalScrollIndicator = false
        dial.delegate = self
        let bottomOfDial = dial.frame.maxY*1334/screenHeight //or 1194
        self.view.addSubview(blockInBackground)
        self.view.addSubview(self.arrow)
        self.view.addSubview(self.setPriceAlert)
        self.view.addSubview(self.newAlertTickerLabel)
     
        self.view.addSubview(self.stockSymbol)
        self.view.addSubview(self.container)
        self.view.addSubview(self.priceLabel)
        self.dial.contentOffset.x = offset
        view.addSubview(dial)
        
        
        
        
        
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 167*screenWidth/375, y: 489*screenHeight/667))
        myBezier.addLine(to: CGPoint(x: 207*screenWidth/375, y: 489*screenHeight/667))
        myBezier.addLine(to: CGPoint(x: 187*screenWidth/375, y: 509*screenHeight/667))
        myBezier.close()
        let myLayer = CAShapeLayer()
        myLayer.path = myBezier.cgPath
        myLayer.fillColor = customColor.black24.cgColor
        
        self.addButton(name: self.sett, x: 0, y: bottomOfDial, width: 750, height: 1334 - bottomOfDial, title: "SET", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.setFunc(_:)), addSubview: true)
        self.sett.contentHorizontalAlignment = .center
        self.view.layer.addSublayer(myLayer)
        self.addButton(name: self.backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.back(_:)), addSubview: true)
        
        
        
        self.backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        
        self.populateDialView()
        
        
    }
    var rectsLabelsTop = [CGFloat]()
    var rectsLabelsBottom = [CGFloat]()
    var rectsLabelsTopBig = [CGFloat]()
    var rectsLabelsBottomBig = [CGFloat]()
    var rectsLabelsPrice = [CGFloat]()
    var dialPrice = Double()
    var offset = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customColor.black33
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center.y = view.center.y
        activityView.center.x = view.center.x
        activityView.startAnimating()
        activityView.alpha = 1.0
        view.addSubview(activityView)
        
        prepareGraph() {(dateArray,closings) -> Void in
            if closings != nil && dateArray != nil {
                DispatchQueue.main.async {
                    self.loadItAll()
                }
                
                DispatchQueue.main.async {
                    self.graph = DailyGraphForAlertView(graphData: closings!, dateArray: dateArray!)
                    
                    self.container.addSubview(self.graph)
                }
                self.populateDisplayValues(currentPrice: closings!.last!)
                self.dialPrice = closings!.last!
                
                
                let a:CGFloat = -0.72
                let c:CGFloat = 1000
                self.offset = (CGFloat(closings!.last!) - a)*self.screenWidth*75053.5/(375*(c-a))
                
                
                // self.dial.contentOffset.x = CGFloat(closings!.last!)*(7501.5)*self.screenWidth/(37500) + 38.5
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: 0, y: -100)
                t = t.scaledBy(x: 1.0, y: 0.01)
                
                DispatchQueue.main.async {
                    self.graph.transform = t
                    self.activityView.removeFromSuperview()
              
                    UIView.animate(withDuration: 1.0) {
                        
                        self.graph.transform = CGAffineTransform.identity
                        self.graph.frame.origin.y = 50*self.screenHeight/667
                }
                
                
                self.delay(bySeconds: 0.6) {
                    
                    for i in 0..<self.graph.labels.count {
                        self.delay(bySeconds: 0.15) {
                            UIView.animate(withDuration: 0.15*Double(i)) {
                                
                                    self.graph.grids[self.graph.labels.count - i - 1].alpha = 1.0
                                    self.graph.labels[self.graph.labels.count - i - 1].alpha = 1.0
                                    self.graph.dayLabels[self.graph.labels.count - i - 1].alpha = 1.0
                                
                            }
                        }
                    }
                }
                }
                
                
                
                self.alertPrice = closings!.last!
                self.lastPrice = closings!.last!
            }
        }
        
    }
    
    
    func populateDisplayValues(currentPrice: Double) {
        if displayValues.count > 0 {
            displayValues.removeAll()
        }
        if currentPrice > 32.0 && currentPrice < 160.0 {
            for i in -3..<357 {
                displayValues.append(currentPrice - 32.0 + Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        } else if currentPrice >= 160.00 && currentPrice < 320.0 {
            for i in 0..<360 {
                displayValues.append(currentPrice - 160.0 + 5*Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        } else if currentPrice >= 320.00 {
            for i in 0..<360 {
                displayValues.append(currentPrice - 320.0 + 10*Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        } else if currentPrice > 0.00 && currentPrice <= 32.0 {
            for i in -3..<357 {
                displayValues.append(Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        }
    }
    
    func populateDialView() {
        
        let backdrop = UIView()
        backdrop.backgroundColor = customColor.black42
        backdrop.frame.size = dial.contentSize
        backdrop.frame.origin = CGPoint(x: 0, y: 0)
        for i in 0...50 {
            let dialImage = UIImageView()
            dialImage.frame.origin = CGPoint(x: CGFloat(i)*3000*screenWidth/375, y: 0)
            dialImage.frame.size = CGSize(width: 3000*screenWidth/375, height: 103*screenWidth/375)
            dialImage.image = #imageLiteral(resourceName: "Dial")
            dialImage.contentMode = UIViewContentMode.scaleAspectFit
            self.dial.addSubview(dialImage)
            
        }
        
        let f = 14*fontSizeMultiplier
        var count = 0
        for xVal in Set2.priceRectX {
            
            let alertOption = UILabel()
            alertOption.frame = CGRect(x: xVal, y: 19*screenWidth/375, width: 100*screenWidth/375, height: 62*screenWidth/375)
            
            alertOption.text = String(count)
            
            count += 1
            alertOption.textAlignment = .center
            alertOption.textColor = .white
            alertOption.font = UIFont(name: "Roboto-Bold", size: f)
            self.dial.addSubview(alertOption)
            
        }
        
        let dialMask = UILabel()
        dialMask.frame = CGRect(x: 0, y: 514*screenWidth/375, width: screenWidth, height: 60*screenWidth/375)
        dialMask.backgroundColor = customColor.black42Alpha0
        
        self.view.addSubview(dialMask)
        
        addGradient(mask: dialMask, color1: customColor.black42, color2: customColor.black42Alpha0, start: CGPoint(x: -0.2, y: 0.0), end: CGPoint(x: 0.45, y: 0.0))
        addGradient(mask: dialMask, color1: customColor.black42Alpha0, color2: customColor.black42, start: CGPoint(x: 0.55, y: 0.0), end: CGPoint(x: 1.2, y: 0.0))
        
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockPriceToAddStockTicker", sender: self)
    }
    
    @objc private func setFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockPriceToAddStockAlert", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddStockPriceToAddStockAlert" {
            let destinationViewController: AddStockAlertViewController = segue.destination as! AddStockAlertViewController
            destinationViewController.newAlertTicker = newAlertTicker
            destinationViewController.newAlertPrice = newAlertPrice
            destinationViewController.lastPrice = lastPrice
            destinationViewController.priceString = priceLabel.text!
        }
    }
    
    // here i'm giving it two chances to fetch the data otherwise it returns to addstockticker controller view with no error displayed to user
    private func prepareGraph(result: @escaping (_ dateArray: [(String,Int)]?,_ closings: [Double]?) -> Void) {
     
        let alphaAPI = Alpha()
        alphaAPI.get20YearHistoricalData(ticker: self.newAlertTicker) { (dataSet) in
            if dataSet == nil {
            alphaAPI.get20YearHistoricalData(ticker: self.newAlertTicker) { (dataSet) in
                guard let dataSet = dataSet else {self.performSegue(withIdentifier: "fromAddStockPriceToAddStockTicker", sender: self);return}
                Set1.oneYearDictionary[dataSet.ticker] = dataSet.price
                var dates = [(String,Int)]()
                for i in 0..<dataSet.day.count {
                    dates.append((dataSet.month[i],dataSet.day[i]))
                }
                result(dates,dataSet.price)
            }
            } else {
             Set1.oneYearDictionary[dataSet!.ticker] = dataSet!.price
            var dates = [(String,Int)]()
            for i in 0..<dataSet!.day.count {
                dates.append((dataSet!.month[i],dataSet!.day[i]))
            }
            result(dates,dataSet!.price)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
 
//        alphaAPI.get20YearHistoricalData(ticker: newAlertTicker) { dataSet in
//            if let dataSet = dataSet {
//            Set1.oneYearDictionary[dataSet.ticker] = dataSet.price
//            }
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    var isFirst = true
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == dial {
            
            let offset = Float(scrollView.contentOffset.x)
            // little messy here but should be just a linear calculation, the labeling could be wrong too
            
            let a:Float = -0.72
            let c:Float = 1000
            let price = (offset*(c-a)/75053.5)*375/Float(screenWidth) + a
            dialPrice = Double(price)
            
            
            if price < 0.00 {
                priceLabel.text = "$0.00"
                priceString = "0.00"
            } else if price < 5.00 {
                priceLabel.text = "$" + String(format: "%.2f", price)
                priceString = String(format: "%.2f", price)
            } else if price > 2000.0 {
                priceLabel.text = "$2000"
                priceString = "2000"
            } else {
                priceLabel.text = "$" + String(format: "%.1f", price) + "0"
                priceString = String(format: "%.1f", price) + "0"
            }
            if price > 999.99 {
                
                priceLabel.text = priceLabel.text!.chopPrefix(1)
            }
            newAlertPrice = Double(priceString)!
            
        }
        if !isFirst {
            if lastPrice > dialPrice + 0.1 && arrow.image != #imageLiteral(resourceName: "downArrow") {
                arrow.image = #imageLiteral(resourceName: "downArrow")
            } else if lastPrice < dialPrice - 0.1 && arrow.image != #imageLiteral(resourceName: "upArrow") {
                arrow.image = #imageLiteral(resourceName: "upArrow")
            }
        } else {
            isFirst = false
        }
    }
    
    private func addGradient(mask: UILabel, color1: UIColor, color2: UIColor, start: CGPoint, end: CGPoint){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = mask.bounds.size
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.startPoint = start
        gradient.endPoint = end
        
        mask.layer.addSublayer(gradient)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    
    
}
