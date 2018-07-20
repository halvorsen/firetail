//
//  SignupViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import MessageUI
import ReachabilitySwift

class SettingsViewController: ViewSetup, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
  
    var continueB = UIButton()
    var getSupport = UIButton()
    var accountSettings = UILabel()
    var myTextFields = [UITextField]()
    var doneLoading = false
    var backArrow = UIButton()
    var myPicker = UIPickerView()
    let toolBar = UIToolbar()
    let myPickerBackground = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    let toolBarButtonColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
    let toolBarColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
    let pickerData = ["TD Ameritrade", "Chase", "Etrade", "Fidelity", "Scottrade", "Schwab", "Merrill Edge", "Trademonster", "Capital One Investing", "eOption", "Interactive Brokers", "TradeStation", "Ally", "Kapitall", "Lightspeed", "optionsXpress", "Zacks", "Trade King", "Sogo Trade", "Trading Block", "USAA", "Bank of America", "Vangaurd", "Wells Fargo", "Firstrade", "Robinhood"]
    
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        view.backgroundColor = CustomColor.black33
        let logo = UIImageView(frame: CGRect(x: 29*screenWidth/375, y: 75*screenHeight/667, width: 50*screenWidth/375, height: 64*screenWidth/375))
        logo.image = #imageLiteral(resourceName: "logo50x64")
        view.addSubview(logo)
        
        addButton(name: continueB, x: 0, y: 1194, width: 750, height: 140, title: "SAVE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: CustomColor.black42, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SettingsViewController.saveFunc(_:)), addSubview: true, alignment: .center)
                addButton(name: getSupport, x: 0, y: 982, width: 750, height: 212, title: "Get Support.", font: "Roboto-Regular", fontSize: 15, titleColor: CustomColor.white115, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SettingsViewController.supportFunc(_:)), addSubview: true, alignment: .center)

        addLabel(name: accountSettings, text: "ACCOUNT SETTINGS", textColor: .white, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 15, x: 58, y: 334, width: 360, height: 30, lines: 1)
        view.addSubview(accountSettings)
        for i in 0...3 {
            let line = UILabel(frame: CGRect(x: 180*screenWidth/375, y: 271*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 195*screenWidth/375, height: 2*screenHeight/667))
            line.backgroundColor = CustomColor.fieldLines
            view.addSubview(line)
            
           
                let l = UILabel()
                let name = ["Email","Phone","Broker","Password"]
                addLabel(name: l, text: name[i], textColor: CustomColor.white115, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 16, x: 56, y: 500 + CGFloat(i)*120, width: 150, height: 40, lines: 0)
                view.addSubview(l)
            
            
            
            var myTextField = UITextField()
            myTextField = UITextField(frame: CGRect(x: 177*screenWidth/375,y: 246*screenHeight/667 + CGFloat(i)*60*screenHeight/667,width: 198*screenWidth/375 ,height: 34*screenHeight/667))
            switch i {
            case 0:
                
                myTextField.placeholder = UserInfo.email
                
            case 1:
                if UserInfo.phone != "none" {
                  myTextField.placeholder = UserInfo.phone
                } else {
                myTextField.placeholder = "(000) 000-0000"
                }
            case 2:
                if UserInfo.brokerName == "none" {
                myTextField.placeholder = "scottade"
                } else {
                   myTextField.placeholder = UserInfo.brokerName
                }
            default:
                myTextField.isSecureTextEntry = true
                myTextField.placeholder = "***********"
            }
            myTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            myTextField.autocorrectionType = UITextAutocorrectionType.no
            myTextField.keyboardType = UIKeyboardType.default
            myTextField.returnKeyType = UIReturnKeyType.done
            
            myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            myTextField.delegate = self
            myTextField.backgroundColor = .clear
            myTextField.textColor = .white
            myTextField.tag = i
            myTextField.font = UIFont(name: "Roboto-Italic", size: 15)
            myTextField.keyboardAppearance = .dark
            view.addSubview(myTextField)
            myTextFields.append(myTextField)
            
            addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SettingsViewController.back(_:)), addSubview: true)
            backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        }
        
        
        myPicker.dataSource = self
        myPicker.delegate = self
        myPicker.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 177*screenHeight/667)
        myPicker.showsSelectionIndicator = true
        
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 21/255, green: 127/255, blue: 249/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsViewController.donePicker))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: toolBarButtonColor], for: .normal)
        
        let brokerLabel = UIBarButtonItem(title: "Broker", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        brokerLabel.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action:nil)
    
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsViewController.donePicker))
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: toolBarButtonColor], for: .normal)
        
        toolBar.setItems([cancelButton, flexible, brokerLabel, flexible, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.barTintColor = toolBarColor
        
        myTextFields[2].inputView = myPicker
        myTextFields[2].inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        
        view.frame.origin.y = 0
        myPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.backgroundColor = myPickerBackground
       
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myTextFields[2].text = pickerData[row]
    }
    
    @objc private func back(_ sender: UIButton) {
        UserInfo.saveUserInfo()
        dismiss(animated: true)
    }
    
   
    @objc private func saveFunc(_ sender: UIButton) {
        guard let text0 = myTextFields[0].text,
            let text1 = myTextFields[1].text,
            let text2 = myTextFields[2].text else {return}
    
            if text0 != "" {
        UserInfo.email = text0
            }
            if text1 != "" {
        UserInfo.phone = text1
            }
            if text2 != "" {
        UserInfo.brokerName = text2
            }
        
            UserInfo.saveUserInfo()
        dismiss(animated: true)

    }
    
    func textFieldDidBeginEditing(_ textField : UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        if textField.isSecureTextEntry == true {
            UserInfo.saveUserInfo()
            present(ChangePasswordViewController(), animated: true)
        }
    }
    
    @objc private func supportFunc(_ sender: UIButton) {
      sendEmail()
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@firetailapp.com"])
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        guard let text0 = myTextFields[0].text,
            let text1 = myTextFields[1].text,
            let text2 = myTextFields[2].text else {return false}
            
            switch textField.tag {
            case 0:
                if text0 != "" {
                    UserInfo.email = text0
                }
            case 1:
                if text1 != "" {
                    UserInfo.phone = text1
                }
            case 2:
                if text2 != "" {
                    UserInfo.brokerName = text2
                }
            default:
                break
            }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == myTextFields[1] {
            guard let myText = textField.text else {return true}
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
        } else {
            return true
        }
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}
