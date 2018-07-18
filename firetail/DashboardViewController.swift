//
//  MainViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//
// OR DASHBOARD VIEWCONTROLLER

import UIKit

import SwiftyStoreKit
import StoreKit
import MessageUI
import Firebase
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import QuartzCore
import ReachabilitySwift

let widthScalar = UIScreen.main.bounds.width/375
let heightScalar = UIScreen.main.bounds.height/667
let commonScalar = UIScreen.main.bounds.width/375

class DashboardViewController: ViewSetup, UITextFieldDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, UIGestureRecognizerDelegate {
    var collectionView: AlertCollectionView?
    var alertsForCollectionView: [String] = []
    var activityView = UIActivityIndicatorView()
    var premiumMember = false
    var addTextField = UITextField()
    var stringToPass = "#@$%"
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
    
    let mask = UIView()
    var (monthIndicator,stock1,stock2,stock3) = (UILabel(), UILabel(), UILabel(), UILabel())
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
    var amountOfBlocks = Int()
    
    let loadsave = LoadSaveCoreData()
    var pan = UIPanGestureRecognizer()
    var canIScroll = true
    var myTimer2 = Timer()
    let myLoadSave = LoadSaveCoreData()
    var savedFrameOrigin = CGPoint()
    var l = 1
    var k = 10000
    var movingAlert = 9999
    
    var alertID: [String] {
        var aaa = [String]()
        for i in 0..<Set1.userAlerts.count {
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
    
    var alertPan = UIPanGestureRecognizer()
    var labelTop: CGFloat = 24*UIScreen.main.bounds.height/1334
    var labelMiddle: CGFloat = 72*UIScreen.main.bounds.height/1334
    var labelBottom: CGFloat = 120*UIScreen.main.bounds.height/1334
    let alertCollectionCellID = "alertCell"
    var doneLoadingFromFirebase = false
    var once = true
    
    func appLoading() {
        LoadSaveCoreData().loadUsername()
        Set1.premium = true //: toggle in development
        premiumMember = true  // ##TODO: turn off premium premiumMember = Set1.premium
        
        Alpha().populateSet1Month()
        
        AppLoadingData().loadUserInfoFromFirebase(firebaseUsername: Set1.username) {
            DispatchQueue.main.async {
            self.doneLoadingFromFirebase = true
            let _ = AppLoadingData.loadStockPricesFromCoreData()
            self.alertsForCollectionView = AlertSort.shared.getSortedStockAlerts()
            self.collectionView?.reloadData()
            self.compareGraphReset()
//            self.container2.setNeedsDisplay()
//            self.container2.layoutIfNeeded()
            }
        }
        
        
        Set1.flashOn = UserDefaults.standard.bool(forKey: "flashOn")
        Set1.allOn = UserDefaults.standard.bool(forKey: "allOn")
        Set1.pushOn = UserDefaults.standard.bool(forKey: "pushOn")
        Set1.emailOn = UserDefaults.standard.bool(forKey: "emailOn")
        Set1.smsOn = UserDefaults.standard.bool(forKey: "smsOn")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if once {
        appLoading()
            once = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.finishedFetchingTop3Stocks), name: NSNotification.Name(rawValue: updatedDataKey), object: nil)
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                labelTop += 30
                labelBottom += 30
                labelMiddle += 30
            }
        }
        
        if Set1.token == "none" && Set1.userAlerts.count > 0 {
            InstanceID.instanceID().instanceID { (_result, error) in
                if let result = _result {
                    Set1.token = result.token
                    Set1.saveUserInfo()
                }
            }
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {[weak self] _, _ in
                        guard let weakself = self else {return}
                        InstanceID.instanceID().instanceID { (_result, error) in
                            if let result = _result {
                                Set1.token = result.token
                                Set1.saveUserInfo()
                            }
                        }
                        
                        // Connect to FCM since connection may have failed when attempted before having a token.
                        weakself.connectToFcm()
                        
                })
                
