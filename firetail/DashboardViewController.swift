//
//  MainViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

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
    
    internal static let shared = DashboardViewController()
    
    var collectionView: AlertCollectionView?
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
    let loadsave = LoadSaveCoreData()
    var pan = UIPanGestureRecognizer()
    var canIScroll = true
    var myTimer2 = Timer()
    let myLoadSave = LoadSaveCoreData()
    var savedFrameOrigin = CGPoint()
    var l = 1
    var k = 10000
    var movingAlert = 9999
    let premiumStar = UIImageView(image: #imageLiteral(resourceName: "star"))
    
    var alertID: [String] {
        var aaa = [String]()
        for i in 0..<UserInfo.userAlerts.count {
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
    var labelTop: CGFloat = 380*UIScreen.main.bounds.height/667
    var labelMiddle: CGFloat = 400*UIScreen.main.bounds.height/667
    var labelBottom: CGFloat = 420*UIScreen.main.bounds.height/667
    let alertCollectionCellID = "alertCell"
    var once = true
    
    func appLoading() {
        
        LoadSaveCoreData().loadUsername()
        UserInfo.premium = true //: toggle in development
        premiumMember = true  // ##TODO: turn off premium premiumMember = UserInfo.premium
        Alpha().populateUserInfoMonth()
        print("load user info from firebase")
        AppLoadingData().loadUserInfoFromFirebase(firebaseUsername: UserInfo.username) {}
        
        UserInfo.flashOn = UserDefaults.standard.bool(forKey: "flashOn")
        UserInfo.allOn = UserDefaults.standard.bool(forKey: "allOn")
        UserInfo.pushOn = UserDefaults.standard.bool(forKey: "pushOn")
        UserInfo.emailOn = UserDefaults.standard.bool(forKey: "emailOn")
        UserInfo.smsOn = UserDefaults.standard.bool(forKey: "smsOn")
        UserInfo.intelligenceOn = UserDefaults.standard.bool(forKey: "intelligenceOn")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userinfo.dashboardmodeVIEWDIDLOAD: \(UserInfo.dashboardMode)")
        if once {
        appLoading()
            once = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.finishedFetchingTop3Stocks), name: NSNotification.Name(rawValue: updatedDataKey), object: nil)
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
//                labelTop += 30
//                labelBottom += 30
//                labelMiddle += 30
            }
        }
        
        if UserInfo.token == "none" && UserInfo.userAlerts.count > 0 {
            InstanceID.instanceID().instanceID { (_result, error) in
                if let result = _result {
                    UserInfo.token = result.token
                    UserInfo.saveUserInfo()
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
                                UserInfo.token = result.token
                                UserInfo.saveUserInfo()
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
        
        addLabel(name: alertAmount, text: String(UserInfo.userAlerts.count), textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 52, x: 84, y: 226, width: 150, height: 90, lines: 1)
        view.addSubview(alertAmount)
        addLabel(name: alerts1102, text: "Alerts", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 330, width: 260, height: 28, lines: 1)
        alerts1102.alpha = 0.5
        view.addSubview(alerts1102)
        addLabel(name: daysOfTheWeek, text: "M  T  W  T  F", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 506, width: 260, height: 28, lines: 1)
        view.addSubview(daysOfTheWeek)
        daysOfTheWeek.alpha = 0.0
        populateAlertBars()
        addButton(name: alerts, x: 82, y: 655, width: 280, height: 75, title: UserInfo.vultureSubscriber ? "ALERTS" : "INTELLIGENT ALERTS", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.alertsFunc(_:)), addSubview: true)
        addButton(name: changeEmail, x: 82, y: 735, width: 280, height: 75, title: "SETTINGS", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.changeEmailFunc(_:)), addSubview: true)
        addButton(name: addPhone, x: 82, y: 815, width: 280, height: 75, title: "BROKER/EXCHANGE", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.addPhoneFunc(_:)), addSubview: true)
        addButton(name: changeBroker, x: 82, y: 895, width: 280, height: 75, title: "LOGOUT", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.logoutFunc(_:)), addSubview: true)
        addButton(name: legal, x: 82, y: 1055, width: 280, height: 75, title: "LEGAL", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.legalFunc(_:)), addSubview: true)
        addButton(name: support, x: 82, y: 1135, width: 280, height: 75, title: "SUPPORT", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.supportFunc(_:)), addSubview: true)
        addButton(name: goPremium, x: 82, y: 1215, width: 280, height: 75, title: "GO PREMIUM", font: "Roboto-Medium", fontSize: 13, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(DashboardViewController.goPremiumFunc(_:)), addSubview: true)
        view.addSubview(premiumStar)
        premiumStar.translatesAutoresizingMaskIntoConstraints = false
        premiumStar.centerYAnchor.constraint(equalTo: goPremium.centerYAnchor, constant: -1).isActive = true
        premiumStar.rightAnchor.constraint(equalTo: goPremium.leftAnchor, constant: -10).isActive = true
        
        if UserInfo.premium == true {
            goPremium.setTitle("PREMIUM", for: .normal)
            premiumStar.isHidden = false
        } else {
            premiumStar.isHidden = true
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
        addLabel(name: monthIndicator, text: UserInfo.month[1], textColor: .white, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 400, y: 726, width: 276, height: 30, lines: 1)
        
        addLabel(name: stock1, text: "", textColor: CustomColor.white68, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 300, y: 0, width: 352, height: 48, lines: 0)
        addLabel(name: stock2, text: "", textColor: CustomColor.white68, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 300, y: 0, width: 352, height: 48, lines: 0)
        addLabel(name: stock3, text: "", textColor: CustomColor.white68, textAlignment: .center, fontName: "Roboto-Medium", fontSize: 12, x: 300, y: 0, width: 352, height: 48, lines: 0)
        
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
      
        whoseOnFirst(container)
        
        configureAndAddAlertCollection()
        [stock1, stock2, stock3].forEach { $0.center.x = monthIndicator.center.x}
        configureSwitch()
        
    }
    
    func configureAndAddAlertCollection() {
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
    
    internal func refreshAlertsAndCompareGraph() {
        print("refreshalertsandcomparegraph")
        self.compareGraphReset()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.whoseOnFirst(self.container)
        })
    }
    
    @objc private func finishedFetchingTop3Stocks() {
        compareGraphReset()
    }
    
    private func compareGraphReset() {
        DispatchQueue.main.async {
            [self.sv, self.sv1, self.sv2, self.svDot, self.svDot1, self.svDot2].forEach { $0.removeFromSuperview() }
            
            self.populateCompareGraph()
            self.setStockLabels()
        }
    }
    
    
    @objc func act(blockLongName: String) {
     
        alertAmount.text = String(UserInfo.currentAlerts.count)
        
        loadsave.resaveUser(alerts: UserInfo.stockAlertsOrder + UserInfo.cryptoAlertsOrder)
        
        reboot()
        
        UserInfo.saveUserInfo()
        view.addGestureRecognizer(alertPan)
        setStockLabels()
        
        
    }
    
    private func setStockLabels() {
        
        if sv.percentSet.count > 1 {
            stock1.text = "\(sv.stock): \(sv.percentSet[1])%"
        } else {
            stock1.text = ""
        }
        if sv1.percentSet.count > 1 {
            stock2.text = "\(sv1.stock): \(sv1.percentSet[1])%"
        } else {
            stock2.text = ""
        }
        if sv2.percentSet.count > 1  {
            stock3.text = "\(sv2.stock): \(sv2.percentSet[1])%"
        } else {
            stock3.text = ""
        }
        
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
    
    var currentTickerArray: [String] {
        return UserInfo.isCryptoMode ? UserInfo.cryptoTickerArray : UserInfo.stockTickerArray
    }
    
    private func populateCompareGraph() {
        guard currentTickerArray.count > 0,
            let ti0 = UserInfo.oneYearDictionary[currentTickerArray[0]],
            ti0.count > 0 else {return}
        switch currentTickerArray.count {
        case 0:
            break
        case 1:
            
            sv =  CompareScroll(graphData: ti0, stockName: currentTickerArray[0], color: CustomColor.white68)
            container.addSubview(sv)
            svDot =  CompareScrollDot(graphData: ti0, stockName: currentTickerArray[0], color: CustomColor.white68)
            container2.addSubview(svDot)
            
        case 2:
            
            sv =  CompareScroll(graphData: ti0, stockName: currentTickerArray[0], color: CustomColor.white68)
            container.addSubview(sv)
            svDot =  CompareScrollDot(graphData: ti0, stockName: currentTickerArray[0], color: CustomColor.white68)
            container2.addSubview(svDot)
            guard currentTickerArray.count > 1,
                let ti1 = UserInfo.oneYearDictionary[currentTickerArray[1]],
                ti1.count > 0 else {return}
            sv1 =  CompareScroll(graphData: ti1, stockName: currentTickerArray[1], color: CustomColor.white128)
            container.addSubview(sv1)
            svDot1 =  CompareScrollDot(graphData: ti1, stockName: currentTickerArray[1], color: CustomColor.white128)
            container2.addSubview(svDot1)
            
        default:
            sv =  CompareScroll(graphData: ti0, stockName: currentTickerArray[0], color: CustomColor.white68)
            container.addSubview(sv)
            svDot =  CompareScrollDot(graphData: ti0, stockName: currentTickerArray[0], color: CustomColor.white68)
            container2.addSubview(svDot)
            guard currentTickerArray.count > 1,
                let ti1 = UserInfo.oneYearDictionary[currentTickerArray[1]],
                ti1.count > 0 else {return}
            sv1 =  CompareScroll(graphData: ti1, stockName: currentTickerArray[1], color: CustomColor.white128)
            container.addSubview(sv1)
            svDot1 =  CompareScrollDot(graphData: ti1, stockName: currentTickerArray[1], color: CustomColor.white128)
            container2.addSubview(svDot1)
            guard currentTickerArray.count > 2,
                let ti2 = UserInfo.oneYearDictionary[currentTickerArray[2]],
                ti2.count > 0 else {return}
            sv2 =  CompareScroll(graphData: ti2, stockName: currentTickerArray[2], color: CustomColor.white209)
            container.addSubview(sv2)
            svDot2 =  CompareScrollDot(graphData: ti2, stockName: currentTickerArray[2], color: CustomColor.white209)
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
            let offset = scrollView.contentOffset.x
            if scrollView.contentSize.width*CGFloat(Double(i+1)-2.3)/13...scrollView.contentSize.width*CGFloat(Double(i+1)-2.05)/13 ~= offset || (i == 1 && offset == 0.0) {
                var value = CGFloat()
                var value2 = CGFloat()
                var value1 = CGFloat()
                switch UserInfo.currentAlerts.count {
                case 0:
                    break
                case 1:
                    guard sv.percentSet.count > 11 else { return }
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    value = sv.percentSetVal[i]
                    
                case 2:
                    guard sv.percentSet.count > 11 else { return }
                    guard sv1.percentSet.count > 11 else { return }
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    stock2.text = "\(sv1.stock): \(sv1.percentSet[i])%"
                    
                    value = sv.percentSetVal[i]
                    value1 = sv1.percentSetVal[i]
                    
                default:
                    guard sv.percentSet.count > 11 else { return }
                    guard sv1.percentSet.count > 11 else { return }
                    guard sv2.percentSet.count > 11 else { return }
                    stock1.text = "\(sv.stock): \(sv.percentSet[i])%"
                    stock2.text = "\(sv1.stock): \(sv1.percentSet[i])%"
                    stock3.text = "\(sv2.stock): \(sv2.percentSet[i])%"
                    
                    value = sv.percentSetVal[i]
                    value1 = sv1.percentSetVal[i]
                    value2 = sv2.percentSetVal[i]
                }
                
                monthIndicator.text = UserInfo.month[i]
                
                switch UserInfo.userAlerts.count {
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
                return
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
        collectionView?.reloadData()
    }
    
    @objc func updateDot() {
        container2.setContentOffset(container.contentOffset, animated: false)
    }
    @objc func runSearch() {
        
    }
    
    @objc private func alertsFunc(_ sender: UIButton) {
        if UserInfo.vultureSubscriber {
        menuFunc()
        } else {
            present(PremiumInformationViewController(), animated: true)
        }
    }
    @objc private func changeEmailFunc(_ sender: UIButton) {
        present(SettingsViewController(), animated: true)
    }
    @objc private func addPhoneFunc(_ sender: UIButton) {
        present(SettingsViewController(), animated: true)
    }
    @objc private func logoutFunc(_ sender: UIButton) {
        
        UserInfo.month = ["","","","","","","","","","","",""]
        UserInfo.token = "none"
        UserInfo.oneYearDictionary.removeAll()
        UserInfo.tickerArray.removeAll()
        UserInfo.phone = "none"
        UserInfo.email = "none"
        UserInfo.brokerName = "none"
        UserInfo.username = "none"
        UserInfo.fullName = "none"
        UserInfo.premium = false
        UserInfo.brokerURL = "none"
        UserInfo.weeklyAlerts = ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
        UserInfo.userAlerts.removeAll()
        UserInfo.alerts.removeAll()
        DashboardViewController.shared.collectionView?.reloadData()
        try? Auth.auth().signOut()
         present(LoginViewController(), animated: true)
    }
    @objc private func legalFunc(_ sender: UIButton) {
        if let url = URL(string: "http://firetailapp.com/legal") {
            UIApplication.shared.open(url)
        }
    }
    @objc private func supportFunc(_ sender: UIButton) {
        sendEmail()
    }
    @objc private func goPremiumFunc(_ sender: UIButton) {
        // Create the alert controller
        if UserInfo.premium == false {
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
                        
                        UserInfo.premium = true
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
            
            let viewController = AddStockTickerViewController()
            viewController.modalTransitionStyle = .crossDissolve
            viewController.newAlertTicker = "TICKER"
            present(viewController, animated: true)
            
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
          
            if (premiumMember || UserInfo.userAlerts.count < 3) && UserInfo.userAlerts.count < 100 {
                let viewController = AddStockTickerViewController()
                viewController.modalTransitionStyle = .crossDissolve
                present(viewController, animated: true) {
                    self.hitOnce = true
                }
                
            } else if !premiumMember && UserInfo.userAlerts.count < 100 {
                
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
                let viewController = AddStockTickerViewController()
                viewController.newAlertTicker = "TICKER"
                present(viewController, animated: true)
            }
        }
        
        return false
    }
    
    var detailedTimer = Timer()
    var tryFor3Secondscount = 0
    @objc private func goToGraph() {
        
        if let prices = UserInfo.tenYearDictionary[stringToPass],
            prices.count > 1 {
            let viewController = GraphViewController()
            viewController.passedString = stringToPass
             present(viewController, animated: true)
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
                UserInfo.premium = true
                weakself.goPremium.setTitle("PREMIUM MEMBER", for: .normal)
                UserInfo.saveUserInfo()
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
        controller.dismiss(animated: true)
    }
    
    @objc func populateAlertBars() {
        
        for (key,_) in UserInfo.weeklyAlerts {
            UserInfo.weeklyAlerts[key] = 0
        }
        
        for (_,myTuple) in UserInfo.currentAlerts {
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
                case 2: UserInfo.weeklyAlerts["mon"]! += 1
                case 3: UserInfo.weeklyAlerts["tues"]! += 1
                case 4: UserInfo.weeklyAlerts["wed"]! += 1
                case 5: UserInfo.weeklyAlerts["thur"]! += 1
                case 6: UserInfo.weeklyAlerts["fri"]! += 1
                default: break
                }
                
            }
            
        }
        //TEST Set.weeklyAlerts = ["mon":1,"tues":2,"wed":3,"thur":10,"fri":1]
        let monday = UserInfo.weeklyAlerts["mon"] ?? 0
        let tuesday = UserInfo.weeklyAlerts["tues"] ?? 0
        let wednesday = UserInfo.weeklyAlerts["wed"] ?? 0
        let thursday = UserInfo.weeklyAlerts["thur"] ?? 0
        let friday = UserInfo.weeklyAlerts["fri"] ?? 0
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
                UserInfo.token = result.token
            }
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
                UserInfo.saveUserInfo()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toggle.layoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    var index: Int = 0
    let toggle = AlertSwitch()
    private func configureSwitch() {
        slideView.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.widthAnchor.constraint(equalToConstant: ToggleConstant.width).isActive = true
        toggle.heightAnchor.constraint(equalToConstant: ToggleConstant.height).isActive = true
        toggle.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: varyForDevice(normal: 12, iphoneX: 6)).isActive = true
        toggle.centerXAnchor.constraint(equalTo: slideView.centerXAnchor).isActive = true
        toggle.addTarget(self, action: #selector(toggleSelected), for: .valueChanged)
    }

    @objc private func toggleSelected() {
        [sv,sv2,sv1].forEach {
            $0.percentSet.removeAll()
            $0.percentSetVal.removeAll()
        }
        [stock1,stock2,stock3].forEach { $0.text = "" }
        UserInfo.dashboardMode = UserInfo.isStockMode ? .crypto : .stocks
        configureAndAddAlertCollection()
        refreshAlertsAndCompareGraph()
    }
}


extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AlertCellDelegate {
    
    func deleteCell(withAlert: String) {
        guard let atIndex = UserInfo.currentAlertsInOrder.index(of: withAlert) else { return }
        guard let alertDeleting = UserInfo.currentAlerts[UserInfo.currentAlertsInOrder[atIndex]] else {print("error in deleteing"); return}
        DispatchQueue.main.async {
            self.myLoadSave.saveAlertToFirebase(username: UserInfo.username, ticker: alertDeleting.ticker, price: 0.0, isGreaterThan: alertDeleting.isGreaterThan, deleted: true, email: alertDeleting.email, sms: alertDeleting.sms, flash: alertDeleting.flash, urgent: alertDeleting.urgent, triggered: alertDeleting.triggered, push: alertDeleting.push, alertLongName: alertDeleting.name, priceString: alertDeleting.price) //TODO: rundandant price strings and doubles
            UserInfo.alerts.removeValue(forKey: withAlert)
            UserInfo.currentAlertsInOrder.remove(at: atIndex)
            
            self.collectionView?.deleteItems(at: [IndexPath(row: atIndex, section: 0)])
            
            UserInfo.populateAlertsWithOrder()
            self.act(blockLongName: alertDeleting.name)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionviewnumberofitems")
        print("userinfo: \(UserInfo.dashboardMode)")
        print("current: \(UserInfo.currentAlerts)")
        let amount = UserInfo.currentAlerts.count
        collectionView.contentSize.height = CGFloat(amount) * 60 * commonScalar
        return amount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: alertCollectionCellID, for: indexPath) as! AlertCollectionViewCell
        if UserInfo.currentAlertsInOrder.count > indexPath.row {
            if let alert = UserInfo.currentAlerts[UserInfo.currentAlertsInOrder[indexPath.row]] {
                cell.set(alertName: alert.name, tickerText: alert.ticker, alertListText: AlertCollectionView.AlertStringList(urgent: alert.urgent, email: alert.email, sms: alert.sms, push: alert.push, flash: alert.flash), priceText: alert.price, isTriggered: alert.triggered, isGreaterThan: alert.isGreaterThan, cellIndex: indexPath.row, delegate: self)
            } else {
                print("error in collection view")
            }
        } else {
            print("ERROR: UserInfo.currentAlertsInOrder.count > indexPath.row")
            print(indexPath.row)
            print(UserInfo.currentAlertsInOrder)
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
        
        UserInfo.currentAlertsInOrder = rearrange(array:UserInfo.currentAlertsInOrder, at: sourceIndexPath.row, to: destinationIndexPath.row)
        
        UserInfo.populateAlertsWithOrder()
        collectionView.reloadData()
        container.contentOffset.x = 0
    }
    
}

internal func rearrange<T>(array: Array<T>, at: Int, to: Int) -> Array<T> {
    var arr = array
    let element = arr.remove(at: at)
    arr.insert(element, at: to)
    
    return arr
}

internal func varyForDevice<T>(normal: T, iphoneX: T) -> T {
    return UIScreen.main.bounds.height == 812 ? iphoneX : normal
}
