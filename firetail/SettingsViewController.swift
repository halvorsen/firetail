//
//  SignupViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard
import MessageUI

class SettingsViewController: ViewSetup, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
    var customColor = CustomColor()
    var continueB = UIButton()
    var getSupport = UIButton()
    var accountSettings = UILabel()
    var myTextFields = [UITextField]()
    var doneLoading = false
    var backArrow = UIButton()
    var myPicker = UIPickerView()
    let toolBar = UIToolbar()
    let pickerData = ["Ameritrade", "Etrade", "Scottrade", "Schwab", "Merrill Edge", "Trademonster", "Capital One Investing", "eOption", "Interactive Brokers", "Kapitall", "Lightspeed", "optionsXpress", "Zacks", "Trade King", "Sogo Trade", "Trading Block", "USAA", "Vangaurd", "Wells Fargo", "Robinhood"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = customColor.black33
        let logo = UIImageView(frame: CGRect(x: 28*screenWidth/375, y: 75*screenHeight/667, width: 50*screenWidth/375, height: 64*screenWidth/375))
        logo.image = #imageLiteral(resourceName: "logo50x64")
        view.addSubview(logo)
        
        addButton(name: continueB, x: 0, y: 1194, width: 750, height: 140, title: "SAVE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: customColor.black42, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SettingsViewController.saveFunc(_:)), addSubview: true, alignment: .center)
                addButton(name: getSupport, x: 0, y: 982, width: 750, height: 212, title: "Get Support.", font: "Roboto-Regular", fontSize: 15, titleColor: customColor.white115, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SettingsViewController.supportFunc(_:)), addSubview: true, alignment: .center)

        addLabel(name: accountSettings, text: "ACCOUNT SETTINGS", textColor: .white, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 15, x: 80, y: 334, width: 360, height: 30, lines: 1)
        view.addSubview(accountSettings)
        for i in 0...3 {
            let line = UILabel(frame: CGRect(x: 180*screenWidth/375, y: 271*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 195*screenWidth/375, height: 2*screenHeight/667))
            line.backgroundColor = customColor.fieldLines
            view.addSubview(line)
            
           
                let l = UILabel()
                let name = ["Email","Phone","Broker","Password"]
                addLabel(name: l, text: name[i], textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 16, x: 56, y: 500 + CGFloat(i)*120, width: 150, height: 40, lines: 0)
                view.addSubview(l)
            
            
            
            var myTextField = UITextField()
            myTextField = UITextField(frame: CGRect(x: 177*screenWidth/375,y: 246*screenHeight/667 + CGFloat(i)*60*screenHeight/667,width: 198*screenWidth/375 ,height: 34*screenHeight/667))
            switch i {
            case 0:
                myTextField.placeholder = "email@address.com"
            case 1:
                myTextField.placeholder = "(000) 000-0000"
            case 2:
                myTextField.placeholder = "scottade"
            default:
                myTextField.isSecureTextEntry = true
                myTextField.placeholder = "***********"
            }
            myTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            myTextField.autocorrectionType = UITextAutocorrectionType.no
            myTextField.keyboardType = UIKeyboardType.default
            myTextField.returnKeyType = UIReturnKeyType.done
            myTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
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
        myPicker.backgroundColor = .white
        myPicker.showsSelectionIndicator = true
        
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 21/255, green: 127/255, blue: 249/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        myTextFields[2].inputView = myPicker
        myTextFields[2].inputAccessoryView = toolBar
    }
    
    func donePicker() {
        
        view.frame.origin.y = 0
        myPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myTextFields[2].text = pickerData[row]
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromSettingsToMain", sender: self)
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromSignupToLogin", sender: self)
        
    }
    @objc private func saveFunc(_ sender: UIButton) {

            self.performSegue(withIdentifier: "fromSettingsToMain", sender: self)

    }
    
    func textFieldDidBeginEditing(_ textField : UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        if textField.isSecureTextEntry == true {
            self.performSegue(withIdentifier: "fromSettingsToChangePassword", sender: self)
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
        if textField.text != nil && textField.delegate != nil {
            
                switch textField.tag {
                case 0:
                    Set1.email = myTextFields[0].text!
                    //change email with firebase
                case 1:
                    Set1.phone = myTextFields[1].text!
                    
                case 2:
                    Set1.brokerName = myTextFields[2].text!
                default:
                 // change password with firebase:   myTextFields[2].text!
                    break
                }
            }
        
        return false
    }
    
    
}
