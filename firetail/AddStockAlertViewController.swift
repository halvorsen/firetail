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

class AddStockAlertViewController: ViewSetup, UITextFieldDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, UIApplicationDelegate {
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //FIXIT
        //code
    }
    let backArrow = UIButton()
    var newAlertTicker = String()
    var newAlertPrice = Double()
    var customColor = CustomColor()
    var newAlertTickerLabel = UILabel()
    var newAlertPriceLabel = UILabel()
    let priceAlert = UILabel()
    let stockSymbol = UILabel()
    var addAlert = UIButton()
    let myLoadSave = LoadSaveCoreData()
    var newAlertBoolTuple = (false, false, false, false, false)
    var lastPrice = Double()
    var newAlertLongID = String()
    var alertID: [String] {
        var aaa = [String]()
        for i in 0...Set1.alertCount {
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
    var phoneTextField = UITextField()
    override func viewWillAppear(_ animated: Bool) {
        
        if newAlertPrice < 0.00 {
            newAlertPriceLabel.text = "$0.00"
           
        } else if newAlertPrice < 5.00 {
            newAlertPriceLabel.text = "$" + String(format: "%.2f", newAlertPrice)
           
        } else if newAlertPrice > 2000.0 {
            newAlertPriceLabel.text = "$2000"
           
        } else {
            newAlertPriceLabel.text = "$" + String(format: "%.1f", newAlertPrice) + "0"
         
        }
        
        
        getOneYearData(stockName: newAlertTicker) {
            
            Set1.oneYearDictionary[$1] = $0
            
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customColor.black24
        
        addLabel(name: priceAlert, text: "price alert", textColor: customColor.white115, textAlignment: .right, fontName: "Roboto-Italic", fontSize: 15, x: 490, y: 234, width: 200, height: 48, lines: 1)
        view.addSubview(priceAlert)
        
        addLabel(name: newAlertPriceLabel, text: "", textColor: .white, textAlignment: .right, fontName: "DroidSerif-Regular", fontSize: 20, x: 490, y: 162, width: 200, height: 56, lines: 1)
        view.addSubview(newAlertPriceLabel)
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 54, y: 234, width: 240, height: 48, lines: 1)
        view.addSubview(stockSymbol)
        
        addLabel(name: newAlertTickerLabel, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "DroidSerif-Regular", fontSize: 20, x: 54, y: 162, width: 200, height: 56, lines: 1)
        view.addSubview(newAlertTickerLabel)
        
        addButton(name: addAlert, x: 0, y: 1194, width: 750, height: 140, title: "ADD ALERT", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .black, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockAlertViewController.add(_:)), addSubview: true)
        addAlert.contentHorizontalAlignment = .center
        
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockAlertViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        
        for i in 0...4 {
            let l = UILabel()
            let name = ["Email","SMS","Push","Flash","All"]
            addLabel(name: l, text: name[i].uppercased(), textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 16, x: 200, y: 460 + CGFloat(i)*122, width: 150, height: 56, lines: 0)
            view.addSubview(l)
        }
        let (mySwitchEmail,mySwitchSMS,mySwitchPush,mySwitchFlash,mySwitchAll) = (UISwitch(),UISwitch(),UISwitch(),UISwitch(),UISwitch())
        
        let switches:[(UISwitch,CGFloat,Int)] = [
        
        (mySwitchEmail,227,0),
        (mySwitchSMS,286,1),
        (mySwitchPush,347,2),
        (mySwitchFlash,406,3),
        (mySwitchAll,466,4),
        
        ]
        
        for (s, y, tag) in switches {
       
        s.frame = CGRect(x: 27*screenWidth/375, y: y*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        s.setOn(false, animated: false)
        s.tintColor = customColor.white229
        s.layer.cornerRadius = 16
        s.backgroundColor = .white
        s.onTintColor = customColor.yellow
        s.addTarget(self, action: #selector(AddStockAlertViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        s.tag = tag
        view.addSubview(s)
            
        }
        
        
        phoneTextField = UITextField(frame: CGRect(x: 375*screenWidth/750,y: 800*screenHeight/1334,width: 375*screenWidth/750 ,height: 80*screenHeight/1334))
        phoneTextField.placeholder = "(000) 000-0000"
        phoneTextField.textAlignment = .left
        phoneTextField.clearsOnBeginEditing = true
        phoneTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        phoneTextField.font = UIFont(name: "Roboto-Medium", size: 20*fontSizeMultiplier)
        phoneTextField.autocorrectionType = UITextAutocorrectionType.no
        phoneTextField.keyboardType = UIKeyboardType.default
        phoneTextField.returnKeyType = UIReturnKeyType.done
        phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        phoneTextField.delegate = self
        phoneTextField.backgroundColor = .clear
        phoneTextField.textColor = .white
        phoneTextField.tag = 2
        phoneTextField.keyboardAppearance = .dark
        view.addSubview(phoneTextField)
        phoneTextField.alpha = 0.0
        
    }
    
    @objc private func addAlertFunc(_ sender: UIButton) {
     
        self.performSegue(withIdentifier: "fromAddStockAlertToDashboard", sender: self)
    }
    
    @objc private func add(_ button: UIButton) {
        
        Set1.ti.append(newAlertTicker)
        let finalAlertPrice = newAlertPrice
        
        let timestamp = String(Int(Date().timeIntervalSince1970 * 10000))
        newAlertLongID = newAlertTicker.uppercased() + timestamp
        Set1.userAlerts[alertID[Set1.alertCount]] = newAlertLongID
        Set1.alertCount += 1
        if !newAlertBoolTuple.1 && !newAlertBoolTuple.0 && !newAlertBoolTuple.2 && !newAlertBoolTuple.3 && !newAlertBoolTuple.4 {
            Set1.alerts[newAlertLongID] = (newAlertLongID, newAlertPrice > lastPrice, newAlertPrice, false, true, false, false, newAlertTicker, false, false, false) }
        else {
            Set1.alerts[newAlertLongID] = (newAlertLongID, newAlertPrice > lastPrice, newAlertPrice, false, newAlertBoolTuple.0, newAlertBoolTuple.3, newAlertBoolTuple.1, newAlertTicker, false, newAlertBoolTuple.2, newAlertBoolTuple.4)
        }
        var alertTriggerWhenGreaterThan = false
        if finalAlertPrice > lastPrice {
            alertTriggerWhenGreaterThan = true
        }
  
        if !newAlertBoolTuple.1 && !newAlertBoolTuple.0 && !newAlertBoolTuple.2 && !newAlertBoolTuple.3 && !newAlertBoolTuple.4 {
            myLoadSave.saveAlertToFirebase(username: Set1.username, ticker: newAlertTicker, price: finalAlertPrice, isGreaterThan: alertTriggerWhenGreaterThan, deleted: false, email: true, sms: false, flash: false, urgent: false, triggered: "false", push: false, alertLongName: newAlertLongID, priceString: newAlertPriceLabel.text!)
        } else {
            myLoadSave.saveAlertToFirebase(username: Set1.username, ticker: newAlertTicker, price: finalAlertPrice, isGreaterThan: alertTriggerWhenGreaterThan, deleted: false, email: newAlertBoolTuple.0, sms: newAlertBoolTuple.1, flash: newAlertBoolTuple.3, urgent: newAlertBoolTuple.4, triggered: "false", push: newAlertBoolTuple.2, alertLongName: newAlertLongID, priceString: newAlertPriceLabel.text!)
        }
        
        self.performSegue(withIdentifier: "fromAddStockAlertToDashboard", sender: self)
        
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockAlertToDashboard", sender: self)
    }
    
    private func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
            
                    if let refreshedToken = InstanceID.instanceID().token() {
                        print("InstanceID token: \(refreshedToken)")
                        Set1.token = refreshedToken
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
    
    @objc private func switchChanged(_ sender: UISwitch!) {
        if sender.isOn {
            switch sender.tag {
            case 0:
                newAlertBoolTuple.0 = true
            case 1:
                if Set1.phone == "none" {
                    phoneTextField.alpha = 1.0
                    phoneTextField.becomeFirstResponder()
                } else {
                    newAlertBoolTuple.1 = true
                }
            case 2:
                newAlertBoolTuple.2 = true
                registerForPushNotifications()
            case 3:
                newAlertBoolTuple.3 = true
                
            case 4:
                newAlertBoolTuple.4 = true
                registerForPushNotifications()
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
            case 4:
                newAlertBoolTuple.4 = false
            default:
                break
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneTextField.alpha = 0.0
        if phoneTextField.text != nil {
            Set1.phone = phoneTextField.text!
        }
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        phoneTextField.alpha = 0.0
    }
    
    func connectToFcm() {
        
    // Won't connect since there is no token
    guard InstanceID.instanceID().token() != nil else {
    return
    }
    
    // Disconnect previous FCM connection if it exists.
    Messaging.messaging().disconnect()
    
    Messaging.messaging().connect { (error) in
    if error != nil {
    print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
    } else {
    print("Connected to FCM.")
    }
    }
    }
}
