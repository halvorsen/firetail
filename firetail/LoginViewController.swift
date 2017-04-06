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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.alreadyAUser = true
                self.authenticated = true
                
                (self.ti,_,_,_,_,_) = self.loadsave.loadBlocks()
                print(self.ti)
                self.delay(bySeconds: 5.0) {
                    
                    if self.ti != [""] {
                        Set.ti = self.ti
                        self.fetch()
                        print(self.myLoadSaveCoreData.loadUserAlertsFromFirebase(alerts: self.ti))
                    } else {
                        self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
                    }
                }
            } else {
                UIView.animate(withDuration: 1.0) {
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
    override func viewWillAppear(_ animated: Bool) {
        //        if check == [""] {
        //            UIView.animate(withDuration: 1.0) {
        //                self.imageView.alpha = 0.0
        //                self.coverView.alpha = 0.0
        //                self.firetail.alpha = 0.0
        //            }
        //            if !self.continueB.isDescendant(of: self.view) {
        //                self.populateView()
        //            }
        //        }
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
                    } else {
                        
                        //self.myTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(LoginViewController.checkIfDone), userInfo: nil, repeats: true)
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
    //    var oopsNotTwice = true
    //    func checkIfDone() {
    //        if doneLoading && oopsNotTwice && !retry {
    //            oopsNotTwice = false
    //            if ti == [""] {
    //                self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
    //            } else {
    //                print("!!!!!!")
    //                print(ti)
    //                print(ti.count)
    //                self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
    //            }
    //        } else if retry {
    //            doneLoading = false
    //            retry = false
    //            fetch()
    //
    //        }
    //
    //    }
    
    @objc private func continueFunc(_ sender: UIButton) {
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
            self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
        } else {
            print("!!!!!!")
            print(ti)
            print(ti.count)
            if isFirstTimeSeguing {
                isFirstTimeSeguing = false
            self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
            }
        }
        
        //  }
        
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
