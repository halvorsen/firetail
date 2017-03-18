//
//  addViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/13/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard

class AddViewController: ViewSetup {
    let customColor = CustomColor()
    let alertLabel2 = UILabel()
    var alertChangeTimer = Timer()
    var alertPrice: Double = 0.00 {didSet{ alertLabel2.text = "$" + String(format: "%.2f", alertPrice)  }}
    var touchDown = UILongPressGestureRecognizer()
    var touchUp = UILongPressGestureRecognizer()
    var tapDown = UITapGestureRecognizer()
    var tapUp = UITapGestureRecognizer()
    let stockTitle = UILabel()
    var container = UIScrollView()
    var graph = DailyGraphForAlertView()
    var newAlertTicker = String()
    var newAlertPrice = Double()
    var newAlertBoolTuple = (false, false, false, false)
    let backArrow = UIButton()
    var amountOfBlocksOld = Int()
    let loadsave = LoadSaveCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountOfBlocksOld = loadsave.amount()
        
        view.backgroundColor = customColor.black33
        let bottomBar = UIView()
        bottomBar.frame = CGRect(x: 0, y: 597*screenHeight/667, width: screenWidth, height: 70*screenHeight/667)
        bottomBar.backgroundColor = customColor.black24
        view.addSubview(bottomBar)
        
        let alertLabel = UILabel()
        addLabel(name: alertLabel, text: "Price Alert", textColor: customColor.white216, textAlignment: .left, fontName: "Roboto-Light", fontSize: 17, x: 64, y: 1252, width: 240, height: 40, lines: 0)
        view.addSubview(alertLabel)
        
        
        addLabel(name: alertLabel2, text: "$", textColor: customColor.white216, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 17, x: 256, y: 1252, width: 240, height: 40, lines: 0)
        view.addSubview(alertLabel2)
        
        
        
        
        let raiseAlertPrice = UILabel()
        addLabel(name: raiseAlertPrice, text: "\u{2191}", textColor: customColor.black42, textAlignment: .center, fontName: "Roboto-Bold", fontSize: 17, x: 410, y: 1252, width: 70, height: 40, lines: 3)
        view.addSubview(raiseAlertPrice)
        
