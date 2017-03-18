//
//  SignupViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard

class SettingsViewController: ViewSetup, UITextFieldDelegate {
    var customColor = CustomColor()
    var continueB = UIButton()
    var getSupport = UIButton()
    var accountSettings = UILabel()
    var myTextFields = [UITextField]()
    var doneLoading = false
    var progressHUD = ProgressHUD(text: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = customColor.black33
        var logo = UIImageView(frame: CGRect(x: 28*screenWidth/375, y: 75*screenHeight/667, width: 50*screenWidth/375, height: 64*screenWidth/375))
        logo.image = #imageLiteral(resourceName: "logo50x64")
        view.addSubview(logo)
        
        addButton(name: continueB, x: 0, y: 1194, width: 750, height: 140, title: "SAVE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: customColor.black24, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SettingsViewController.saveFunc(_:)), addSubview: true, alignment: .center)
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
                myTextField.placeholder = "(615) 435-3245"
            case 2:
                myTextField.placeholder = "Scottade"
            default:
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
            myTextField.font = UIFont(name: "Roboto-Italic", size: 15)
            view.addSubview(myTextField)
            myTextFields.append(myTextField)
        }
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromSignupToLogin", sender: self)
        
    }
    @objc private func saveFunc(_ sender: UIButton) {

            self.performSegue(withIdentifier: "fromSettingsToMain", sender: self)

    }
    
    @objc private func supportFunc(_ sender: UIButton) {
      
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        if textField.text != nil && textField.delegate != nil {
            
            //do something with the --> textField.text!
            
        }
        return false
    }
    
}
