//
//  LoginViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard
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
    let imageView = UIImageView()
    let coverView = UIView()
    var retry = false
    var authenticated = false
    var noNils = true
    var tiLast = String()
    var _ti = [String]()
    let firetail = UILabel()
    let myLoadSaveCoreData = LoadSaveCoreData()
    var isFirstLoading = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadsave.loadUsername()
        print("USA!")
        print(Set.username)
        coverView.frame = view.frame
        coverView.backgroundColor = customColor.black33
        coverView.layer.zPosition = 10
        view.addSubview(coverView)
        imageView.frame.size = CGSize(width: 161, height: 207)
        imageView.image = #imageLiteral(resourceName: "logo161x207")
        imageView.frame.origin.x = view.frame.midX - 161/2
        imageView.frame.origin.y = view.frame.midY - 220
        imageView.layer.zPosition = 11
        view.addSubview(imageView)
        firetail.frame = CGRect(x: 0, y: view.frame.midY - 10, width: screenWidth, height: 65*screenHeight/667)
        firetail.text = "FIRETAIL"
        firetail.font = UIFont(name: "Roboto-Bold", size: 27*fontSizeMultiplier)
        firetail.textAlignment = .center
        firetail.textColor = .white
        firetail.backgroundColor = .clear
        firetail.layer.zPosition = 11
        view.addSubview(firetail)
        
        // (check,_,_,_,_,_) = self.loadsave.loadBlocks()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            do {try FIRAuth.auth()?.signOut()}catch { }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.alreadyAUser = true
                self.authenticated = true
                if Set.username != "none" {
                   if self.isFirstLoading {
                    self.loadUserInfoFromFirebase(firebaseUsername: Set.username)
                        self.isFirstLoading = false
                    }
                }    
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.imageView.alpha = 0.0
                    self.coverView.alpha = 0.0
                    self.firetail.alpha = 0.0
                }
                if !self.continueB.isDescendant(of: self.view) {
                    self.populateView()
                }
            }
        }
        
    }
    
    func loadUserInfoFromFirebase(firebaseUsername: String) {
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(firebaseUsername).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            // Set.username = value?["username"] as? String ?? "none"
            Set.fullName = value?["fullName"] as? String ?? "none"
            Set.email = value?["email"] as? String ?? "none"
            Set.phone = value?["phone"] as? String ?? "none"
            Set.premium = value?["premium"] as? Bool ?? false
            Set.alertCount = value?["numOfAlerts"] as? Int ?? 0
            Set.brokerName = value?["brokerName"] as? String ?? "none"
            Set.brokerURL = value?["brokerURL"] as? String ?? "none"
            Set.weeklyAlerts = value?["weeklyAlerts"] as? [String:Int] ?? ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
            if Set.alertCount > 0 {
                Set.userAlerts = value?["userAlerts"] as! [String:String]
            }
            
            if Set.userAlerts.count > 0 {
             
                print(Set.userAlerts.count)
                print(Set.userAlerts)
                
                var alertID: [String] {
                    var aaa = [String]()
                    for i in 0..<Set.alertCount {
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
                let uA = Set.userAlerts
                for i in 0..<Set.userAlerts.count {
                    if uA[alertID[i]] != nil {
                    ref.child("alerts").child(uA[alertID[i]]!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let _deleted = value?["deleted"] as? Bool ?? false
                        
                        if !_deleted {
                            
                            let _name = uA[alertID[i]]!
                            let value = snapshot.value as? NSDictionary
                            let _isGreaterThan = value?["isGreaterThan"] as? Bool ?? false
                            //   isGreaterThan.append(_isGreaterThan)
                            let _price = value?["price"] as? Double ?? 0.0
                            // price.append(_price)
                            
                            //   deleted.append(_deleted)
                            let _email = value?["email"] as? Bool ?? false
                            //   email.append(_email)
                            let _flash = value?["flash"] as? Bool ?? false
                            //  flash.append(_flash)
                            let _sms = value?["sms"] as? Bool ?? false
                            //  sms.append(_sms)
                            let _ticker = value?["ticker"] as? String ?? ""
                            Set.ti.append(_ticker)
                            //   ticker.append(_ticker)
                            let _push = value?["push"] as? Bool ?? false
                            //   push.append(_push)
                            let _urgent = value?["urgent"] as? Bool ?? false
                            //   urgent.append(_urgent)
                            let _triggered = value?["triggered"] as? Bool ?? false
                            //   triggered.append(_triggered)
                            Set.alerts[uA[alertID[i]]!] = (_name, _isGreaterThan, _price, _deleted, _email, _flash, _sms, _ticker, _triggered, _push, _urgent)
                        }
                        self.ti = Set.ti
                        print("COWBOY")
                        print(Set.ti)
                        if self.ti.count != 0 {
                            
                            self.fetch()
                            
                        } else {
                            if self.isFirstTimeSeguing {
                                self.isFirstTimeSeguing = false
                                self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
                            }
                        }
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    }
                }
            } else {
                self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    private func fetch() {
        noNils = true
        retry = false
        var stockStrings = [String]()
        if ti.count > 0 {
            var j = 0
            for i in 0..<ti.count {
                getOneYearData(stockName: ti[i]) {
                    
                    if $0 == nil {
                        print("NIL-HERE")
                        self._ti.append($1)
                        self.retry = true
                        self.noNils = false
                    }
                    if !stockStrings.contains($1) && $0 != nil {
                        print("STOCKSWHAT")
                        print(" sWww1: \($1)")
                        print(" sWww2: \($0)")
                        stockStrings.append($1)
                        
                        Set.oneYearDictionary[$1] = $0
                    }
                    
                    j += 1
                    print("ti.count: \(self.ti.count)")
                    print("j: \(j)")
                    if j == self.ti.count && self.noNils {
                        
                        self.cont()
                        
                    } else if !self.noNils {
                        self.ti = self._ti
                        self.fetch()
                    }
                }
            }
        }
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
                //myTextField.font = UIFont.systemFont(ofSize: 15)
                //myTextField.borderStyle = UITextBorderStyle.roundedRect
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
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromLoginToSignup", sender: self)
        
    }
    
    @objc private func continueFunc(_ sender: UIButton) {
        let firstTwo = myTextFields[0].text![0...1]
        let timestamp = String(Int(Date().timeIntervalSince1970 * 10000))
        //In this instance we need to load an already existing username and not creating a new one!!! WARNING WARNING!!!!
        loadsave.saveUsername(username: firstTwo + timestamp)
        Set.username = firstTwo + timestamp
        FIRAuth.auth()!.signIn(withEmail: myTextFields[0].text!, password: myTextFields[1].text!)
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        
        
    }
    var isFirstTimeSeguing = true
    private func cont() {
        
        //  if doneLoading && !retry { // check if alert stocks have loaded
        if ti == [""] {
            if isFirstTimeSeguing {
                isFirstTimeSeguing = false
                self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
            }
        } else {
            print("!!!!!!")
            print(ti)
            print(ti.count)
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
        
        self.view.endEditing(true)
        if textField.text != nil && textField.delegate != nil {
            
            //do something with the --> textField.text!
            
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToAdd" {
            
            let addView: AddViewController = segue.destination as! AddViewController
            
            addView.newAlertTicker = "TSLA"
        }
        
        
    }
    
    
}
