//
//  MainViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard
import Charts

class MainViewController: ViewSetup, UITextFieldDelegate, UIScrollViewDelegate {
    
    var myTextField = UITextField()
    var addTextField = UITextField()
    var stringToPass = "Patriots"
    let customColor = CustomColor()
    var menu = UIButton()
    var add = UIButton()
    var stockAlerts = UILabel()
    var slideView = UIView()
    var returnTap = UITapGestureRecognizer()
    var returnPan = UIPanGestureRecognizer()
    var returnSwipe = UISwipeGestureRecognizer()
    var date = UILabel()
    var alertAmount = UILabel()
    var alerts1102 = UILabel()
    var daysOfTheWeek = UILabel()
    var (alerts, changeEmail, addPhone, changeBroker, legal, support, goPremium) = (UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton())
    var container = UIScrollView()
    var container2 = UIScrollView()
    var alertScroller = UIScrollView()
    let mask = UIView()
    var (monthIndicator,stock1,stock2,stock3) = (UILabel(), UILabel(), UILabel(), UILabel())
    var alertCount: CGFloat = 10
    var dots = [Dot]()
    let indicatorDotWidth: CGFloat = 33
    var sv =  CompareScroll()
    var sv1 =  CompareScroll()
    var sv2 =  CompareScroll()
    var svs = [CompareScroll]()
    var svDot =  CompareScrollDot()
    var svDot1 =  CompareScrollDot()
    var svDot2 =  CompareScrollDot()
    var svsDot = [CompareScrollDot]()
    var myTimer = Timer()
    //passing the new alert from add VC
    var newAlertTicker = String()
    var newAlertPrice = Double()
    var newAlertBoolTuple = (false, false, false, false)
    var previousViewContoller = ""
    var amountOfBlocks = Int()
    let loadsave = LoadSaveCoreData()
    
