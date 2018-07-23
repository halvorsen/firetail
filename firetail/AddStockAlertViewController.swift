//
//  AddStockAlertViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import UserNotifications
import QuartzCore
import Firebase
import FirebaseMessaging
import FirebaseAuth
import ReachabilitySwift

class AddStockAlertViewController: ViewSetup, UITextFieldDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, UIApplicationDelegate {
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
                UserInfo.saveUserInfo()
            }
        }
    }
    let backArrow = UIButton()
    var newAlertTicker = String()
    var newAlertPrice = Double()
    var newAlertTickerLabel = UILabel()
    var newAlertPriceLabel = UILabel()
    let priceAlert = UILabel()
    let stockSymbol = UILabel()
    var addAlert = UIButton()
    let myLoadSave = LoadSaveCoreData()
    var newAlertBoolTuple = (email: false, sms: false, push: false, flash: false, all: false, intelligent: false)
    var lastPrice = Double()
    var newAlertLongID = String()
    var alertID: [String] {
        var aaa = [String]()
        for i in 0...UserInfo.userAlerts.count {
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
    
    var priceString = String()
    let (mySwitchIntelligent,mySwitchEmail,mySwitchSMS,mySwitchPush,mySwitchFlash,mySwitchAll) = (UISwitch(),UISwitch(),UISwitch(),UISwitch(),UISwitch(),UISwitch())
    
    override func viewWillAppear(_ animated: Bool) {
        // UserInfo.cachedInThisSession.append(newAlertTicker)
        if newAlertPrice < 0.00 {
            newAlertPriceLabel.text = "$0.00"
            
        } else if newAlertPrice < 5.00 {
            newAlertPriceLabel.text = "$" + String(format: "%.2f", newAlertPrice)
            
        } else if newAlertPrice > 2000.0 {
            newAlertPriceLabel.text = "$2000"
            
        } else {
            newAlertPriceLabel.text = "$" + String(format: "%.1f", newAlertPrice) + "0"
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColor.black24
        
        addLabel(name: priceAlert, text: "price alert", textColor: CustomColor.white115, textAlignment: .right, fontName: "Roboto-Regular", fontSize: 15, x: 490, y: 234, width: 200, height: 48, lines: 1)
        view.addSubview(priceAlert)
        
        addLabel(name: newAlertPriceLabel, text: "", textColor: .white, textAlignment: .right, fontName: "DroidSerif", fontSize: 20, x: 490, y: 162, width: 200, height: 56, lines: 1)
        view.addSubview(newAlertPriceLabel)
        
        addLabel(name: stockSymbol, text: "symbol", textColor: CustomColor.white115, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 54, y: 234, width: 240, height: 48, lines: 1)
        view.addSubview(stockSymbol)
        
        addLabel(name: newAlertTickerLabel, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "DroidSerif", fontSize: 20, x: 54, y: 162, width: 200, height: 56, lines: 1)
        view.addSubview(newAlertTickerLabel)
        
        addButton(name: addAlert, x: 0, y: 1194, width: 750, height: 140, title: "ADD ALERT", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockAlertViewController.add(_:)), addSubview: true)
        addAlert.contentHorizontalAlignment = .center
        
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockAlertViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        let name = UserInfo.isStockMode ? ["Email","SMS","Push","Flash","All"] : ["Intelligent", "Email","SMS","Push","Flash","All"]
        for i in 0..<name.count {
            let label = UILabel()
            
            addLabel(name: label, text: name[i].uppercased(), textColor: .white, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 15, x: 200, y: 434 + CGFloat(i)*120, width: 300, height: 56, lines: 0)
            view.addSubview(label)
        }
        
        let switches:[(UISwitch,CGFloat,Int)] = [
            
            (mySwitchIntelligent,215,5), //59
            (mySwitchEmail,UserInfo.isCryptoMode ? 275 : 215,0),
            (mySwitchSMS,UserInfo.isCryptoMode ? 335 : 275,1),
            (mySwitchPush,UserInfo.isCryptoMode ? 395 : 335,2),
            (mySwitchFlash,UserInfo.isCryptoMode ? 455 : 395,3),
            (mySwitchAll,UserInfo.isCryptoMode ? 515 : 455,4)
            
            ]
        
        for (mySwitch, yPosition, tag) in UserInfo.isCryptoMode ? switches : Array(switches[1...]) {
            
            mySwitch.frame = CGRect(x: 27*screenWidth/375, y: yPosition*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
            mySwitch.setOn(false, animated: false)
            mySwitch.tintColor = CustomColor.white229
            mySwitch.layer.cornerRadius = 16
            mySwitch.backgroundColor = .white
            mySwitch.onTintColor = CustomColor.yellow
            mySwitch.addTarget(self, action: #selector(AddStockAlertViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
            mySwitch.tag = tag
            view.addSubview(mySwitch)
            
        }
        if UserInfo.intelligenceOn {
            mySwitchIntelligent.setOn(true, animated: false)
            newAlertBoolTuple.5 = true
        }
        
        if UserInfo.flashOn {
            mySwitchFlash.setOn(true, animated: false)
            newAlertBoolTuple.3 = true
        }
        if UserInfo.smsOn {
            mySwitchSMS.setOn(true, animated: false)
            newAlertBoolTuple.1 = true
        }
        if UserInfo.emailOn {
            mySwitchEmail.setOn(true, animated: false)
            newAlertBoolTuple.0 = true
        }
        if UserInfo.pushOn {
            mySwitchPush.setOn(true, animated: false)
            newAlertBoolTuple.2 = true
        }
        if UserInfo.allOn {
            mySwitchAll.setOn(true, animated: false)
            newAlertBoolTuple.4 = true
        }
        
    }
    
    
    
    @objc private func add(_ button: UIButton) {
        
        UserInfo.tickerArray = [newAlertTicker] + UserInfo.tickerArray
        let finalAlertPrice = newAlertPrice
        
        let timestamp = String(Int(Date().timeIntervalSince1970 * 10000))
        newAlertLongID =  timestamp + newAlertTicker.uppercased()
        UserInfo.currentAlertsInOrder = [newAlertLongID] + UserInfo.currentAlertsInOrder
        UserInfo.userAlerts[alertID[UserInfo.userAlerts.count]] = newAlertLongID
      
        var alertTriggerWhenGreaterThan = false
        if finalAlertPrice > lastPrice {
            alertTriggerWhenGreaterThan = true
        }
        if !newAlertBoolTuple.1 && !newAlertBoolTuple.0 && !newAlertBoolTuple.2 && !newAlertBoolTuple.3 && !newAlertBoolTuple.4 {
            UserInfo.alerts[newAlertLongID] = (newAlertLongID, alertTriggerWhenGreaterThan, priceString, false, true, false, false, newAlertTicker, "false", false, false, 1)
            
        }
        else {
            UserInfo.alerts[newAlertLongID] = (newAlertLongID, alertTriggerWhenGreaterThan, priceString, false, newAlertBoolTuple.0, newAlertBoolTuple.3, newAlertBoolTuple.1, newAlertTicker, "false", newAlertBoolTuple.2, newAlertBoolTuple.4, 1)
        }

        UserInfo.populateAlertsWithOrder()

        DashboardViewController.shared.configureAndAddAlertCollection()
        DashboardViewController.shared.container.contentOffset.x = 0.0
        let intelligentFlag = newAlertBoolTuple.intelligent ? "intelligent" : ""
        if !newAlertBoolTuple.1 && !newAlertBoolTuple.0 && !newAlertBoolTuple.2 && !newAlertBoolTuple.3 && !newAlertBoolTuple.4 && !newAlertBoolTuple.5 {
            myLoadSave.saveAlertToFirebase(username: UserInfo.username, ticker: newAlertTicker, price: finalAlertPrice, isGreaterThan: alertTriggerWhenGreaterThan, deleted: false, email: true, sms: false, flash: false, urgent: false, triggered: "false", push: false, alertLongName: newAlertLongID, priceString: priceString, data3: intelligentFlag)
        } else if newAlertBoolTuple.1 {
            myLoadSave.saveAlertToFirebase(username: UserInfo.username, ticker: newAlertTicker, price: finalAlertPrice, isGreaterThan: alertTriggerWhenGreaterThan, deleted: false, email: newAlertBoolTuple.0, sms: newAlertBoolTuple.1, flash: newAlertBoolTuple.3, urgent: newAlertBoolTuple.4, triggered: "false", push: newAlertBoolTuple.2, alertLongName: newAlertLongID, priceString: priceString, data2: UserInfo.phone, data3: intelligentFlag)
        } else {
            myLoadSave.saveAlertToFirebase(username: UserInfo.username, ticker: newAlertTicker, price: finalAlertPrice, isGreaterThan: alertTriggerWhenGreaterThan, deleted: false, email: newAlertBoolTuple.0, sms: newAlertBoolTuple.1, flash: newAlertBoolTuple.3, urgent: newAlertBoolTuple.4, triggered: "false", push: newAlertBoolTuple.2, alertLongName: newAlertLongID, priceString: priceString, data3: intelligentFlag)
        }
        UserInfo.saveUserInfo()
        alertInfo = (UserInfo.username,newAlertTicker,finalAlertPrice,alertTriggerWhenGreaterThan,false,newAlertBoolTuple.0,newAlertBoolTuple.1,newAlertBoolTuple.3,newAlertBoolTuple.4,"false",newAlertBoolTuple.2,newAlertLongID,priceString)
        if mySwitchSMS.isOn == true && UserInfo.phone == "none" {
            let viewController = AddPhoneNumberViewController()
            viewController.alertInfo = alertInfo
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true)
        } else {
            if let first = presentingViewController,
                let second = first.presentingViewController,
                let third = second.presentingViewController {
                
                second.view.isHidden = true
                first.view.isHidden = true
                third.dismiss(animated: true)
                
            }
        }
        
    }
    var alertInfo = (String(),String(),Double(),Bool(),Bool(),Bool(),Bool(),Bool(),Bool(),String(),Bool(),String(),String())
    
    @objc private func back(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
    
    private func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    
                    InstanceID.instanceID().instanceID { (_result, error) in
                        if let result = _result {
                            UserInfo.token = result.token
                            UserInfo.saveUserInfo()
                        }
                    }
                    
                    // Connect to FCM since connection may have failed when attempted before having a token.
                    self.connectToFcm()
                    
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
    
    @objc private func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            switch sender.tag {
            case 0:
                newAlertBoolTuple.0 = true
                UserDefaults.standard.set(true, forKey: "emailOn")
                UserInfo.emailOn = true
            case 1:
                
                newAlertBoolTuple.1 = true
                UserDefaults.standard.set(true, forKey: "smsOn")
                UserInfo.smsOn = true
            case 2:
                newAlertBoolTuple.2 = true
                registerForPushNotifications()
                UserDefaults.standard.set(true, forKey: "pushOn")
                UserInfo.pushOn = true
            case 3:
                newAlertBoolTuple.3 = true
                registerForPushNotifications()
                UserDefaults.standard.set(true, forKey: "flashOn")
                UserInfo.flashOn = true
                userWarning(title: "Flash Alert", message: "Go to Settings > General > Accessibility. Scroll down to LED Flash for Alerts.")
                
            case 4:
                
                registerForPushNotifications()
                newAlertBoolTuple.4 = true
                UserDefaults.standard.set(true, forKey: "allOn")
                UserInfo.allOn = true
                
                newAlertBoolTuple.0 = true
                UserDefaults.standard.set(true, forKey: "emailOn")
                UserInfo.emailOn = true
                
                newAlertBoolTuple.1 = true
                
                UserDefaults.standard.set(true, forKey: "smsOn")
                UserInfo.smsOn = true
                
                newAlertBoolTuple.2 = true
                registerForPushNotifications()
                UserDefaults.standard.set(true, forKey: "pushOn")
                UserInfo.pushOn = true
                
                newAlertBoolTuple.3 = true
                registerForPushNotifications()
                UserDefaults.standard.set(true, forKey: "flashOn")
                UserInfo.flashOn = true
                
                mySwitchEmail.setOn(true, animated: true)
                mySwitchSMS.setOn(true, animated: true)
                mySwitchPush.setOn(true, animated: true)
                mySwitchFlash.setOn(true, animated: true)
                if UserInfo.dashboardMode == .crypto {
                    if UserInfo.vultureSubscriber {
                        newAlertBoolTuple.5 = true
                        UserDefaults.standard.set(true, forKey: "intelligenceOn")
                        UserInfo.intelligenceOn = true
                    } else {
                        present(PremiumInformationViewController(), animated: true)
                        newAlertBoolTuple.4 = false
                        UserDefaults.standard.set(false, forKey: "allOn")
                        UserInfo.allOn = false
                    }
                }
                
            case 5:
                if UserInfo.vultureSubscriber {
                newAlertBoolTuple.5 = true
                UserDefaults.standard.set(true, forKey: "intelligenceOn")
                UserInfo.intelligenceOn = true
                } else {
                    present(PremiumInformationViewController(), animated: true)
                }
                
            default:
                break
            }
        } else {
            switch sender.tag {
            case 0:
                newAlertBoolTuple.0 = false
                UserDefaults.standard.set(false, forKey: "emailOn")
                UserInfo.emailOn = false
                if UserInfo.allOn {
                    UserDefaults.standard.set(false, forKey: "allOn")
                    UserInfo.allOn = false
                    newAlertBoolTuple.4 = false
                    mySwitchAll.setOn(false, animated: true)
                    
                }
            case 1:
                newAlertBoolTuple.1 = false
                UserDefaults.standard.set(false, forKey: "smsOn")
                UserInfo.smsOn = false
                if UserInfo.allOn {
                    UserDefaults.standard.set(false, forKey: "allOn")
                    UserInfo.allOn = false
                    newAlertBoolTuple.4 = false
                    mySwitchAll.setOn(false, animated: true)
                }
            case 2:
                UserDefaults.standard.set(false, forKey: "pushOn")
                UserInfo.pushOn = false
                newAlertBoolTuple.2 = false
                if UserInfo.allOn {
                    UserDefaults.standard.set(false, forKey: "allOn")
                    UserInfo.allOn = false
                    newAlertBoolTuple.4 = false
                    mySwitchAll.setOn(false, animated: true)
                }
            case 3:
                UserDefaults.standard.set(false, forKey: "flashOn")
                UserInfo.flashOn = false
                newAlertBoolTuple.3 = false
                if UserInfo.allOn {
                    UserDefaults.standard.set(false, forKey: "allOn")
                    UserInfo.allOn = false
                    newAlertBoolTuple.4 = false
                    mySwitchAll.setOn(false, animated: true)
                }
            case 4:
                UserDefaults.standard.set(false, forKey: "allOn")
                UserInfo.allOn = false
                newAlertBoolTuple.4 = false
            default:
                break
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let myText = textField.text else {return false}
        let newString = (myText as NSString).replacingCharacters(in: range, with: string)
        let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
            let newLength = (myText as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        textField.text = formattedString as String
        return false
    }
    
    @objc func connectToFcm() {
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}
