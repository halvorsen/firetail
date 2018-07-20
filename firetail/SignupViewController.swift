//
//  SignupViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ReachabilitySwift

class SignupViewController: ViewSetup, UITextFieldDelegate {

    var login = UIButton()
    var username = UILabel()
    var continueB = UIButton()
    var createAccount = UILabel()
    var textFields = [UITextField]()
    let loadsave = LoadSaveCoreData()
    var tap = UITapGestureRecognizer()

    
    //var ti = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard(_:)))
        view.backgroundColor = CustomColor.black33
        let logo = UIImageView(frame: CGRect(x: screenWidth/2 - 93*screenHeight/1334, y: 42*screenHeight/667, width: 93*screenHeight/667, height: 119*screenHeight/667))
        logo.image = #imageLiteral(resourceName: "logo93x119")
        view.addSubview(logo)
        let accountView = UIView(frame: CGRect(x: 0, y: 266*screenHeight/667, width: screenWidth, height: 401*screenHeight/667))
        accountView.backgroundColor = CustomColor.black30
        view.addSubview(accountView)
        addButton(name: login, x: 0, y: 400, width: 254, height: 76, title: "LOGIN", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SignupViewController.loginFunc(_:)), addSubview: true, alignment: .center)
        addLabel(name: username, text: "", textColor: .white, textAlignment: .right, fontName: "Roboto-Medium", fontSize: 15, x: 200, y: 400, width: 470, height: 76, lines: 1)
        username.alpha = 0.1
        view.addSubview(username)
        addButton(name: continueB, x: 0, y: 1194, width: 750, height: 140, title: "CONTINUE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: CustomColor.black24, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SignupViewController.continueFunc(_:)), addSubview: true, alignment: .center)
        let arrowView = UIImageView(frame: CGRect(x: screenWidth - 70*screenHeight/667, y: 597*screenHeight/667, width: 70*screenHeight/667, height: 70*screenHeight/667))
        arrowView.image = #imageLiteral(resourceName: "forwardarrow")
        view.addSubview(arrowView)
        addLabel(name: createAccount, text: "CREATE ACCOUNT", textColor: .white, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 15, x: 80, y: 624, width: 360, height: 30, lines: 1)
        view.addSubview(createAccount)
        for i in 0...2 {
            let line = UILabel(frame: CGRect(x: 38*screenWidth/375, y: 408*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 300*screenWidth/375, height: 2*screenHeight/667))
            line.backgroundColor = CustomColor.fieldLines
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
            myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            myTextField.delegate = self
            myTextField.backgroundColor = .clear
            myTextField.textColor = .white
            myTextField.tag = i
            myTextField.font = UIFont(name: "Roboto-Italic", size: 15)
            myTextField.keyboardAppearance = .dark
            view.addSubview(myTextField)
            textFields.append(myTextField)
        }
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        present(LoginViewController(), animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        view.addGestureRecognizer(tap)
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        animateViewMoving(up: true, moveValue: 150)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 150)
    }
    func animateViewMoving (up: Bool, moveValue: CGFloat) {
        let movementDuration:TimeInterval = 0.3
        let movement: CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    var continueOnce = true
    @objc private func continueFunc(_ sender: UIButton) {
        guard continueOnce == true else {return}
        continueOnce = false
        
        
        var cleanString = textFields[0].text!
        cleanString = cleanString.replacingOccurrences(of: ".", with: ",")
        cleanString = cleanString.replacingOccurrences(of: "$", with: "")
        cleanString = cleanString.replacingOccurrences(of: "#", with: "")
        cleanString = cleanString.replacingOccurrences(of: "[", with: "(")
        cleanString = cleanString.replacingOccurrences(of: "]", with: ")")
        cleanString = cleanString.replacingOccurrences(of: "/", with: "")
        
        loadsave.saveUsername(username: cleanString)
        UserInfo.username = cleanString
        UserInfo.email = textFields[0].text ?? ""
        let emailField = textFields[0].text
        let passwordField = textFields[1].text
        let passwordField2 = textFields[2].text
        
        guard let email = emailField else {continueOnce = true; return}
        guard let password1 = passwordField else {continueOnce = true; return}
        guard let password2 = passwordField2 else {continueOnce = true; return}
        guard password1 == password2 else {
            continueOnce = true
            let alert = UIAlertController(title: "Warning", message: "Passwords Do Not Match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard email.isEmail == true else {
            continueOnce = true
            let alert = UIAlertController(title: "Warning", message: "Enter Valid Email Address", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard password1.isValidPassword == true else {
            continueOnce = true
            let alert = UIAlertController(title: "Invalid Password", message: "6-20 Characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password1) {
            user, error in
            if error == nil {
                self.continueOnce = true
                self.username.text = email
                Auth.auth().signIn(withEmail: email, password: password1) //adds authentication
                CacheManager().eraseAllStockCache()
                Alerts.eraseStockAlertFile()
                UserInfo.alerts.removeAll()
                UserInfo.tickerArray.removeAll()
                UserInfo.saveUserInfo()
                self.delay(bySeconds: 1.5) {
                    self.present(AddStockTickerViewController(), animated: true)
                }
            } else {
               
                Auth.auth().signIn(withEmail: email, password: password1, completion: { (user, error) in
                    if error != nil{
                        self.continueOnce = true
                    } else {
                        self.continueOnce = true
                        self.username.text = email
                        CacheManager().eraseAllStockCache()
                        Alerts.eraseStockAlertFile()
                        UserInfo.alerts.removeAll()
                        UserInfo.tickerArray.removeAll()
                        UserInfo.saveUserInfo()
                       self.present(AddStockTickerViewController(), animated: true)
                        
                    }
                })
                
            }
        }
    }
    
    @objc private func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        textFields[0].resignFirstResponder()
        textFields[1].resignFirstResponder()
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        view.removeGestureRecognizer(tap)
        self.view.endEditing(true)
        
        switch textField.tag {
        case 0:
            textFields[1].becomeFirstResponder()
        case 1:
            textFields[2].becomeFirstResponder()
        case 2:
            view.frame.origin.y = 0
            continueFunc(continueB)
        default:
            break
        }
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    
}