        touchUp = UILongPressGestureRecognizer(target: self, action: #selector(AddViewController.changeAlertPriceUp(_:)))
        tapUp = UITapGestureRecognizer(target: self, action: #selector(AddViewController.bumpUp))
        tapDown = UITapGestureRecognizer(target: self, action: #selector(AddViewController.bumpDown))
        
        let lowerAlertPrice = UILabel()
        addLabel(name: lowerAlertPrice, text: "\u{2193}", textColor: customColor.black42, textAlignment: .center, fontName: "HelveticaNeue", fontSize: 17, x: 480, y: 1252, width: 70, height: 40, lines: 3)
        view.addSubview(lowerAlertPrice)
        touchDown = UILongPressGestureRecognizer(target: self, action: #selector(AddViewController.changeAlertPriceDown(_:)))
        
        let raiseAlertView = UIView()
        raiseAlertView.frame = CGRect(x: 205*screenWidth/375, y:0, width: 35*screenWidth/375, height: 70*screenHeight/667)
        bottomBar.addSubview(raiseAlertView)
        
        let lowerAlertView = UIView()
        lowerAlertView.frame = CGRect(x: 240*screenWidth/375, y: 0, width: 35*screenWidth/375, height: 70*screenHeight/667)
        bottomBar.addSubview(lowerAlertView)
        
        lowerAlertView.addGestureRecognizer(touchDown)
        raiseAlertView.addGestureRecognizer(touchUp)
        lowerAlertView.addGestureRecognizer(tapDown)
        raiseAlertView.addGestureRecognizer(tapUp)
        
        var add = UIButton()
        addButton(name: add, x: 610, y: 0, width: 140, height: 140, title: "  +", font: "Roboto-Light", fontSize: 45, titleColor: customColor.black33, bgColor: .white, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddViewController.add(_:)), addSubview: false)
        add.titleLabel?.textAlignment = .center //this isnt working for some reason
        bottomBar.addSubview(add)
        
        addLabel(name: stockTitle, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 40, x: 60, y: 600, width: 240, height: 80, lines: 1)
        view.addSubview(stockTitle)
        
        for i in 0...3 {
            let l = UILabel()
            let name = ["Email","SMS","Flash","Urgent"]
            addLabel(name: l, text: name[i], textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 16, x: 212, y: 748 + CGFloat(i)*96, width: 150, height: 40, lines: 0)
            view.addSubview(l)
        }
        
        let mySwitchEmail = UISwitch()
        mySwitchEmail.frame = CGRect(x: 27*screenWidth/375, y: 369*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchEmail.setOn(false, animated: false)
        mySwitchEmail.tintColor = customColor.white229
        mySwitchEmail.layer.cornerRadius = 16
        mySwitchEmail.backgroundColor = .white
        mySwitchEmail.onTintColor = customColor.yellow
        //    mySwitchEmail.thumbTintColor = customColor.white229
        mySwitchEmail.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchEmail.tag = 0
        view.addSubview(mySwitchEmail)
        
        let mySwitchSMS = UISwitch()
        mySwitchSMS.frame = CGRect(x: 27*screenWidth/375, y: 417*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchSMS.setOn(false, animated: false)
        mySwitchSMS.tintColor = customColor.white229
        mySwitchSMS.layer.cornerRadius = 16
        mySwitchSMS.backgroundColor = .white
        mySwitchSMS.onTintColor = customColor.yellow
        //     mySwitchSMS.thumbTintColor = customColor.white229
        mySwitchSMS.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchSMS.tag = 1
        view.addSubview(mySwitchSMS)
        
        let mySwitchFlash = UISwitch()
        mySwitchFlash.frame = CGRect(x: 27*screenWidth/375, y: 465*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchFlash.setOn(false, animated: false)
        mySwitchFlash.tintColor = customColor.white229
        mySwitchFlash.layer.cornerRadius = 16
        mySwitchFlash.backgroundColor = .white
        mySwitchFlash.onTintColor = customColor.yellow
        // mySwitchFlash.thumbTintColor = customColor.white229
        mySwitchFlash.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchFlash.tag = 2
        view.addSubview(mySwitchFlash)
        
        let mySwitchUrgent = UISwitch()
        mySwitchUrgent.frame = CGRect(x: 27*screenWidth/375, y: 513*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchUrgent.setOn(false, animated: false)
        // mySwitchUrgent.tintColor = .blue //customColor.white229
        
        mySwitchUrgent.layer.cornerRadius = 16
        mySwitchUrgent.layer.borderWidth = 1.5
        mySwitchUrgent.layer.borderColor = customColor.white229.cgColor
        mySwitchUrgent.backgroundColor = .white
        mySwitchUrgent.onTintColor = customColor.yellow
        //  mySwitchUrgent.thumbTintColor = customColor.white229
        mySwitchUrgent.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchUrgent.tag = 3
        view.addSubview(mySwitchUrgent)
        
        
        
        container = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260*screenHeight/667))
        container.contentSize = CGSize(width: 3.8*screenWidth, height: container.bounds.height)
        container.backgroundColor = customColor.black33
        container.contentOffset =  CGPoint(x: 2.8*screenWidth, y: 0)
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        view.addSubview(container)
        
//        callCorrectGraph2(stockName: self.stockName) {(_ stockData: ([String],[StockData2?])) -> Void in
        
        prepareGraph() {(_ dateArray: [Date]?,_ closings: [Double]?) -> Void in
            if closings != nil && dateArray != nil {
                self.graph = DailyGraphForAlertView(graphData: closings!, dateArray: dateArray!)
            self.container.addSubview(self.graph)
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: 0, y: -100)
                t = t.scaledBy(x: 1.0, y: 0.01)
                self.graph.transform = t
                
                UIView.animate(withDuration: 1.5) {
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
            }
   
        }
        prepareGraph() {result in
            
            
            
        }
        
        
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        
    }
    let mask = UIView()
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 1.0) {
//            self.mask.frame.origin.x += self.screenWidth
//        }
        
        
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddToMain", sender: self)
    }
    
    @objc private func switchChanged(_ sender: UISwitch!) {
        if sender.isOn {
        switch sender.tag {
        case 0:
            newAlertBoolTuple.0 = true
        case 1:
            newAlertBoolTuple.1 = true
        case 2:
            newAlertBoolTuple.2 = true
        case 3:
            newAlertBoolTuple.3 = true
        default:
            break
        }
        } else {
            switch sender.tag {
            case 0:
                newAlertBoolTuple.0 = false
            case 1:
                newAlertBoolTuple.1 = false
            case 2:
                newAlertBoolTuple.2 = false
            case 3:
                newAlertBoolTuple.3 = false
            default:
                break
            }
        }
        print("Switch value is \(sender.isOn)")
    }
    
    
    @objc private func add(_ button: UIButton) {
        loadsave.saveBlockAmount(amount: amountOfBlocksOld + 1)
        loadsave.saveBlock(stockTicker: newAlertTicker, currentPrice: alertPrice, sms: newAlertBoolTuple.0, email: newAlertBoolTuple.1, flash: newAlertBoolTuple.2, urgent: newAlertBoolTuple.3)
        self.performSegue(withIdentifier: "fromAddToMain", sender: self)
    }
    
    var count = 0
    @objc private func decreasePrice() {
        
        switch count {
        case 0...9: alertPrice -= 0.01; count += 1
        case 10...19: alertPrice -= 0.1; count += 1
        default: alertPrice -= 1.0; count += 1
        }
        
    }
    @objc private func increasePrice() {
        
        switch count {
        case 0...9: alertPrice += 0.01; count += 1
        case 10...19: alertPrice += 0.1; count += 1
        default: alertPrice += 1.0; count += 1
        }
    }
    @objc private func bumpUp() {
        alertPrice += 0.01
    }
    
    @objc private func bumpDown() {
        alertPrice -= 0.01
    }
    
    
    var timerInterval = 0.1
    @objc func changeAlertPriceUp(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.began {
            alertChangeTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(AddViewController.increasePrice), userInfo: nil, repeats: true)
        }
        
        if gesture.state == UIGestureRecognizerState.ended {
            alertChangeTimer.invalidate()
            count = 0
        }
        
    }
    @objc func changeAlertPriceDown(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.began {
            alertChangeTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(AddViewController.decreasePrice), userInfo: nil, repeats: true)
        }
        
        if gesture.state == UIGestureRecognizerState.ended {
            alertChangeTimer.invalidate()
            count = 0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainView: MainViewController = segue.destination as! MainViewController
        mainView.previousViewContoller = "Add"
        mainView.amountOfBlocks = amountOfBlocksOld + 1
    }

    private func prepareGraph(result: @escaping (_ dateArray: [Date]?,_ closings: [Double]?) -> Void) {
        BigBoard.stockWithSymbol(symbol: newAlertTicker, success: { (stock) in
            
            var stockData = [Double]()
            var dates = [Date]()
            
            stock.mapOneMonthChartDataModule({
      
                
                for point in (stock.oneMonthChartModule?.dataPoints)! {
                    
                    dates.append(point.date)
                    stockData.append(point.close)
                }
                
                result(dates, stockData)
                
            }, failure: { (error) in
                print(error)
                result(nil, nil)
            })
            
        }) { (error) in
            print(error)
            result(nil, nil)
        }
    }
}