    override func viewWillAppear(_ animated: Bool) {

        let (t,p,email,sms,flash,urgent) = loadsave.loadBlocks()
        if amountOfBlocks > 0 {
        for i in 0..<amountOfBlocks {
            let block = AlertBlockView(y: CGFloat(i)*120, stockTicker: t[i], currentPrice: String(p[i]), sms: sms[i], email: email[i], push: flash[i], urgent: urgent[i])
            alertScroller.addSubview(block)
            
        }
            print("amount of blocks: \(amountOfBlocks)")
            alertScroller.contentSize = CGSize(width: screenWidth, height: CGFloat(amountOfBlocks)*120*screenHeight/1334)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = customColor.black33
        svs = [sv,sv1,sv2]
        addLabel(name: date, text: "12 June", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 124, width: 150, height: 32, lines: 1)
        view.addSubview(date)
        addLabel(name: alertAmount, text: "24", textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 52, x: 84, y: 226, width: 150, height: 90, lines: 1)
        view.addSubview(alertAmount)
        addLabel(name: alerts1102, text: "Alerts    $1102", textColor: customColor.alertLines, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 324, width: 260, height: 28, lines: 1)
        view.addSubview(alerts1102)
        addLabel(name: daysOfTheWeek, text: "M  T  W  T  F  S  S", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 506, width: 260, height: 28, lines: 1)
        view.addSubview(daysOfTheWeek)
        var bar1 = UILabel(frame: CGRect(x: 92*screenWidth/750, y: 406*screenHeight/1334, width: 6*screenWidth/750, height: 74*screenHeight/1334))
        bar1.backgroundColor = customColor.yellow
        view.addSubview(bar1)
        var bar2 = UILabel(frame: CGRect(x: 130*screenWidth/750, y: 446*screenHeight/1334, width: 6*screenWidth/750, height: 34*screenHeight/1334))
        bar2.backgroundColor = customColor.yellow
        view.addSubview(bar2)
        addButton(name: alerts, x: 82, y: 680, width: 280, height: 25, title: "ALERTS", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.alertsFunc(_:)), addSubview: true)
        addButton(name: changeEmail, x: 82, y: 760, width: 280, height: 25, title: "CHANGE EMAIL", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.changeEmailFunc(_:)), addSubview: true)
        addButton(name: addPhone, x: 82, y: 840, width: 280, height: 25, title: "ADD PHONE", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.addPhoneFunc(_:)), addSubview: true)
        addButton(name: changeBroker, x: 82, y: 920, width: 280, height: 25, title: "CHANGE BROKER", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.changeBrokerFunc(_:)), addSubview: true)
        addButton(name: legal, x: 82, y: 1080, width: 280, height: 25, title: "LEGAL", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.legalFunc(_:)), addSubview: true)
        addButton(name: support, x: 82, y: 1160, width: 280, height: 25, title: "SUPPORT", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.supportFunc(_:)), addSubview: true)
        addButton(name: goPremium, x: 82, y: 1240, width: 280, height: 25, title: "GO PREMIUM", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.goPremiumFunc(_:)), addSubview: true)
        let indicator = UILabel(frame: CGRect(x: 267*screenWidth/375, y: 86*screenHeight/667, width: (indicatorDotWidth - 30)*screenWidth/375, height: 258*screenHeight/667))
        indicator.backgroundColor = customColor.white77
        slideView.addSubview(indicator)
        container.frame = CGRect(x: 0, y: 86*screenHeight/667, width: screenWidth, height: 259*screenHeight/667)
        slideView.addSubview(container)
        container.delegate = self
        sv =  CompareScroll(graphData: Set.oneYearDictionary["t"]!, stockName: "T", color: customColor.white68)
        sv1 =  CompareScroll(graphData: Set.oneYearDictionary["k"]!, stockName: "K", color: customColor.white128)
        sv2 =  CompareScroll(graphData: Set.oneYearDictionary["fig"]!, stockName: "FIG", color: customColor.white209)
        svDot =  CompareScrollDot(graphData: Set.oneYearDictionary["t"]!, stockName: "T", color: customColor.white68)
        svDot1 =  CompareScrollDot(graphData: Set.oneYearDictionary["k"]!, stockName: "K", color: customColor.white128)
        svDot2 =  CompareScrollDot(graphData: Set.oneYearDictionary["fig"]!, stockName: "FIG", color: customColor.white209)
        container.addSubview(sv)
        container.addSubview(sv1)
        container.addSubview(sv2)
        
        
        container.contentSize = CGSize(width: 2.5*11*screenWidth/5, height: 259*screenHeight/667)
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        
        
        addLabel(name: monthIndicator, text: "March, 2016", textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 400, y: 726, width: 276, height: 22, lines: 1)
        
        addLabel(name: stock1, text: "\(sv.stock): 0.0%", textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 15, x: 200, y: 24, width: 352, height: 48, lines: 0)
        addLabel(name: stock2, text: "\(sv1.stock): 0.0%", textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 15, x: 200, y: 72, width: 352, height: 48, lines: 0)
        addLabel(name: stock3, text: "\(sv2.stock): 0.0%", textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 15, x: 200, y: 120, width: 352, height: 48, lines: 0)
        for label in [monthIndicator,stock1,stock2,stock3] {
            slideView.addSubview(label)
            label.alpha = 0.0

            
            
        }
        
        
        //slideview stuff//
        slideView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(slideView)
        slideView.backgroundColor = customColor.black33
        myTextField = UITextField(frame: CGRect(x: 0,y: 400,width: screenWidth ,height: 100*screenHeight/1334))
        myTextField.placeholder = "   Search Ticker"
        myTextField.setValue(customColor.white68, forKeyPath: "_placeholderLabel.textColor")
        myTextField.font = UIFont.systemFont(ofSize: 15)
        //myTextField.borderStyle = UITextBorderStyle.roundedRect
        myTextField.autocorrectionType = UITextAutocorrectionType.no
        myTextField.keyboardType = UIKeyboardType.default
        myTextField.returnKeyType = UIReturnKeyType.done
        myTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        myTextField.delegate = self
        myTextField.backgroundColor = customColor.background
        myTextField.textColor = customColor.white68
        myTextField.tag = 0
        
        addTextField = UITextField(frame: CGRect(x: 0,y: 200,width: screenWidth ,height: 200*screenHeight/1334))
        addTextField.placeholder = "   Enter Ticker"
        addTextField.setValue(customColor.white68, forKeyPath: "_placeholderLabel.textColor")
        addTextField.font = UIFont.systemFont(ofSize: 25)
        //myTextField.borderStyle = UITextBorderStyle.roundedRect
        addTextField.autocorrectionType = UITextAutocorrectionType.no
        addTextField.keyboardType = UIKeyboardType.default
        addTextField.returnKeyType = UIReturnKeyType.done
        addTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        addTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        addTextField.delegate = self
        addTextField.backgroundColor = customColor.background
        addTextField.textColor = customColor.white68
        addTextField.alpha = 0
        addTextField.tag = 1
        
        
        slideView.addSubview(myTextField)
       // slideView.addSubview(addTextField)
        addButton(name: menu, x: 0, y: 0, width: 116, height: 122, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.menuFunc), addSubview: false)
        slideView.addSubview(menu)
        addButton(name: add, x: 638, y: 0, width: 112, height: 120, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.addFunc(_:)), addSubview: false)
        slideView.addSubview(add)
        menu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        add.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addLabel(name: stockAlerts, text: "Stock Alerts", textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 60, y: 914, width: 300, height: 40, lines: 1)
        slideView.addSubview(stockAlerts)
        let line = UILabel()
        addLabel(name: line, text: "", textColor: .clear, textAlignment: .center, fontName: "", fontSize: 1, x: 0, y: 968, width: 750, height: 2, lines: 0)
        line.backgroundColor = customColor.alertLines
        slideView.addSubview(line)
        alertScroller.frame = CGRect(x: 0, y: 974*screenHeight/1334, width: screenWidth, height: 360*screenHeight/1334)
        alertScroller.contentSize = CGSize(width: screenWidth, height: alertCount*120*screenHeight/1334)
        slideView.addSubview(alertScroller)
        

        
        //alertScroller.addSubview(googBlock)
        slideView.layer.shadowColor = UIColor.black.cgColor
        slideView.layer.shadowOpacity = 1
        slideView.layer.shadowOffset = CGSize.zero
        slideView.layer.shadowRadius = 10
        returnTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.menuReturnFunc(_:)))
        returnPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.menuReturnFunc(_:)))
        returnSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.menuReturnFunc(_:)))
        
        container2.frame = CGRect(x: 267*screenWidth/375, y: 86*screenHeight/667, width: (indicatorDotWidth - 30)*screenWidth/375, height: 258*screenHeight/667)
        container2.isUserInteractionEnabled = false
        container2.contentSize = CGSize(width: 2.5*11*screenWidth/5, height: 259*screenHeight/667)
        slideView.addSubview(container2)
        container2.addSubview(svDot)
        container2.addSubview(svDot1)
        container2.addSubview(svDot2)
        
        
        mask.frame = container.frame
        mask.backgroundColor = customColor.black33
        slideView.addSubview(mask)
        amountOfBlocks = loadsave.amount()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        container2.setContentOffset(scrollView.contentOffset, animated: false)
        let months = ["March, 2016", "April, 2016", "May, 2016", "June, 2016", "July, 2016", "August, 2016", "September, 2016", "October, 2016", "November, 2016", "December, 2016", "January, 2017", "February, 2017"]
        for i in 1...12 {
            if scrollView.contentSize.width*CGFloat(Double(i)-2.2)/12...scrollView.contentSize.width*CGFloat(Double(i)-1.2)/12 ~= scrollView.contentOffset.x {
                stock1.text = "\(sv.stock): \(sv.percentSet[i-1])%"
                stock2.text = "\(sv1.stock): \(sv1.percentSet[i-1])%"
                stock3.text = "\(sv2.stock): \(sv2.percentSet[i-1])%"
                monthIndicator.text = "\(months[i-1])"
                
                let array = [sv.percentSetVal[i-1],sv1.percentSetVal[i-1],sv2.percentSetVal[i-1]].sorted { $0 > $1 }
                UIView.animate(withDuration: 0.5) {
                if self.sv.percentSetVal[i-1] > self.sv1.percentSetVal[i-1] {
                    if self.sv.percentSetVal[i-1] > self.sv2.percentSetVal[i-1] {
                        self.stock1.frame.origin.y = 24*self.screenHeight/1334
                        if self.sv1.percentSetVal[i-1] > self.sv2.percentSetVal[i-1] {
                            self.stock2.frame.origin.y = 72*self.screenHeight/1334
                            self.stock3.frame.origin.y = 120*self.screenHeight/1334
                        } else {
                            self.stock3.frame.origin.y = 72*self.screenHeight/1334
                            self.stock2.frame.origin.y = 120*self.screenHeight/1334
                        }
                    } else {
                        self.stock3.frame.origin.y = 24*self.screenHeight/1334
                        self.stock1.frame.origin.y = 72*self.screenHeight/1334
                        self.stock2.frame.origin.y = 120*self.screenHeight/1334
                    }
                } else {
                    if self.sv.percentSetVal[i-1] > self.sv2.percentSetVal[i-1] {
                        self.stock1.frame.origin.y = 72*self.screenHeight/1334
                        if self.sv1.percentSetVal[i-1] > self.sv2.percentSetVal[i-1] {
                            self.stock2.frame.origin.y = 24*self.screenHeight/1334
                            self.stock3.frame.origin.y = 120*self.screenHeight/1334
                        } else {
                            self.stock2.frame.origin.y = 120*self.screenHeight/1334
                            self.stock3.frame.origin.y = 24*self.screenHeight/1334
                        }
                    }
                }
                    }
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0) {
            self.mask.frame.origin.x += 2.5*11*self.screenWidth/5; self.monthIndicator.alpha = 1.0; self.stock3.alpha = 1.0; self.stock2.alpha = 1.0; self.stock1.alpha = 1.0}
     
        runSearch()
        
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(MainViewController.updateDot), userInfo: nil, repeats: true)
        
        
    }
    
    func updateDot() {
        container2.setContentOffset(container.contentOffset, animated: false)
    }
    func runSearch() {
        
    }
    
    @objc private func alertsFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func changeEmailFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromMainToSettings", sender: self)
    }
    @objc private func addPhoneFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromMainToSettings", sender: self)
    }
    @objc private func changeBrokerFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromMainToSettings", sender: self)
    }
    @objc private func legalFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func supportFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func goPremiumFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    
    func menuFunc() {
        if slideView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.3) {self.slideView.frame.origin.x += 516*self.screenWidth/750}
            
            slideView.addGestureRecognizer(returnTap)
            slideView.addGestureRecognizer(returnSwipe)
            slideView.addGestureRecognizer(returnPan)
            container.isUserInteractionEnabled = false
            
            
        } else if slideView.frame.origin.x == 516*self.screenWidth/750 {
            UIView.animate(withDuration: 0.3) {self.slideView.frame.origin.x -= 516*self.screenWidth/750}
            slideView.removeGestureRecognizer(returnTap)
            slideView.removeGestureRecognizer(returnSwipe)
            slideView.removeGestureRecognizer(returnPan)
            container.isUserInteractionEnabled = true
        }
    }
    func menuReturnFunc(_ gesture: UIGestureRecognizer) {
        if slideView.frame.origin.x == 516*self.screenWidth/750 {
            
            UIView.animate(withDuration: 0.3) {self.slideView.frame.origin.x -= 516*self.screenWidth/750}
            slideView.removeGestureRecognizer(returnTap)
            slideView.removeGestureRecognizer(returnSwipe)
            slideView.removeGestureRecognizer(returnPan)
            container.isUserInteractionEnabled = true
        }
    }
    
    @objc private func addFunc(_ sender: UIButton) {
        let cover = UIView(frame: view.frame)
        cover.backgroundColor = customColor.black24
        cover.alpha = 0.0
        slideView.addSubview(cover)
        slideView.addSubview(addTextField)
        
        UIView.animate(withDuration: 1.0) {
            self.addTextField.alpha = 1.0
            cover.alpha = 1.0
        }
        delay(bySeconds: 0.8) {
           self.addTextField.becomeFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
        self.view.endEditing(true)
        if myTextField.text != nil && myTextField.delegate != nil {
            
            stringToPass = myTextField.text!
            goToGraph()
            }
        } else if textField.tag == 1 {
            if addTextField.text != nil && addTextField.delegate != nil {
                
                stringToPass = addTextField.text!
                self.performSegue(withIdentifier: "fromMainToAdd", sender: self)
            }
        }
        
        return false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMainToGraph" {
        let graphView: GraphViewController = segue.destination as! GraphViewController

        graphView.passedString = stringToPass
        } else if segue.identifier == "fromMainToAdd" {
            let addView: AddViewController = segue.destination as! AddViewController
            
            addView.newAlertTicker = stringToPass.uppercased()
        }
        
        
    }
    
    @objc private func goToGraph() {
        self.performSegue(withIdentifier: "fromMainToGraph", sender: self)
        
    }
    
    func getOneMonthData(stockName: String, result: @escaping (_ closingPrices: ([Double]?), _ stockName: String) -> Void) {
      
        BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
   
                var stockData = [Double]()
           
                stock.mapOneYearChartDataModule({
          
                    
                        
                        for point in (stock.oneYearChartModule?.dataPoints)! {
                            
                           // stockData.dates.append(point.date)
                            stockData.append(point.close)
                            
               
                        }
          
                    result(stockData, stockName)
     
                }, failure: { (error) in
                    print(error)
                    result(nil, stockName)
                })
            
        }) { (error) in
            print(error)
            result(nil, stockName)
        }
        
        
        
    }
    
    
    
    
    
    
    
}