                // For iOS 10 data message (sent via FCM)
                Messaging.messaging().delegate = self
                
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                
            }
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        
        view.backgroundColor = CustomColor.black33
        svs = [sv,sv1,sv2]
        let d = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let m = ["","JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"]
        addLabel(name: date, text: "\(d.day ?? 0) \(m[d.month ?? 0].capitalized)", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 13, x: 84, y: 124, width: 300, height: 32, lines: 1)
        view.addSubview(date)
        
        addLabel(name: alertAmount, text: String(Set1.userAlerts.count), textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 52, x: 84, y: 226, width: 150, height: 90, lines: 1)
        view.addSubview(alertAmount)
        addLabel(name: alerts1102, text: "Alerts", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 330, width: 260, height: 28, lines: 1)
        alerts1102.alpha = 0.5
        view.addSubview(alerts1102)
        addLabel(name: daysOfTheWeek, text: "M  T  W  T  F", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 506, width: 260, height: 28, lines: 1)
        view.addSubview(daysOfTheWeek)
        daysOfTheWeek.alpha = 0.0
        populateAlertBars()
        addButton(name: alerts, x: 82, y: 655, width: 280, height: 75, title: "ALERTS", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.alertsFunc(_:)), addSubview: true)
        addButton(name: changeEmail, x: 82, y: 735, width: 280, height: 75, title: "SETTINGS", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.changeEmailFunc(_:)), addSubview: true)
        addButton(name: addPhone, x: 82, y: 815, width: 280, height: 75, title: "BROKER", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.addPhoneFunc(_:)), addSubview: true)
        addButton(name: changeBroker, x: 82, y: 895, width: 280, height: 75, title: "LOGOUT", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.logoutFunc(_:)), addSubview: true)
        addButton(name: legal, x: 82, y: 1055, width: 280, height: 75, title: "LEGAL", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.legalFunc(_:)), addSubview: true)
        addButton(name: support, x: 82, y: 1135, width: 280, height: 75, title: "SUPPORT", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.supportFunc(_:)), addSubview: true)
        addButton(name: goPremium, x: 82, y: 1215, width: 280, height: 75, title: "GO PREMIUM", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.goPremiumFunc(_:)), addSubview: true)
        if Set1.premium == true {
            goPremium.setTitle("PREMIUM MEMBER", for: .normal)
        }
        let indicator = UILabel(frame: CGRect(x: 267*screenWidth/375, y: 86*screenHeight/667, width: (indicatorDotWidth - 30)*screenWidth/375, height: 258*screenHeight/667))
        indicator.backgroundColor = CustomColor.white77
        slideView.addSubview(indicator)
        container.frame = CGRect(x: 0, y: 86*screenHeight/667, width: screenWidth, height: 259*screenHeight/667)
        slideView.addSubview(container)
        container.delegate = self
        
        container2.frame = CGRect(x: 267*screenWidth/375, y: 86*screenHeight/667, width: (indicatorDotWidth - 30)*screenWidth/375, height: 258*screenHeight/667)
        container2.isUserInteractionEnabled = false
        container2.contentSize = CGSize(width: 2.5*11*screenWidth/5, height: 259*screenHeight/667)
        slideView.addSubview(container2)
        
        container.contentSize = CGSize(width: 2.5*11*screenWidth/5, height: 259*screenHeight/667)
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        addLabel(name: monthIndicator, text: Set1.month[1], textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 400, y: 726, width: 276, height: 30, lines: 1)
        
        addLabel(name: stock1, text: "", textColor: CustomColor.white68, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 200, y: 0, width: 352, height: 48, lines: 0)
        addLabel(name: stock2, text: "", textColor: CustomColor.white128, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 200, y: 0, width: 352, height: 48, lines: 0)
        addLabel(name: stock3, text: "", textColor: CustomColor.white209, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 200, y: 0, width: 352, height: 48, lines: 0)
        stock1.frame.origin.y = labelTop
        stock2.frame.origin.y = labelMiddle
        stock3.frame.origin.y = labelBottom
        switch sv.percentSet.count {
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
        slideView.backgroundColor = CustomColor.black33
        
        for i in 0...4 {
            let line = UIView()
            line.backgroundColor = .white
            line.alpha = 0.05
            line.frame.size = CGSize(width: screenWidth/375, height: 260*screenHeight/667)
            line.frame.origin.y = 84*screenHeight/667
            line.frame.origin.x = 27*screenWidth/375 + CGFloat(i)*80*screenWidth/375
            slideView.addSubview(line)
        }
        
        addTextField = UITextField(frame: CGRect(x: 0,y: 200,width: screenWidth ,height: 200*screenHeight/1334))
        addTextField.placeholder = "   Enter Ticker"
        addTextField.setValue(CustomColor.white68, forKeyPath: "_placeholderLabel.textColor")
        addTextField.font = UIFont.systemFont(ofSize: 25)
        addTextField.autocorrectionType = UITextAutocorrectionType.no
        addTextField.keyboardType = UIKeyboardType.default
        addTextField.returnKeyType = UIReturnKeyType.done
        
        addTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        addTextField.delegate = self
        addTextField.backgroundColor = CustomColor.background
        addTextField.textColor = CustomColor.white68
        addTextField.alpha = 0
        addTextField.tag = 1
        addTextField.keyboardAppearance = .dark
        
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
        line.backgroundColor = CustomColor.alertLines
        slideView.addSubview(line)
        slideView.layer.shadowColor = UIColor.black.cgColor
        slideView.layer.shadowOpacity = 1
        slideView.layer.shadowOffset = CGSize.zero
        slideView.layer.shadowRadius = 10
        returnTap = UITapGestureRecognizer(target: self, action: #selector(DashboardViewController.menuReturnFunc(_:)))
        returnPan = UIPanGestureRecognizer(target: self, action: #selector(DashboardViewController.menuReturnFunc(_:)))
        returnSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DashboardViewController.menuReturnFunc(_:)))
        
        mask.frame = container.frame
        mask.backgroundColor = CustomColor.black33
        slideView.addSubview(mask)
        //amountOfBlocks = loadsave.amount()
        amountOfBlocks = Set1.userAlerts.count
        whoseOnFirst(container)
        
        
        // START VERSION 2
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0
        let frame = CGRect(x: 0, y: 974*screenHeight/1334, width: screenWidth, height: 360*screenHeight/1334)
        collectionView = AlertCollectionView(frame: frame, collectionViewLayout: collectionLayout, delegate: self, dataSource: self, cellID: alertCollectionCellID)
        
        slideView.addSubview(collectionView!)
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressFunc(_:)))
        collectionView?.addGestureRecognizer(longPress)
        
        
        
    }
    
    var longPress = UILongPressGestureRecognizer()
    var startingLocationX = CGFloat()
    var endingLocationX = CGFloat()
    
    @objc private func finishedFetchingTop3Stocks() {
        print("finished top three")
        compareGraphReset()
    }
    
    private func compareGraphReset() {
        print("comparegraphreset")
        DispatchQueue.main.async { [weak self] in
            guard let weakself = self else {return}
            weakself.sv.removeFromSuperview()
            weakself.sv1.removeFromSuperview()
            weakself.sv2.removeFromSuperview()
            weakself.svDot.removeFromSuperview()
            weakself.svDot1.removeFromSuperview()
            weakself.svDot2.removeFromSuperview()
            weakself.populateCompareGraph()
            guard weakself.amountOfBlocks > 0 else {return}
            weakself.stock1.text = "\(weakself.sv.stock): \(weakself.sv.percentSet[1])%"
            guard weakself.amountOfBlocks > 1 else {return}
            weakself.stock2.text = "\(weakself.sv1.stock): \(weakself.sv1.percentSet[1])%"
            guard weakself.amountOfBlocks > 2 else {return}
            weakself.stock3.text = "\(weakself.sv2.stock): \(weakself.sv2.percentSet[1])%"
        }
    }
    
    
    @objc func act(blockLongName: String) {
        
        stock1.text = ""
        stock2.text = ""
        stock3.text = ""
        var tickers = [String]()
        for alert in alertsForCollectionView {
            if let alertInfo = Set1.alerts[alert] {
                tickers.append(alertInfo.ticker)
            }
        }
        Set1.tickerArray = tickers
        
        amountOfBlocks -= 1
        
        alertAmount.text = String(amountOfBlocks)
        
        loadsave.resaveUser(alerts: alertsForCollectionView)
        
        reboot()
        
        Set1.saveUserInfo()
        view.addGestureRecognizer(alertPan)
        guard amountOfBlocks > 0 else {return}
        stock1.text = "\(sv.stock): \(sv.percentSet[1])%"
        guard amountOfBlocks > 1 else {return}
        stock2.text = "\(sv1.stock): \(sv1.percentSet[1])%"
        guard amountOfBlocks > 2 else {return}
        stock3.text = "\(sv2.stock): \(sv2.percentSet[1])%"
        
        
    }
    
    var startedPan = false
    var q = Int()
    @objc private func pan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.location(in: view).y > sv.frame.maxY else {return}
        
        startedPan = true
    }
    
    var p = Int()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselectitematidnexpath")
    }
    
    func tappedCell(withAlertTicker: String) {
        stringToPass = withAlertTicker
        goToGraph()
    }
    
    @objc func reboot() {
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
        
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let weakself = self else {return}
            weakself.mask.frame.origin.x += 2.5*11*weakself.screenWidth/5; weakself.monthIndicator.alpha = 1.0; weakself.stock3.alpha = 1.0; weakself.stock2.alpha = 1.0; weakself.stock1.alpha = 1.0}
    }
    
    private func populateCompareGraph() {
        guard Set1.tickerArray.count > 0,
            let ti0 = Set1.oneYearDictionary[Set1.tickerArray[0]],
            ti0.count > 0 else {return}
        switch Set1.tickerArray.count {
        case 0:
            break
        case 1:
            
            sv =  CompareScroll(graphData: ti0, stockName: Set1.tickerArray[0], color: CustomColor.white68)
            container.addSubview(sv)
            svDot =  CompareScrollDot(graphData: ti0, stockName: Set1.tickerArray[0], color: CustomColor.white68)
            container2.addSubview(svDot)
            
        case 2:
            
            sv =  CompareScroll(graphData: ti0, stockName: Set1.tickerArray[0], color: CustomColor.white68)
            container.addSubview(sv)
            svDot =  CompareScrollDot(graphData: ti0, stockName: Set1.tickerArray[0], color: CustomColor.white68)
            container2.addSubview(svDot)
            guard Set1.tickerArray.count > 1,
                let ti1 = Set1.oneYearDictionary[Set1.tickerArray[1]],
                ti1.count > 0 else {return}
            sv1 =  CompareScroll(graphData: ti1, stockName: Set1.tickerArray[1], color: CustomColor.white128)
            container.addSubview(sv1)
            svDot1 =  CompareScrollDot(graphData: ti1, stockName: Set1.tickerArray[1], color: CustomColor.white128)
            container2.addSubview(svDot1)
            
        default:
            sv =  CompareScroll(graphData: ti0, stockName: Set1.tickerArray[0], color: CustomColor.white68)
            container.addSubview(sv)
            svDot =  CompareScrollDot(graphData: ti0, stockName: Set1.tickerArray[0], color: CustomColor.white68)
            container2.addSubview(svDot)
            guard Set1.tickerArray.count > 1,
                let ti1 = Set1.oneYearDictionary[Set1.tickerArray[1]],
                ti1.count > 0 else {return}
            sv1 =  CompareScroll(graphData: ti1, stockName: Set1.tickerArray[1], color: CustomColor.white128)
            container.addSubview(sv1)
            svDot1 =  CompareScrollDot(graphData: ti1, stockName: Set1.tickerArray[1], color: CustomColor.white128)
            container2.addSubview(svDot1)
            guard Set1.tickerArray.count > 2,
                let ti2 = Set1.oneYearDictionary[Set1.tickerArray[2]],
                ti2.count > 0 else {return}
            sv2 =  CompareScroll(graphData: ti2, stockName: Set1.tickerArray[2], color: CustomColor.white209)
            container.addSubview(sv2)
            svDot2 =  CompareScrollDot(graphData: ti2, stockName: Set1.tickerArray[2], color: CustomColor.white209)
            container2.addSubview(svDot2
                
            )
        }
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == container {
            
            container2.setContentOffset(scrollView.contentOffset, animated: false)
            
            whoseOnFirst(scrollView)
        }
        
    }
    
    
    
    @objc func whoseOnFirst(_ scrollView: UIScrollView) {
        
        for i in 0...11 {
            if scrollView.contentSize.width*CGFloat(Double(i+1)-2.3)/13...scrollView.contentSize.width*CGFloat(Double(i+1)-2.05)/13 ~= scrollView.contentOffset.x {
                var value = CGFloat()
                var value2 = CGFloat()
                var value1 = CGFloat()
                
                
                switch Set1.userAlerts.count {
                case 0:
                    break
                case 1:
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    
                    value = sv.percentSetVal[i]
                    
                case 2:
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    stock2.text = "\(sv1.stock): \(sv1.percentSet[i])%"
                    
                    value = sv.percentSetVal[i]
                    value1 = sv1.percentSetVal[i]
                    
                default:
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    stock2.text = "\(sv1.stock): \(sv1.percentSet[i])%"
                    stock3.text = "\(sv2.stock): \(sv2.percentSet[i])%"
                    
                    value = sv.percentSetVal[i]
                    value1 = sv1.percentSetVal[i]
                    value2 = sv2.percentSetVal[i]
                }
                
                monthIndicator.text = Set1.month[i]
                
                switch Set1.userAlerts.count {
                case 0:
                    break
                case 1:
                    stock1.frame.origin.y = labelTop
                    stock2.frame.origin.y = labelMiddle
                    stock3.frame.origin.y = labelBottom
                case 2:
                    UIView.animate(withDuration: 0.5) { [weak self] in
                        guard let weakself = self else {return}
                        if value > value1 {
                            
                            weakself.stock1.frame.origin.y = weakself.labelTop
                            weakself.stock2.frame.origin.y = weakself.labelMiddle
                            weakself.stock3.frame.origin.y = weakself.labelBottom
                        } else {
                            weakself.stock1.frame.origin.y = weakself.labelMiddle
                            weakself.stock3.frame.origin.y = weakself.labelBottom
                            weakself.stock2.frame.origin.y = weakself.labelTop
                        }
                        
                    }
                default:
                    UIView.animate(withDuration: 0.5) { [weak self] in
                        guard let weakself = self else {return}
                        if value > value1 {
                            if value > value2 {
                                weakself.stock1.frame.origin.y = weakself.labelTop
                                if value1 > value2 {
                                    weakself.stock2.frame.origin.y = weakself.labelMiddle
                                    weakself.stock3.frame.origin.y = weakself.labelBottom
                                } else {
                                    weakself.stock3.frame.origin.y = weakself.labelMiddle
                                    weakself.stock2.frame.origin.y = weakself.labelBottom
                                }
                            } else {
                                weakself.stock3.frame.origin.y = weakself.labelTop
                                weakself.stock1.frame.origin.y = weakself.labelMiddle
                                weakself.stock2.frame.origin.y = weakself.labelBottom
                            }
                        } else {
                            if value > value2 {
                                weakself.stock1.frame.origin.y = weakself.labelMiddle
                                weakself.stock2.frame.origin.y = weakself.labelTop
                                weakself.stock3.frame.origin.y = weakself.labelBottom
                            } else {
                                weakself.stock1.frame.origin.y = weakself.labelBottom
                                if value1 > value2 {
                                    weakself.stock2.frame.origin.y = weakself.labelTop
                                    weakself.stock3.frame.origin.y = weakself.labelMiddle
                                } else {
                                    weakself.stock2.frame.origin.y = weakself.labelMiddle
                                    weakself.stock3.frame.origin.y = weakself.labelTop
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
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let weakself = self else {return}
            weakself.mask.frame.origin.x += 2.5*11*weakself.screenWidth/5; weakself.monthIndicator.alpha = 1.0; weakself.stock3.alpha = 1.0; weakself.stock2.alpha = 1.0; weakself.stock1.alpha = 1.0}
        
        runSearch()
        
        myTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(DashboardViewController.updateDot), userInfo: nil, repeats: true)
        
        reachabilityAddNotification()
        
    }
    
    @objc func updateDot() {
        container2.setContentOffset(container.contentOffset, animated: false)
    }
    @objc func runSearch() {
        
    }
    
    @objc private func alertsFunc(_ sender: UIButton) {
        menuFunc()
    }
    @objc private func changeEmailFunc(_ sender: UIButton) {
        performSegue(withIdentifier: "fromMainToSettings", sender: self)
    }
    @objc private func addPhoneFunc(_ sender: UIButton) {
        performSegue(withIdentifier: "fromMainToSettings", sender: self)
    }
    @objc private func logoutFunc(_ sender: UIButton) {
        
        Set1.month = ["","","","","","","","","","","",""]
        Set1.currentPrice = 0.0
        Set1.yesterday = 0.0
        Set1.token = "none"
        // Set1.alertCount = 0
        Set1.oneYearDictionary.removeAll() //= ["":[0.0]]
        Set1.tickerArray.removeAll()
        Set1.phone = "none"
        Set1.email = "none"
        Set1.brokerName = "none"
        Set1.username = "none"
        Set1.fullName = "none"
        Set1.premium = false
        Set1.numOfAlerts.removeAll()
        Set1.brokerURL = "none"
        Set1.createdAt = "none"
        Set1.weeklyAlerts = ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
        Set1.userAlerts.removeAll()
        Set1.alerts.removeAll()
        
        Set1.logoutFirebase()
        performSegue(withIdentifier: "fromMainToLogin", sender: self)
    }
    @objc private func legalFunc(_ sender: UIButton) {
        if let url = URL(string: "http://firetailapp.com/legal") {
            UIApplication.shared.open(url)
        }
    }
    @objc private func supportFunc(_ sender: UIButton) {
        print("SUPPORT")
        sendEmail()
    }
    @objc private func goPremiumFunc(_ sender: UIButton) {
        // Create the alert controller
        if Set1.premium == false {
            let alertController = UIAlertController(title: "Go Premium", message: "Up to 50 Alerts for $2.99", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { [weak self] UIAlertAction in
                guard let weakself = self else {return}
                weakself.purchase()
                
            }
            let restoreAction = UIAlertAction(title: "Restore Purchase", style: UIAlertActionStyle.default) { [weak self] UIAlertAction in
                guard let weakself = self else {return}
                SwiftyStoreKit.restorePurchases(atomically: true) { results in
                    if results.restoreFailedPurchases.count > 0 {
                        print("Restore Failed: \(results.restoreFailedPurchases)")
                    }
                    else if results.restoredPurchases.count > 0 {
                        
                        Set1.premium = true
                        weakself.premiumMember = true
                        weakself.goPremium.setTitle("PREMIUM MEMBER", for: .normal)
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
            
            alertController.addAction(okAction)
            alertController.addAction(restoreAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            
            let alert = UIAlertController(title: "Premium Member", message: "You are a premium member and can add up to 100 stock price alerts", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc func menuFunc() {
        
        if slideView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let weakself = self else {return}
                weakself.slideView.frame.origin.x += 516*weakself.screenWidth/750
                
            }
            
            slideView.addGestureRecognizer(returnTap)
            slideView.addGestureRecognizer(returnSwipe)
            slideView.addGestureRecognizer(returnPan)
            container.isUserInteractionEnabled = false
            
            
        } else if slideView.frame.origin.x == 516*screenWidth/750 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let weakself = self else {return}
                weakself.slideView.frame.origin.x -= 516*weakself.screenWidth/750}
            slideView.removeGestureRecognizer(returnTap)
            slideView.removeGestureRecognizer(returnSwipe)
            slideView.removeGestureRecognizer(returnPan)
            container.isUserInteractionEnabled = true
        }
    }
    @objc func menuReturnFunc(_ gesture: UIGestureRecognizer) {
        if slideView.frame.origin.x == 516*screenWidth/750 {
            
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let weakself = self else {return}
                
                weakself.slideView.frame.origin.x -= 516*weakself.screenWidth/750
                
            }
            slideView.removeGestureRecognizer(returnTap)
            slideView.removeGestureRecognizer(returnSwipe)
            slideView.removeGestureRecognizer(returnPan)
            container.isUserInteractionEnabled = true
        }
    }
    var hitOnce = true
    @objc private func addFunc(_ sender: UIButton) {
        if hitOnce {
            hitOnce = false
          
            if (premiumMember || Set1.userAlerts.count < 3) && Set1.userAlerts.count < 100 {
                
                performSegue(withIdentifier: "fromMainToAddStockTicker", sender: self)
                
            } else if !premiumMember && Set1.userAlerts.count < 100 {
                
                purchase()
            } else {
                
                let alert = UIAlertController(title: "", message: " 50 maximum alerts reached", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            
        } else if textField.tag == 1 {
            if addTextField.text != nil && addTextField.delegate != nil {
                
                stringToPass = addTextField.text ?? ""
                performSegue(withIdentifier: "fromMainToAddStockTicker", sender: self)
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        if segue.identifier == "fromMainToGraph" {
            if let graphView: GraphViewController = segue.destination as? GraphViewController {
                graphView.passedString = stringToPass
            }
        } else if segue.identifier == "fromMainToAddStockTicker" {
            if let addView: AddStockTickerViewController = segue.destination as? AddStockTickerViewController {
                addView.newAlertTicker = "TICKER"
            }
        }
    }
    var haventSeguedToDetail = true
    var detailedTimer = Timer()
    var tryFor3Secondscount = 0
    @objc private func goToGraph() {
        
        if let prices = Set1.tenYearDictionary[stringToPass],
            prices.count > 1 {
            performSegue(withIdentifier: "fromMainToGraph", sender: self)
        }
        
    }
    
    @objc func purchase(productId: String = "firetail.iap.premium") {
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        activityView.startAnimating()
        activityView.alpha = 1.0
        view.addSubview(activityView)
        SwiftyStoreKit.purchaseProduct(productId) { [weak self] result in
            guard let weakself = self else {return}
            weakself.hitOnce = true
            switch result {
                
            case .success( _):
                weakself.premiumMember = true
                Set1.premium = true
                weakself.goPremium.setTitle("PREMIUM MEMBER", for: .normal)
                Set1.saveUserInfo()
                weakself.activityView.removeFromSuperview()
            case .error(let error):
                
                print("error: \(error)")
                print("Purchase Failed: \(error)")
                weakself.activityView.removeFromSuperview()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var mail: MFMailComposeViewController?
    @objc func sendEmail() {
        mail = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            mail?.mailComposeDelegate = self
            mail?.setToRecipients(["support@firetailapp.com"])
            present(mail!, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("send email dismiss")
        controller.dismiss(animated: true)
    }
    
    @objc func populateAlertBars() {
        
        for (key,_) in Set1.weeklyAlerts {
            Set1.weeklyAlerts[key] = 0
        }
        
        for (_,myTuple) in Set1.alerts {
            if myTuple.timestamp != 1 {
                
                let currentTimestamp = Int(Date().timeIntervalSince1970)
                let seconds = currentTimestamp - myTuple.timestamp
                let dayOfTheWeek = Date().dayNumberOfWeek() ?? 0
                let secondsInADay = 86400000
                let hour = Calendar.current.component(.hour, from: Date())
                let m = Calendar.current.component(.minute, from: Date())
                
                let secondsSinceMidnight = hour * 3600 + m * 60
                var addAlertToThisDay = Int()
                switch seconds {
                case 0..<secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek
                case secondsSinceMidnight..<(secondsInADay) + secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek - 1
                case secondsInADay + secondsSinceMidnight..<(2*secondsInADay) + secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek - 2
                case 2*secondsInADay + secondsSinceMidnight..<(3*secondsInADay) + secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek - 3
                case 3*secondsInADay + secondsSinceMidnight..<(4*secondsInADay) + secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek - 4
                case 4*secondsInADay + secondsSinceMidnight..<(5*secondsInADay) + secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek - 5
                case 5*secondsInADay + secondsSinceMidnight..<(6*secondsInADay) + secondsSinceMidnight: addAlertToThisDay = dayOfTheWeek - 6
                default: break
                }
                
                if addAlertToThisDay < 1 {
                    addAlertToThisDay += 7
                }
                switch addAlertToThisDay {
                case 2: Set1.weeklyAlerts["mon"]! += 1
                case 3: Set1.weeklyAlerts["tues"]! += 1
                case 4: Set1.weeklyAlerts["wed"]! += 1
                case 5: Set1.weeklyAlerts["thur"]! += 1
                case 6: Set1.weeklyAlerts["fri"]! += 1
                default: break
                }
                
            }
            
        }
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
        //need to add bars when alerts are triggered
        var i = 0
        for day in [monday,tuesday,wednesday,thursday,friday] {
            var bar = UILabel()
            if day > 1 {
                bar = UILabel(frame: CGRect(x: 93*screenWidth/750, y: 406*screenHeight/1334, width: 6*screenWidth/750, height: 74*screenHeight/1334))
                bar.backgroundColor = CustomColor.yellow
                view.addSubview(bar)
            } else if day == 1 {
                bar = UILabel(frame: CGRect(x: 93*screenWidth/750, y: 446*screenHeight/1334, width: 6*screenWidth/750, height: 34*screenHeight/1334))
                bar.backgroundColor = CustomColor.yellow
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
    
    @objc func connectToFcm() {
        
        // Won't connect since there is no token
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                Set1.token = result.token
            }
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                Set1.token = result.token
                Set1.saveUserInfo()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    // ##START V2
    var index: Int = 0
    
    
    
    
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AlertCellDelegate {
    
    func deleteCell(withAlert: String) {
        guard let atIndex = alertsForCollectionView.index(of: withAlert) else { return }
        guard let alertDeleting = Set1.alerts[alertsForCollectionView[atIndex]] else {print("error in deleteing"); return}
        myLoadSave.saveAlertToFirebase(username: Set1.username, ticker: alertDeleting.ticker, price: 0.0, isGreaterThan: alertDeleting.isGreaterThan, deleted: true, email: alertDeleting.email, sms: alertDeleting.sms, flash: alertDeleting.flash, urgent: alertDeleting.urgent, triggered: alertDeleting.triggered, push: alertDeleting.push, alertLongName: alertDeleting.name, priceString: alertDeleting.price) //TODO: rundandant price strings and doubles
        
        AlertSort.shared.delete(alertDeleting.name)
        alertsForCollectionView.remove(at: atIndex)
        collectionView?.deleteItems(at: [IndexPath(row: atIndex, section: 0)])
        
        alertsForCollectionView = AlertSort.shared.getSortedStockAlerts()
        act(blockLongName: alertDeleting.name)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.contentSize.height = CGFloat(alertsForCollectionView.count) * 60 * commonScalar
        return alertsForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: alertCollectionCellID, for: indexPath) as! AlertCollectionViewCell
       
        if let alert = Set1.alerts[alertsForCollectionView[indexPath.row]] {
            cell.set(alertName: alert.name, tickerText: alert.ticker, alertListText: AlertCollectionView.AlertStringList(urgent: alert.urgent, email: alert.email, sms: alert.sms, push: alert.push, flash: alert.flash), priceText: alert.price, isTriggered: alert.triggered, isGreaterThan: alert.isGreaterThan, cellIndex: indexPath.row, delegate: self)
        } else {
            print("error in collection view")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375*commonScalar, height: 60*commonScalar)
    }
    
    @objc private func longPressFunc(_ sender: UILongPressGestureRecognizer) {
        
        guard let collectionView = collectionView else { return }
        let point = sender.location(in: collectionView)
        switch sender.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: point) else {
                return
            }
            collectionView.allowScrolling = false
            _ = collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            collectionView.allowScrolling = true
            collectionView.endInteractiveMovement()
            
            
        default:
            collectionView.allowScrolling = true
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let startIndex = sourceIndexPath.row
        let endIndex = destinationIndexPath.row
        
        AlertSort.shared.moveItem(alert: alertsForCollectionView[startIndex], at: startIndex, to: endIndex)
        alertsForCollectionView = AlertSort.shared.getSortedStockAlerts()
        
    }
    
}
