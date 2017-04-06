//
//  SignupViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard
import Firebase
import FirebaseAuth

class SignupViewController: ViewSetup, UITextFieldDelegate {
    var customColor = CustomColor()
    var login = UIButton()
    var username = UILabel()
    var continueB = UIButton()
    var createAccount = UILabel()
    var textFields = [UITextField]()
    
    //var ti = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = customColor.black33
        let logo = UIImageView(frame: CGRect(x: screenWidth/2 - 93*screenHeight/1334, y: 42*screenHeight/667, width: 93*screenHeight/667, height: 119*screenHeight/667))
        logo.image = #imageLiteral(resourceName: "logo93x119")
        view.addSubview(logo)
        let accountView = UIView(frame: CGRect(x: 0, y: 266*screenHeight/667, width: screenWidth, height: 401*screenHeight/667))
        accountView.backgroundColor = customColor.black30
        view.addSubview(accountView)
        addButton(name: login, x: 0, y: 400, width: 254, height: 76, title: "LOGIN", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SignupViewController.loginFunc(_:)), addSubview: true, alignment: .center)
        addLabel(name: username, text: "", textColor: .white, textAlignment: .right, fontName: "Roboto-Medium", fontSize: 15, x: 200, y: 400, width: 470, height: 76, lines: 1)
        username.alpha = 0.1
        view.addSubview(username)
        addButton(name: continueB, x: 0, y: 1194, width: 750, height: 140, title: "CONTINUE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: customColor.black24, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SignupViewController.continueFunc(_:)), addSubview: true, alignment: .center)
        let arrowView = UIImageView(frame: CGRect(x: screenWidth - 70*screenHeight/667, y: 597*screenHeight/667, width: 70*screenHeight/667, height: 70*screenHeight/667))
        arrowView.image = #imageLiteral(resourceName: "forwardarrow")
        view.addSubview(arrowView)
        addLabel(name: createAccount, text: "CREATE ACCOUNT", textColor: .white, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 15, x: 80, y: 624, width: 360, height: 30, lines: 1)
        view.addSubview(createAccount)
        for i in 0...2 {
            let line = UILabel(frame: CGRect(x: 38*screenWidth/375, y: 408*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 300*screenWidth/375, height: 2*screenHeight/667))
            line.backgroundColor = customColor.fieldLines
            view.addSubview(line)
            
            
            var myTextField = UITextField()
            myTextField = UITextField(frame: CGRect(x: 38*screenWidth/375,y: 374*screenHeight/667 + CGFloat(i)*61*screenHeight/667,width: 300*screenWidth/375 ,height: 34*screenHeight/667))
            switch i {
            case 0:
                myTextField.placeholder = "email@address.com"
            case 1:
                myTextField.isSecureTextEntry = true
                myTextField.placeholder = "Password"
            default:
                myTextField.isSecureTextEntry = true
                myTextField.placeholder = "Confirm Password"
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
            textFields.append(myTextField)
        }
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromSignupToLogin", sender: self)
        
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    @objc private func continueFunc(_ sender: UIButton) {
        
      
        let emailField = textFields[0].text
        let passwordField = textFields[1].text
        let passwordfield2 = textFields[2].text

        if passwordField == passwordField {
            if emailField != nil && passwordField != nil {
                FIRAuth.auth()!.createUser(withEmail: emailField!, password: passwordField!) {
                    user, error in
                    if error == nil {
                        // 3
                        FIRAuth.auth()!.signIn(withEmail: emailField!, password: passwordField!) //adds user and pass
                        self.username.text = emailField!
                        FIRAuth.auth()!.signIn(withEmail: emailField!, password: passwordField!) //adds authentication
                    } else {
                        self.userWarning(title: "", message: (error!.localizedDescription))
                        print("firebase error local desc: \(error?.localizedDescription)")
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Warning", message: "Passwords Do Not Match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        delay(bySeconds: 1.5) {
            self.performSegue(withIdentifier: "fromSignupToMain", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        if textField.text != nil && textField.delegate != nil {
            
            //do something with the --> textField.text!
            
        }
        return false
    }
    
    
    
    
    
}
