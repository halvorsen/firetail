//
//  LoginViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore


class LoginViewController: ViewSetup, UITextFieldDelegate {

    var customColor = CustomColor()
    var login = UIButton()
    var continueB = UIButton()
    var createAccount = UIButton()
    var myTextFields = [UITextField]()
    var activityView = UIActivityIndicatorView()
    let loadsave = LoadSaveCoreData()
    var myTimer = Timer()
    var ti = [String]()
    var alreadyAUser = false
 
    let coverView = UIView()
    var retry = false
    var authenticated = false
    var noNils = true
    var tiLast = String()
 
    let myLoadSaveCoreData = LoadSaveCoreData()
    var isFirstLoading = true
    var tap = UITapGestureRecognizer()
    var appLoadingData = AppLoadingData()
    let alphaAPI = Alpha()
  
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard(_:)))
        Set2.priceRectX.removeAll()
        for xVal in Set3.shared.priceRectX {
            
            Set2.priceRectX.append(xVal*screenWidth/375)
        }
        alphaAPI.populateSet1Month()
        loadsave.loadUsername()
        coverView.frame = view.frame
        coverView.backgroundColor = customColor.black33
        coverView.layer.zPosition = 10
        view.addSubview(coverView)
        

        
        let launchedBefore = UserDefaults.standard.bool(forKey: "fireTailLaunchedBefore")
        if launchedBefore  {
         
        } else {
            do {try Auth.auth().signOut()}catch { }
            UserDefaults.standard.set(true, forKey: "fireTailLaunchedBefore")
        }
        var didntMoveForward = true
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.alreadyAUser = true
                self.authenticated = true
                if Set1.username != "none" {
                   if self.isFirstLoading {
                    //load stock list from firebase and start fetch, if loading takes long time move forward anyways after 8 seconds to dashboard
                    Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false, block: {_ in
                        if didntMoveForward {
                    
                            didntMoveForward = false
                            if self.isFirstTimeSeguing {
                                self.isFirstTimeSeguing = false
                                self.logoutFunc()
                                self.performSegue(withIdentifier: "fromLoginToSignup", sender: self)
                            }
                        }
                    })
                    self.appLoadingData.loadUserInfoFromFirebase(firebaseUsername: Set1.username) {haveNoAlerts in
                        self.ti = Set1.ti
            
                        if haveNoAlerts {
                         
                            didntMoveForward = false
                            self.performSegue(withIdentifier: "fromLoginToAddStockTicker", sender: self)
                        } else {
                       
                            didntMoveForward = false
                            self.cont()
                        }
                        
                    }
                    
                        self.isFirstLoading = false
                    }
                }    
            } else {
                UIView.animate(withDuration: 0.2) {
             
                    self.coverView.alpha = 0.0
                    
                }
                if !self.continueB.isDescendant(of: self.view) {
                    self.populateView()
                }
            }
        }
        
        Set1.flashOn = UserDefaults.standard.bool(forKey: "flashOn")
        Set1.allOn = UserDefaults.standard.bool(forKey: "allOn")
        Set1.pushOn = UserDefaults.standard.bool(forKey: "pushOn")
        Set1.emailOn = UserDefaults.standard.bool(forKey: "emailOn")
        Set1.smsOn = UserDefaults.standard.bool(forKey: "smsOn")
    }
    
    @objc private func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
       myTextFields[0].resignFirstResponder()
       myTextFields[1].resignFirstResponder()
    }

    
    func textFieldDidBeginEditing(_ textField : UITextField) {
        view.addGestureRecognizer(tap)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
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
    
    private func populateView() {
        if !alreadyAUser {
            view.backgroundColor = customColor.black33
            let logo = UIImageView(frame: CGRect(x: screenWidth/2 - 93*screenHeight/1334, y: 42*screenHeight/667, width: 93*screenHeight/667, height: 119*screenHeight/667))
            logo.image = #imageLiteral(resourceName: "logo93x119")
            view.addSubview(logo)
            
            addButton(name: login, x: 0, y: 400, width: 254, height: 76, title: "LOGIN", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(LoginViewController.loginFunc(_:)), addSubview: true, alignment: .center)
            
            addButton(name: continueB, x: 0, y: 740, width: 750, height: 140, title: "CONTINUE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(LoginViewController.continueFunc(_:)), addSubview: true, alignment: .center)
            
            
            addButton(name: createAccount, x: 0, y: 1146, width: 750, height: 188, title: "         CREATE ACCOUNT", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: customColor.black30, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(LoginViewController.createAccountFunc(_:)), addSubview: true)
            let arrowView = UIImageView(frame: CGRect(x: screenWidth - 70*screenHeight/667, y: 370*screenHeight/667, width: 70*screenHeight/667, height: 70*screenHeight/667))
            arrowView.image = #imageLiteral(resourceName: "forwardarrow")
            view.addSubview(arrowView)
            for i in 0...1 {
                let line = UILabel(frame: CGRect(x: 38*screenWidth/375, y: 306*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 300*screenWidth/375, height: 2*screenHeight/667))
                line.backgroundColor = customColor.fieldLines
                view.addSubview(line)
                
                
                var myTextField = UITextField()
                myTextField = UITextField(frame: CGRect(x: 38*screenWidth/375,y: 272*screenHeight/667 + CGFloat(i)*61*screenHeight/667,width: 300*screenWidth/375 ,height: 34*screenHeight/667))
                switch i {
                case 0:
                    myTextField.placeholder = "email@address.com"
                case 1:
                    myTextField.isSecureTextEntry = true
                    myTextField.placeholder = "Password"
                default:
                    break
                }
                myTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
                myTextField.autocorrectionType = UITextAutocorrectionType.no
                myTextField.keyboardType = UIKeyboardType.default
                myTextField.returnKeyType = UIReturnKeyType.done
                
                myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                myTextField.delegate = self
                myTextField.backgroundColor = .clear
                myTextField.textColor = .white
                myTextField.font = UIFont(name: "Roboto-Italic", size: 15)
                myTextField.keyboardAppearance = .dark
                view.addSubview(myTextField)
                myTextFields.append(myTextField)
            }
        }
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromLoginToSignup", sender: self)
    }
    
    @objc private func continueFunc(_ sender: UIButton) {
        guard let myText = myTextFields[0].text,
            let myText2 = myTextFields[1].text else {return}
        var cleanString = myText
        cleanString = cleanString.replacingOccurrences(of: ".", with: ",")
        cleanString = cleanString.replacingOccurrences(of: "$", with: "")
        cleanString = cleanString.replacingOccurrences(of: "#", with: "")
        cleanString = cleanString.replacingOccurrences(of: "[", with: "(")
        cleanString = cleanString.replacingOccurrences(of: "]", with: ")")
        cleanString = cleanString.replacingOccurrences(of: "/", with: "")
        
        loadsave.saveUsername(username: cleanString)
        Set1.username = cleanString
        
        Auth.auth().signIn(withEmail: myText, password: myText2, completion: { (user, error) in
            if error != nil{
                self.activityView.removeFromSuperview()
                let alert = UIAlertController(title: "Warning", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
      
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    var isFirstTimeSeguing = true
    private func cont() {
      
        if ti == [""] {
            if isFirstTimeSeguing {
                isFirstTimeSeguing = false
                self.performSegue(withIdentifier: "fromLoginToAddStockTicker", sender: self)
            }
        } else {
    
            if isFirstTimeSeguing {
                isFirstTimeSeguing = false
                self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
            }
        }
    }
    
    @objc private func createAccountFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromLoginToSignup", sender: self)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        view.removeGestureRecognizer(tap)
        self.view.endEditing(true)
      
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToAddStockTicker" {
            
            let addView: AddStockTickerViewController = segue.destination as! AddStockTickerViewController
            
            addView.newAlertTicker = "TICKER"
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    private func logoutFunc() {
        
        Set1.month = ["","","","","","","","","","","",""]
        Set1.currentPrice = 0.0
        Set1.yesterday = 0.0
        Set1.token = "none"
        Set1.oneYearDictionary.removeAll()
        Set1.ti.removeAll()
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
        Set2.smallRectX.removeAll()
        Set2.bigRectX.removeAll()
        Set2.priceRectX.removeAll()
        Set1.alerts.removeAll()
        Set1.logoutFirebase()
     
    }
    
}
