//
//  MainViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//
// OR DASHBOARD VIEWCONTROLLER

import UIKit
import BigBoard
import Charts
import SwiftyStoreKit
import StoreKit
import MessageUI

class DashboardViewController: ViewSetup, UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    var activityView = UIActivityIndicatorView()
    var premiumMember = false
    var addTextField = UITextField()
    var stringToPass = "#@$%"
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
    var newAlertTicker = String()
    var newAlertPrice = Double()
    var newAlertBoolTuple = (false, false, false, false)
    var previousViewContoller = ""
    var amountOfBlocks = Int()
    var blocks = [AlertBlockView]()
    var newBlocks = [AlertBlockView]()
    let loadsave = LoadSaveCoreData()
    var longPress = UILongPressGestureRecognizer()
    var pan = UIPanGestureRecognizer()
    var canIScroll = true
    var myTimer2 = Timer()
    
    var savedFrameOrigin = CGPoint()
    var l = 1
    var k = 10000
    var movingAlert = 9999
    var longpressOnce = true
    var alertInMotion = AlertBlockView()
    var val = CGFloat()
    var alertID: [String] {
        var aaa = [String]()
        for i in 0..<Set1.alertCount {
            switch i {
            case 0...9:
                aaa.append("alert00" + String(i))
            case 10...99:
                aaa.append("alert0" + String(i))
            case 100...999:
                aaa.append("alert" + String(i))
            default:
                break
            }
        }
        return aaa
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Set1.alertCount > 0 {
            for i in 0..<Set1.alertCount {
                
                let block = AlertBlockView(y: CGFloat(i)*120, stockTicker: Set1.alerts[Set1.userAlerts[alertID[i]]!]!.ticker, currentPrice: Set1.alerts[Set1.userAlerts[alertID[i]]!]!.price, sms: Set1.alerts[Set1.userAlerts[alertID[i]]!]!.sms, email: Set1.alerts[Set1.userAlerts[alertID[i]]!]!.email, flash: Set1.alerts[Set1.userAlerts[alertID[i]]!]!.flash, urgent: Set1.alerts[Set1.userAlerts[alertID[i]]!]!.urgent, longName: Set1.userAlerts[alertID[i]]!)
                
                block.ex.addTarget(self, action: #selector(DashboardViewController.act(_:)), for: .touchUpInside)
                
                
                blocks.append(block)
                alertScroller.addSubview(block)
                
            }
            alertScroller.contentSize = CGSize(width: screenWidth, height: CGFloat(amountOfBlocks)*120*screenHeight/1334)
        }
        let alertTap = UITapGestureRecognizer(target: self, action: #selector(DashboardViewController.detail(_:)))
        view.addGestureRecognizer(alertTap)
        if blocks.count > 3 {
            val = blocks[amountOfBlocks - 2].frame.maxY
        } else {
            val = 0
        }
        
        Set1.saveUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        premiumMember = Set1.premium
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(DashboardViewController.longPress(_:)))
        view.addGestureRecognizer(longPress)
        longPress.delegate = self
        pan = UIPanGestureRecognizer(target: self, action: #selector(DashboardViewController.pan(_:)))
        view.addGestureRecognizer(pan)
        self.view.backgroundColor = customColor.black33
        svs = [sv,sv1,sv2]
        let d = Date()
        let m = ["","JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"]
        addLabel(name: date, text: "\(d.day) \(m[d.month])", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 124, width: 150, height: 32, lines: 1)
        view.addSubview(date)
        
        addLabel(name: alertAmount, text: String(Set1.alertCount), textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 52, x: 84, y: 226, width: 150, height: 90, lines: 1)
        view.addSubview(alertAmount)
        addLabel(name: alerts1102, text: "Alerts", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 324, width: 260, height: 28, lines: 1)
        alerts1102.alpha = 0.5
        view.addSubview(alerts1102)
        addLabel(name: daysOfTheWeek, text: "M  T  W  T  F", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 506, width: 260, height: 28, lines: 1)
        view.addSubview(daysOfTheWeek)
        daysOfTheWeek.alpha = 0.0
        populateAlertBars()
        addButton(name: alerts, x: 82, y: 680, width: 280, height: 25, title: "ALERTS", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.alertsFunc(_:)), addSubview: true)
        addButton(name: changeEmail, x: 82, y: 760, width: 280, height: 25, title: "CHANGE EMAIL", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.changeEmailFunc(_:)), addSubview: true)
        addButton(name: addPhone, x: 82, y: 840, width: 280, height: 25, title: "ADD PHONE", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.addPhoneFunc(_:)), addSubview: true)
        addButton(name: changeBroker, x: 82, y: 920, width: 280, height: 25, title: "CHANGE BROKER", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.changeBrokerFunc(_:)), addSubview: true)
        addButton(name: legal, x: 82, y: 1080, width: 280, height: 25, title: "LEGAL", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.legalFunc(_:)), addSubview: true)
        addButton(name: support, x: 82, y: 1160, width: 280, height: 25, title: "SUPPORT", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.supportFunc(_:)), addSubview: true)
        addButton(name: goPremium, x: 82, y: 1240, width: 280, height: 25, title: "GO PREMIUM", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.goPremiumFunc(_:)), addSubview: true)
        let indicator = UILabel(frame: CGRect(x: 267*screenWidth/375, y: 86*screenHeight/667, width: (indicatorDotWidth - 30)*screenWidth/375, height: 258*screenHeight/667))
        indicator.backgroundColor = customColor.white77
        slideView.addSubview(indicator)
        container.frame = CGRect(x: 0, y: 86*screenHeight/667, width: screenWidth, height: 259*screenHeight/667)
        slideView.addSubview(container)
        container.delegate = self
        container2.frame = CGRect(x: 267*screenWidth/375, y: 86*screenHeight/667, width: (indicatorDotWidth - 30)*screenWidth/375, height: 258*screenHeight/667)
        container2.isUserInteractionEnabled = false
        container2.contentSize = CGSize(width: 2.5*11*screenWidth/5, height: 259*screenHeight/667)
        slideView.addSubview(container2)
        
        populateCompareGraph()
        
        container.contentSize = CGSize(width: 2.5*11*screenWidth/5, height: 259*screenHeight/667)
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        addLabel(name: monthIndicator, text: Set1.month[1], textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 400, y: 726, width: 276, height: 22, lines: 1)
        
        addLabel(name: stock1, text: "", textColor: customColor.white68, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 200, y: 24, width: 352, height: 48, lines: 0)
        addLabel(name: stock2, text: "", textColor: customColor.white128, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 200, y: 72, width: 352, height: 48, lines: 0)
        addLabel(name: stock3, text: "", textColor: customColor.white209, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 200, y: 120, width: 352, height: 48, lines: 0)
        
        switch Set1.alertCount {
        case 0:
            break
        case 1:
            stock1.text = "\(sv.stock): \(sv.percentSet[1])%"
        case 2:
            stock1.text = "\(sv.stock): \(sv.percentSet[1])%"
            stock2.text = "\(sv1.stock): \(sv1.percentSet[1])%"
        default:
            stock1.text = "\(sv.stock): \(sv.percentSet[1])%"
            stock2.text = "\(sv1.stock): \(sv1.percentSet[1])%"
            stock3.text = "\(sv2.stock): \(sv2.percentSet[1])%"
        }
        
        for label in [monthIndicator,stock1,stock2,stock3] {
            slideView.addSubview(label)
            label.alpha = 0.0
        }
        
        //slideview stuff//
        slideView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(slideView)
        slideView.backgroundColor = customColor.black33
        
        for i in 0...4 {
            let line = UIView()
            line.backgroundColor = .white
            line.alpha = 0.05
            line.frame.size = CGSize(width: screenWidth/375, height: 260*screenHeight/667)
            line.frame.origin.y = 84*screenHeight/667
            line.frame.origin.x = 27*screenWidth/375 + CGFloat(i)*80*screenWidth/375
            slideView.addSubview(line)
        }
        
        //        myTextField = UITextField(frame: CGRect(x: 0,y: 400*screenHeight/667,width: screenWidth ,height: 100*screenHeight/1334))
        //        myTextField.placeholder = "Search Ticker."
        //        myTextField.textAlignment = .center
        //        myTextField.setValue(customColor.white68, forKeyPath: "_placeholderLabel.textColor")
        //        myTextField.font = UIFont.systemFont(ofSize: 15)
        //        //myTextField.borderStyle = UITextBorderStyle.roundedRect
        //        myTextField.autocorrectionType = UITextAutocorrectionType.no
        //        myTextField.keyboardType = UIKeyboardType.default
        //        myTextField.returnKeyType = UIReturnKeyType.done
        //        myTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        //        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        //        myTextField.delegate = self
        //        myTextField.backgroundColor = customColor.background
        //        myTextField.textColor = customColor.white68
        //        myTextField.tag = 0
        
        addTextField = UITextField(frame: CGRect(x: 0,y: 200,width: screenWidth ,height: 200*screenHeight/1334))
        addTextField.placeholder = "   Enter Ticker"
        addTextField.setValue(customColor.white68, forKeyPath: "_placeholderLabel.textColor")
        addTextField.font = UIFont.systemFont(ofSize: 25)
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
        addTextField.keyboardAppearance = .dark
        
        //    slideView.addSubview(myTextField)
        // slideView.addSubview(addTextField)
        addButton(name: menu, x: 0, y: 0, width: 116, height: 122, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.menuFunc), addSubview: false)
        slideView.addSubview(menu)
        addButton(name: add, x: 638, y: 0, width: 112, height: 120, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.addFunc(_:)), addSubview: false)
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
        returnTap = UITapGestureRecognizer(target: self, action: #selector(DashboardViewController.menuReturnFunc(_:)))
        returnPan = UIPanGestureRecognizer(target: self, action: #selector(DashboardViewController.menuReturnFunc(_:)))
        returnSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DashboardViewController.menuReturnFunc(_:)))
        
        mask.frame = container.frame
        mask.backgroundColor = customColor.black33
        slideView.addSubview(mask)
        //amountOfBlocks = loadsave.amount()
        amountOfBlocks = Set1.alertCount
        whoseOnFirst(container)
        
    }
    
    
    @objc private func longPress(_ gesture: UIGestureRecognizer) {
        guard amountOfBlocks > 3 else {return}
        startedPan = false
        alertScroller.isScrollEnabled = false
        if longpressOnce {
            for i in 0..<blocks.count {
                
                if blocks[i].frame.contains(gesture.location(in: alertScroller)) {
                    savedFrameOrigin = blocks[i].frame.origin
                    blocks[i].frame.origin.y -= 6*screenHeight/667
                    blocks[i].frame.origin.x -= 6*screenHeight/667
                    movingAlert = i
                    longpressOnce = false
                    l = i - 1
                    k = i + 1
                    blocks[i].slideView.backgroundColor = customColor.black42
                    alertScroller.backgroundColor = customColor.white115
                    alertInMotion = blocks[i]
                    alertInMotion.layer.zPosition = 1000
                }
            }
        }
        if gesture.state == UIGestureRecognizerState.ended {
            if !startedPan {
                
                
                alertInMotion.frame.origin = savedFrameOrigin
                alertScroller.backgroundColor = self.customColor.black33
                alertInMotion.slideView.backgroundColor = self.customColor.black33
                var j = CGFloat(2)
                for block in blocks {
                    block.layer.zPosition = j
                    j += 1
                }
                movingAlert = 9999
                alertScroller.isScrollEnabled = true
                longpressOnce = true
                
                
                
                loadsave.resaveBlocks(blocks: blocks)
                if blocks.count > 3 {
                    val = blocks[amountOfBlocks - 2].frame.maxY
                } else {
                    val = 0
                }
                
                UIView.animate(withDuration: 0.5) {
                    
                    self.alertInMotion.frame.origin = CGPoint(x: 0, y: CGFloat(self.q)*120*self.screenHeight/1334)
                }
                p = Int(savedFrameOrigin.y/120)
                
                movingAlert = 9999
                delay(bySeconds: 0.3) {
                    self.alertScroller.isScrollEnabled = true
                }
                
                var i = CGFloat(0)
                for block in blocks {
                    Set1.ti[Int(i)] = block.stockTickerLabel.text!
                    block.layer.zPosition = i + 2
                    i += 1
                    
                }
                delay(bySeconds: 0.5) {
                    self.alertScroller.backgroundColor = self.customColor.black33
                    self.alertInMotion.slideView.backgroundColor = self.customColor.black33
                }
                
                myTimer2.invalidate()
                
                reboot()
                delay(bySeconds: 0.5) {
                    self.longpressOnce = true
                }
                
                
                if alertScroller.contentOffset.y < 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.alertScroller.contentOffset.y = 0
                    }
                }
            }
            Set1.saveUserInfo()
        }
        
    }
    var startedPan = false
    var q = Int()
    @objc private func pan(_ gesture: UIPanGestureRecognizer) {
        
        startedPan = true
        if movingAlert != 9999 {
            guard amountOfBlocks > 3 else {return}
            if gesture.state == UIGestureRecognizerState.changed {
                
                let translation = gesture.translation(in: view)
                
                if alertInMotion.center.y < alertScroller.contentOffset.y + 300*screenHeight/1334 && alertInMotion.center.y > alertScroller.contentOffset.y + 90*screenHeight/1334 {
                    alertInMotion.center = CGPoint(x: alertInMotion.center.x + translation.x, y: alertInMotion.center.y + translation.y*CGFloat(2*alertScroller.contentSize.height/alertScroller.frame.height))
                } else if translation.y < 0 && alertInMotion.center.y >= alertScroller.contentOffset.y + 300*screenHeight/1334 {
                    alertInMotion.center = CGPoint(x: alertInMotion.center.x + translation.x, y: alertScroller.contentOffset.y + 299*screenHeight/1334)
                } else if translation.y > 0 && alertInMotion.center.y <= alertScroller.contentOffset.y + 90*screenHeight/1334 {
                    alertInMotion.center = CGPoint(x: alertInMotion.center.x + translation.x, y: alertScroller.contentOffset.y + 99*screenHeight/1334)
                }
                
                alertScroller.contentOffset.y = alertScroller.contentOffset.y + translation.y*CGFloat(alertScroller.contentSize.height/alertScroller.frame.height)
                
                gesture.setTranslation(CGPoint(x:0,y:0), in: self.view)
                if l > -1 {
                    if alertInMotion.center.y < blocks[l].center.y {
                        savedFrameOrigin = blocks[l].frame.origin
                        blocks[l].frame.origin.y += 120*screenHeight/1334
                        
                        blocks[l+1] = blocks[l]
                        blocks[l] = alertInMotion
                        q = l
                        l -= 1
                        k -= 1
                    }
                }
                if k < blocks.count {
                    if alertInMotion.center.y > blocks[k].center.y {
                        savedFrameOrigin = blocks[k].frame.origin
                        UIView.animate(withDuration: 0.3) {
                            self.blocks[self.k].frame.origin.y -= 120*self.screenHeight/1334
                        }
                        blocks[k-1] = blocks[k]
                        blocks[k] = alertInMotion
                        
                        q = k
                        k += 1
                        l += 1
                    }
                }
                
            }
            
            if gesture.state == UIGestureRecognizerState.ended {
                
                loadsave.resaveBlocks(blocks: blocks)
                if blocks.count > 3 {
                    val = blocks[amountOfBlocks - 2].frame.maxY
                } else {
                    val = 0
                }
                
                UIView.animate(withDuration: 0.5) {
                    
                    self.alertInMotion.frame.origin = CGPoint(x: 0, y: CGFloat(self.q)*120*self.screenHeight/1334)
                }
                p = Int(savedFrameOrigin.y/120)
                
                movingAlert = 9999
                delay(bySeconds: 0.3) {
                    self.alertScroller.isScrollEnabled = true
                }
                
                var i = CGFloat(0)
                for block in blocks {
                    Set1.ti[Int(i)] = block.stockTickerLabel.text!
                    block.layer.zPosition = i + 2
                    i += 1
                }
                delay(bySeconds: 0.5) {
                    self.alertScroller.backgroundColor = self.customColor.black33
                    self.alertInMotion.slideView.backgroundColor = self.customColor.black33
                }
                
                myTimer2.invalidate()
                
                reboot()
                delay(bySeconds: 0.5) {
                    self.longpressOnce = true
                }
                if alertScroller.contentOffset.y < 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.alertScroller.contentOffset.y = 0
                    }
                }
            }
        } else {
            for i in 0..<blocks.count {
                if blocks[i].frame.contains(gesture.location(in: alertScroller)) && gesture.translation(in: view).x < 0 {
                    UIView.animate(withDuration: 0.6) {
                        self.blocks[i].slideView.frame.origin.x = -120*self.screenWidth/750
                    }
                } else if gesture.translation(in: view).x > 0 && self.blocks[i].slideView.frame.origin.x != 0 {
                    UIView.animate(withDuration: 0.6) {
                        self.blocks[i].slideView.frame.origin.x = 0
                    }
                }
            }
            
        }
    }
    var p = Int()
    @objc func act(_ button: UIButton) {
        stock1.text = ""
        stock2.text = ""
        stock3.text = ""
        var check = false
        var position: CGFloat = 1
        
        for i in 0..<blocks.count {
            
            
            if (button.title(for: .disabled)! == self.blocks[i].stockTickerLabel.text) {
                Set1.ti.removeAll()
                
                UIView.animate(withDuration: 0.6) {
                    self.blocks[i].removeFromSuperview()
                    // self.blocks[i].slideView.frame.origin.x = 0
                }
                check = true
                for k in 0..<i {
                    self.blocks[k].layer.zPosition = position; position += 1
                    newBlocks.append(blocks[k])
                    Set1.ti.append(blocks[k].stockTickerGlobal)
                    
                }
                if i != (blocks.count - 1) {
                    for k in (i+1)..<blocks.count {
                        self.blocks[k].layer.zPosition = position; position += 1
                        newBlocks.append(blocks[k])
                        Set1.ti.append(blocks[k].stockTickerGlobal)
                        
                    }
                }
            }
            
            if check {
                UIView.animate(withDuration: 0.6) { self.blocks[i].frame.origin.y -= 120*self.screenHeight/1334 }
            }
        }
        
        blocks = newBlocks
        newBlocks.removeAll()
        amountOfBlocks -= 1
        alertAmount.text = String(amountOfBlocks)
        alertScroller.contentSize = CGSize(width: screenWidth, height: CGFloat(amountOfBlocks)*120*screenHeight/1334)
        
        Set1.alertCount = amountOfBlocks
        
        loadsave.resaveBlocks(blocks: blocks)
        Set1.alertCount = amountOfBlocks
        
        reboot()
        Set1.saveUserInfo()
    }
    
    
    @objc private func detail(_ gesture: UIGestureRecognizer) {
        for block in blocks {
            
            let frame = view.convert(block.frame, from:alertScroller)
            if frame.contains(gesture.location(in: view)) {
                
                stringToPass = block.stockTickerGlobal
                self.performSegue(withIdentifier: "fromMainToGraph", sender: self)
            }
        }
        
        
    }
    
    func reboot() {
        mask.frame = container.frame
        mask.alpha = 1.0
        for view in container.subviews{
            view.removeFromSuperview()
        }
        for view in container2.subviews{
            view.removeFromSuperview()
        }
        
        populateCompareGraph()
        
        whoseOnFirst(container)
        
        UIView.animate(withDuration: 2.0) {
            self.mask.frame.origin.x += 2.5*11*self.screenWidth/5; self.monthIndicator.alpha = 1.0; self.stock3.alpha = 1.0; self.stock2.alpha = 1.0; self.stock1.alpha = 1.0}
    }
    
    private func populateCompareGraph() {
        
        switch Set1.alertCount {
        case 0:
            break
        case 1:
            sv =  CompareScroll(graphData: Set1.oneYearDictionary[Set1.ti[0]]!, stockName: Set1.ti[0], color: customColor.white68)
            svDot =  CompareScrollDot(graphData: Set1.oneYearDictionary[Set1.ti[0]]!, stockName: Set1.ti[0], color: customColor.white68)
            container.addSubview(sv)
            container2.addSubview(svDot)
            
        case 2:
            sv =  CompareScroll(graphData: Set1.oneYearDictionary[Set1.ti[0]]!, stockName: Set1.ti[0], color: customColor.white68)
            sv1 =  CompareScroll(graphData: Set1.oneYearDictionary[Set1.ti[1]]!, stockName: Set1.ti[1], color: customColor.white128)
            svDot =  CompareScrollDot(graphData: Set1.oneYearDictionary[Set1.ti[0]]!, stockName: Set1.ti[0], color: customColor.white68)
            svDot1 =  CompareScrollDot(graphData: Set1.oneYearDictionary[Set1.ti[1]]!, stockName: Set1.ti[1], color: customColor.white128)
            container.addSubview(sv)
            container.addSubview(sv1)
            container2.addSubview(svDot)
            container2.addSubview(svDot1)
            
        default:
            sv =  CompareScroll(graphData: Set1.oneYearDictionary[Set1.ti[0]]!, stockName: Set1.ti[0], color: customColor.white68)
            sv1 =  CompareScroll(graphData: Set1.oneYearDictionary[Set1.ti[1]]!, stockName: Set1.ti[1], color: customColor.white128)
            sv2 =  CompareScroll(graphData: Set1.oneYearDictionary[Set1.ti[2]]!, stockName: Set1.ti[2], color: customColor.white209)
            svDot =  CompareScrollDot(graphData: Set1.oneYearDictionary[Set1.ti[0]]!, stockName: Set1.ti[0], color: customColor.white68)
            svDot1 =  CompareScrollDot(graphData: Set1.oneYearDictionary[Set1.ti[1]]!, stockName: Set1.ti[1], color: customColor.white128)
            svDot2 =  CompareScrollDot(graphData: Set1.oneYearDictionary[Set1.ti[2]]!, stockName: Set1.ti[2], color: customColor.white209)
            container.addSubview(sv)
            container.addSubview(sv1)
            container.addSubview(sv2)
            container2.addSubview(svDot)
            container2.addSubview(svDot1)
            container2.addSubview(svDot2)
        }
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        container2.setContentOffset(scrollView.contentOffset, animated: false)
        
        whoseOnFirst(scrollView)
    }
    
    func whoseOnFirst(_ scrollView: UIScrollView) {
        
        for i in 0...11 {
            if scrollView.contentSize.width*CGFloat(Double(i+1)-2.05)/12...scrollView.contentSize.width*CGFloat(Double(i+1)-2.0)/12 ~= scrollView.contentOffset.x {
                
                switch Set1.alertCount {
                case 0:
                    break
                case 1:
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                case 2:
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    stock2.text = "\(sv1.stock): \(sv1.percentSet[i])%"
                default:
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    stock2.text = "\(sv1.stock): \(sv1.percentSet[i])%"
                    stock3.text = "\(sv2.stock): \(sv2.percentSet[i])%"
                }
                
                monthIndicator.text = Set1.month[i]
                
                switch Set1.alertCount {
                case 0:
                    break
                case 1:
                    self.stock1.frame.origin.y = 24*self.screenHeight/1334
                    self.stock2.frame.origin.y = 72*self.screenHeight/1334
                    self.stock3.frame.origin.y = 120*self.screenHeight/1334
                case 2:
                    UIView.animate(withDuration: 0.5) {
                        if self.sv.percentSetVal[i] > self.sv1.percentSetVal[i] {
                            
                            self.stock1.frame.origin.y = 24*self.screenHeight/1334
                            self.stock2.frame.origin.y = 72*self.screenHeight/1334
                            self.stock3.frame.origin.y = 120*self.screenHeight/1334
                        } else {
                            self.stock1.frame.origin.y = 72*self.screenHeight/1334
                            self.stock3.frame.origin.y = 120*self.screenHeight/1334
                            self.stock2.frame.origin.y = 24*self.screenHeight/1334
                        }
                        
                    }
                default:
                    UIView.animate(withDuration: 0.5) {
                        if self.sv.percentSetVal[i] > self.sv1.percentSetVal[i] {
                            if self.sv.percentSetVal[i] > self.sv2.percentSetVal[i] {
                                self.stock1.frame.origin.y = 24*self.screenHeight/1334
                                if self.sv1.percentSetVal[i] > self.sv2.percentSetVal[i] {
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
                            if self.sv.percentSetVal[i] > self.sv2.percentSetVal[i] {
                                self.stock1.frame.origin.y = 72*self.screenHeight/1334
                                self.stock2.frame.origin.y = 24*self.screenHeight/1334
                                self.stock3.frame.origin.y = 120*self.screenHeight/1334
                            } else {
                                self.stock1.frame.origin.y = 120*self.screenHeight/1334
                                if self.sv1.percentSetVal[i] > self.sv2.percentSetVal[i] {
                                    self.stock2.frame.origin.y = 24*self.screenHeight/1334
                                    self.stock3.frame.origin.y = 72*self.screenHeight/1334
                                } else {
                                    self.stock2.frame.origin.y = 72*self.screenHeight/1334
                                    self.stock3.frame.origin.y = 24*self.screenHeight/1334
                                }
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
        
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(DashboardViewController.updateDot), userInfo: nil, repeats: true)
        
        
    }
    
    func updateDot() {
        container2.setContentOffset(container.contentOffset, animated: false)
    }
    func runSearch() {
        
    }
    
    @objc private func alertsFunc(_ sender: UIButton) {
        menuFunc()
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
        UIApplication.shared.openURL(URL(string: "http://firetailapp.com/legal")!)
    }
    @objc private func supportFunc(_ sender: UIButton) {
        sendEmail()
    }
    @objc private func goPremiumFunc(_ sender: UIButton) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Go Premium", message: "Unlimited Alerts for $2.99", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.purchase()
            
        }
        let restoreAction = UIAlertAction(title: "Restore Purchase", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            SwiftyStoreKit.restorePurchases(atomically: true) { results in
                if results.restoreFailedProducts.count > 0 {
                    print("Restore Failed: \(results.restoreFailedProducts)")
                }
                else if results.restoredProducts.count > 0 {
                    
                    Set1.premium = true
                    //self.loadsave.savePurchase(purchase: "firetail.iap.premium")
                    self.premiumMember = true
                }
                else {
                    print("Nothing to Restore")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(restoreAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
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
        if premiumMember || alertCount < 3 || true { //hack
            self.performSegue(withIdentifier: "fromMainToAdd", sender: self)
            
        } else if !premiumMember {
            purchase()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            
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
            
            addView.newAlertTicker = "TICKER"
            addView.isSeguedFromDashboard = true
        }
    }
    
    @objc private func goToGraph() {
        self.performSegue(withIdentifier: "fromMainToGraph", sender: self)
    }
    
    func purchase(productId: String = "firetail.iap.premium") {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        activityView.alpha = 0.0
        self.view.addSubview(activityView)
        SwiftyStoreKit.purchaseProduct(productId) { result in
            switch result {
            case .success( _):
                self.premiumMember = true
                self.activityView.removeFromSuperview()
            case .error(let error):
                self.userWarning(title: "", message: "Purchase Failed: \(error)")
                print("error: \(error)")
                print("Purchase Failed: \(error)")
                self.activityView.removeFromSuperview()
            }
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UILongPressGestureRecognizer {
            return true
        } else {
            return false
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@firetailapp.com"])
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func populateAlertBars() {
        //TEST Set.weeklyAlerts = ["mon":1,"tues":2,"wed":3,"thur":10,"fri":1]
        let monday = Set1.weeklyAlerts["mon"] ?? 0
        let tuesday = Set1.weeklyAlerts["tues"] ?? 0
        let wednesday = Set1.weeklyAlerts["wed"] ?? 0
        let thursday = Set1.weeklyAlerts["thur"] ?? 0
        let friday = Set1.weeklyAlerts["fri"] ?? 0
        let sum = monday + tuesday + wednesday + thursday + friday
        if sum > 0 {
            daysOfTheWeek.alpha = 1.0
        }
        print("DOTW")
        print(Set1.weeklyAlerts)
        //need to add bars when alerts are triggered
        var i = 0
        for day in [monday,tuesday,wednesday,thursday,friday] {
            var bar = UILabel()
            if day > 1 {
                bar = UILabel(frame: CGRect(x: 93*screenWidth/750, y: 406*screenHeight/1334, width: 6*screenWidth/750, height: 74*screenHeight/1334))
                bar.backgroundColor = customColor.yellow
                view.addSubview(bar)
            } else if day == 1 {
                bar = UILabel(frame: CGRect(x: 93*screenWidth/750, y: 446*screenHeight/1334, width: 6*screenWidth/750, height: 34*screenHeight/1334))
                bar.backgroundColor = customColor.yellow
                view.addSubview(bar)
            }
            switch i {
            case 1:
                bar.frame.origin.x += 35*screenWidth/750
            case 2:
                bar.frame.origin.x += 69*screenWidth/750
            case 3:
                bar.frame.origin.x += 104*screenWidth/750
            case 4:
                bar.frame.origin.x += 134*screenWidth/750
            default:
                break
            }
            i += 1
        }
        
    }
    
}
