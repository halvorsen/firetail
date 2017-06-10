//
//  AddStockPriceViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

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
    var set = UIButton()
    var alertPrice: Double = 0.00 {didSet{priceLabel.text = "$" + String(format: "%.2f", alertPrice) //getPickerData()
        let c = (priceLabel.text?.characters.map { String($0) })!
        let s = priceLabel.text!
        if c[c.count-2] == "." {
            priceLabel.text = s + "0"
        }
        
        }}
    let stockSymbol = UILabel()
    var activityView = UIActivityIndicatorView()
    var lastPrice = Double()
    let setPriceAlert = UILabel()
    let arrow = UIImageView()
    
    private func loadItAll() {
        let blockInBackground = UIView()
        blockInBackground.frame = CGRect(x: 0, y: 424*screenHeight/667, width: screenWidth, height: 70*screenHeight/667)
        blockInBackground.backgroundColor = customColor.black24
        view.addSubview(blockInBackground)
        arrow.frame = CGRect(x: 212*screenWidth/375, y: 456*screenHeight/667, width: 10*screenWidth/375, height: 11*screenWidth/375)
       
        view.addSubview(arrow)
        addLabel(name: setPriceAlert, text: "Set Price Alert", textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Light", fontSize: 17, x: 56, y: 885, width: 300, height: 80, lines: 1)
        view.addSubview(setPriceAlert)
        
        addButton(name: set, x: 0, y: 1194, width: 750, height: 140, title: "SET", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.setFunc(_:)), addSubview: true)
        set.contentHorizontalAlignment = .center
        
        
        
        addLabel(name: newAlertTickerLabel, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "DroidSerif-Regular", fontSize: 20, x: 60, y: 606, width: 200, height: 56, lines: 1)
        view.addSubview(newAlertTickerLabel)
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 56, y: 680, width: 240, height: 80, lines: 1)
        view.addSubview(stockSymbol)
        
        container = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260*screenHeight/667))
        container.contentSize = CGSize(width: 3.8*screenWidth, height: container.bounds.height)
        container.backgroundColor = customColor.black33
        container.contentOffset =  CGPoint(x: 2.7*screenWidth, y: 0)
        container.clipsToBounds = false
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        view.addSubview(container)
        
        priceLabel.frame = CGRect(x: 0, y: 450*screenHeight/667, width: 205*screenWidth/375, height: 25*screenHeight/667)
        priceLabel.font = UIFont(name: "Roboto-Bold", size: 17*fontSizeMultiplier)
        priceLabel.textAlignment = .right
        priceLabel.textColor = .white
        priceLabel.text = ""
        view.addSubview(priceLabel)
        
        dial.backgroundColor = customColor.black42
        dial.frame = CGRect(x: 0, y: 494*screenHeight/667, width: screenWidth, height: 103*screenHeight/667)
        dial.contentSize = CGSize(width: 400.182*screenWidth, height: dial.bounds.height)
        view.addSubview(dial)
        dial.contentOffset.x = screenWidth*4.285
        dial.showsHorizontalScrollIndicator = false
        dial.showsVerticalScrollIndicator = false
        dial.delegate = self
        
        
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 167*screenWidth/375, y: 489*screenHeight/667))
        myBezier.addLine(to: CGPoint(x: 207*screenWidth/375, y: 489*screenHeight/667))
        myBezier.addLine(to: CGPoint(x: 187*screenWidth/375, y: 509*screenHeight/667))
        myBezier.close()
        let myLayer = CAShapeLayer()
        myLayer.path = myBezier.cgPath
        myLayer.fillColor = customColor.black24.cgColor
        view.layer.addSublayer(myLayer)
        
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        populateDialView()
        
    }
    var rectsLabelsTop = [CGFloat]()
    var rectsLabelsBottom = [CGFloat]()
    var rectsLabelsTopBig = [CGFloat]()
    var rectsLabelsBottomBig = [CGFloat]()
    var rectsLabelsPrice = [CGFloat]()
    var dialPrice = Double()
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
                self.loadItAll()
                self.graph = DailyGraphForAlertView(graphData: closings!, dateArray: dateArray!)
                self.container.addSubview(self.graph)
                
                
                self.populateDisplayValues(currentPrice: closings!.last!)
                self.dialPrice = closings!.last!
                self.dial.contentOffset.x = CGFloat(closings!.last!)*(7501.5)*self.screenWidth/(37500) + 38.5
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: 0, y: -100)
                t = t.scaledBy(x: 1.0, y: 0.01)
                self.graph.transform = t
                
                self.activityView.removeFromSuperview()
                
                UIView.animate(withDuration: 2.0) {
                    
                    self.graph.transform = CGAffineTransform.identity
                    self.graph.frame.origin.y = 50*self.screenHeight/667
                }
                
                self.delay(bySeconds: 1.2) {
                    
                    for i in 0..<self.graph.labels.count {
                        self.delay(bySeconds: 0.3) {
                            UIView.animate(withDuration: 0.3*Double(i)) {
                                self.graph.grids[self.graph.labels.count - i - 1].alpha = 1.0
                                self.graph.labels[self.graph.labels.count - i - 1].alpha = 1.0
                                self.graph.dayLabels[self.graph.labels.count - i - 1].alpha = 1.0
                            }
                        }
                    }
                }
               
                self.delay(bySeconds: 20.0) {
                    print(self.rectsLabelsTop)
                    
                    print(self.rectsLabelsTopBig)
                    
                    print(self.rectsLabelsPrice)
                    
                    
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
        dialImage.frame.size = CGSize(width: 3000*screenWidth/375, height: 103*screenHeight/667)
        dialImage.image = #imageLiteral(resourceName: "Dial")
        dialImage.contentMode = UIViewContentMode.scaleAspectFit
        dial.addSubview(dialImage)
        }
       
        let f = 14*fontSizeMultiplier
        var count = 0
        for xVal in Set2.priceRectX {
            
            let alertOption = UILabel()
            alertOption.frame = CGRect(x: xVal, y: 19*screenWidth/375, width: 100, height: 62*screenHeight/667)
            
            alertOption.text = String(count)
            
            count += 1
            alertOption.textAlignment = .center
            alertOption.textColor = .white
            alertOption.font = UIFont(name: "Roboto-Bold", size: f)
            dial.addSubview(alertOption)
        }

        let dialMask = UILabel()
        dialMask.frame = CGRect(x: 0, y: 514*screenHeight/667, width: screenWidth, height: 60*screenHeight/667)
        dialMask.backgroundColor = customColor.black42Alpha0
        view.addSubview(dialMask)
        addGradient(mask: dialMask, color1: customColor.black42, color2: customColor.black42Alpha0, start: CGPoint(x: -0.2, y: 0.0), end: CGPoint(x: 0.45, y: 0.0))
        addGradient(mask: dialMask, color1: customColor.black42Alpha0, color2: customColor.black42, start: CGPoint(x: 0.55, y: 0.0), end: CGPoint(x: 1.2, y: 0.0))
        
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockPriceToDashboard", sender: self)
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
        }
    }
    
    
    private func prepareGraph(result: @escaping (_ dateArray: [(String,Int)]?,_ closings: [Double]?) -> Void) {
        print("entered addview google1")
        let myGoogle = Google()
        myGoogle.historicalPrices(years: 1, ticker: self.newAlertTicker) { (stockDataTuple) in
            let (_stockData,dates,_) = stockDataTuple
            guard let stockData = _stockData else {return}
            guard stockDataTuple.0!.count > 0 else {return}
            
            
            result(dates, stockData)
            //FIXIT add error handling simiar to BigBoard below, the error will be coming from url request to google
            // })
            //            self.isStock = false
            //            self.activityView.removeFromSuperview()
            //            if self.newAlertTicker != "TICKER" {
            //                var des = error.description
            //                for _ in 0...14 {
            //                    des.remove(at: des.startIndex)
            //                }
            //                let des2 = self.stockSymbolTextField.text! + " is not a real stock."
            //                if des == "The request timed out." || des == self.stockSymbolTextField.text! + " is not a real stock." {
            //                    self.userWarning(title: "", message: des)
            //                }
            //            }
            //            print(error)
            //            result(nil, nil)
        }
        
    }
    var isFirst = true
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        if scrollView == dial {
            
            let offset = Float(scrollView.contentOffset.x)
            // little messy here but should be just a linear calculation, the labeling could be wrong too
            
            let a:Float = -0.72
            let c:Float = 1000
            let price = offset*(c-a)/75053.5 + a
            dialPrice = Double(price)
            newAlertPrice = dialPrice
            if price < 0.00 {
                priceLabel.text = "$0.00"
             
            } else if price < 5.00 {
                priceLabel.text = "$" + String(format: "%.2f", price)
                
            } else if price > 2000.0 {
                priceLabel.text = "$2000"
           
            } else {
                priceLabel.text = "$" + String(format: "%.1f", price) + "0"
           
            }
            
            
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
    
}