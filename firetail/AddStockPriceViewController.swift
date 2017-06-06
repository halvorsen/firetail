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
        arrow.image = #imageLiteral(resourceName: "upArrow")
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
        dial.frame = CGRect(x: 0, y: 494*screenHeight/667, width: screenWidth, height: 100*screenHeight/667)
        dial.contentSize = CGSize(width: 416*screenWidth, height: dial.bounds.height)
        view.addSubview(dial)
        dial.contentOffset.x = screenWidth*4.285
        dial.showsHorizontalScrollIndicator = false
        dial.showsVerticalScrollIndicator = false
        dial.delegate = self
        
       
        
        var myBezier = UIBezierPath()
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
        
        
    }
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
                dialPrice = closings!.last!
                self.populateDialView()
                if closings!.last! < 32.0 {
                    self.dial.contentOffset.x = self.screenWidth*4.75*CGFloat(closings!.last!)/32
                } else {
                    self.dial.contentOffset.x = self.screenWidth*4.285
                }
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
                
                
                self.alertPrice = closings!.last!
                self.lastPrice = closings!.last!
            }
            
        }
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
        var _dialPrice = Int()
        if dialPrice <= 10 {
        _dialPrice = -15
        } else {
          _dialPrice = Int(dialPrice)*5 - 100
        }
        
        for i in _dialPrice..<(_dialPrice + 200) {
            
            let tickTop = UILabel()
            tickTop.frame = CGRect(x: CGFloat(i)*15*screenWidth/375, y: 0, width: 1*screenWidth/375, height: 15*screenHeight/667)
            tickTop.backgroundColor = .white
            let tickBottom = UILabel()
            tickBottom.frame = CGRect(x: CGFloat(i)*15*screenWidth/375, y: 85*screenHeight/667, width: 1*screenWidth/375, height: 15*screenHeight/667)
            tickBottom.backgroundColor = .white
            
            
            if i%5 == 0 {
                tickTop.frame.size.height = 19*screenHeight/667
                tickBottom.frame.size.height = 19*screenHeight/667
                tickBottom.frame.origin.y -= 4*screenHeight/667
                let alertOption = UILabel()
                alertOption.frame = CGRect(x: tickTop.frame.midX - 50, y: tickTop.frame.maxY, width: 100, height: tickBottom.frame.minY - tickTop.frame.maxY)
                if displayValues.count > 0 {
                    alertOption.text = String(i/5)
                    // alertOption.text = String(displayValues[i/5])
                    alertOption.textAlignment = .center
                    alertOption.textColor = .white
                    alertOption.font = UIFont(name: "Roboto-Bold", size: 14*fontSizeMultiplier)
                    dial.addSubview(alertOption)
                }
            }
            
            dial.addSubview(tickTop)
            dial.addSubview(tickBottom)
            
        }
        let dialMask = UILabel()
        dialMask.frame = CGRect(x: 0, y: 514*screenHeight/667, width: screenWidth, height: 60*screenHeight/667)
        dialMask.backgroundColor = customColor.black42Alpha0
        view.addSubview(dialMask)
        addGradient(mask: dialMask, color1: customColor.black42, color2: customColor.black42Alpha0, start: CGPoint(x: -0.2, y: 0.0), end: CGPoint(x: 0.45, y: 0.0))
        addGradient(mask: dialMask, color1: customColor.black42Alpha0, color2: customColor.black42, start: CGPoint(x: 0.55, y: 0.0), end: CGPoint(x: 1.2, y: 0.0))
        
    }
    
    func populateDialView2() {
        var _dialPrice = Int()
        if dialPrice <= 10 {
            _dialPrice = -15
        } else {
            _dialPrice = Int(dialPrice)*5 - 100
        }
        
        for i in -15..<10000 where i < _dialPrice && i > (_dialPrice + 199) {
            
            let tickTop = UILabel()
            tickTop.frame = CGRect(x: CGFloat(i)*15*screenWidth/375, y: 0, width: 1*screenWidth/375, height: 15*screenHeight/667)
            tickTop.backgroundColor = .white
            let tickBottom = UILabel()
            tickBottom.frame = CGRect(x: CGFloat(i)*15*screenWidth/375, y: 85*screenHeight/667, width: 1*screenWidth/375, height: 15*screenHeight/667)
            tickBottom.backgroundColor = .white
            
            
            if i%5 == 0 {
                tickTop.frame.size.height = 19*screenHeight/667
                tickBottom.frame.size.height = 19*screenHeight/667
                tickBottom.frame.origin.y -= 4*screenHeight/667
                let alertOption = UILabel()
                alertOption.frame = CGRect(x: tickTop.frame.midX - 50, y: tickTop.frame.maxY, width: 100, height: tickBottom.frame.minY - tickTop.frame.maxY)
                if displayValues.count > 0 {
                    alertOption.text = String(i/5)
                    // alertOption.text = String(displayValues[i/5])
                    alertOption.textAlignment = .center
                    alertOption.textColor = .white
                    alertOption.font = UIFont(name: "Roboto-Bold", size: 14*fontSizeMultiplier)
                    dial.addSubview(alertOption)
                }
            }
            
            dial.addSubview(tickTop)
            dial.addSubview(tickBottom)
            
        }
            
            

        
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockPriceToMain", sender: self)
    }
    
    @objc private func setFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockPriceToAddStockAlert", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddStockPriceToAddStockAlert" {
            let destinationViewController: AddStockAlertViewController = segue.destination as! AddStockAlertViewController
            
            destinationViewController.newAlertTicker = newAlertTicker
            destinationViewController.newAlertPrice = newAlertPrice
        }
    }
    
    
    private func prepareGraph(result: @escaping (_ dateArray: [(String,Int)]?,_ closings: [Double]?) -> Void) {
        print("entered addview google1")
        let myGoogle = Google()
        myGoogle.historicalPrices(years: 1, ticker: self.newAlertTicker) { (stockDataTuple) in
            let (_stockData,dates,_) = stockDataTuple
            guard let stockData = _stockData else {return}
            guard stockDataTuple.0!.count > 0 else {return}
            
            self.populateDialView()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == dial {
            
            let offset = Float(scrollView.contentOffset.x)
            // little messy here but should be just a linear calculation, the labeling could be wrong too
            print("displayvalues")
            print(displayValues[49])
            let a = Float((displayValues[3]-displayValues[2])*0.8+displayValues[2])
            let c = Float((displayValues[50]-displayValues[49])*0.4+displayValues[49])
            let price = offset*(c-a)/(Float(screenWidth)*9.33) + a*0.9988
            print("a: \(a)")
            print("c: \(c)")
            if price < 0.00 {
                priceLabel.text = "$0.00"
            } else if price < 5.00 {
                priceLabel.text = "$" + String(format: "%.2f", price)
            } else {
                priceLabel.text = "$" + String(format: "%.1f", price) + "0"
            }
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
