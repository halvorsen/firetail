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
    var progressHUD = ProgressHUD(text: "Loading")
    var doneLoading = false
    let loadsave = LoadSaveCoreData()
    var myTimer = Timer()
    var ti = [String]()
    var alreadyAUser = false
    let imageView = UIImageView()
    let coverView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coverView.frame = view.frame
        coverView.backgroundColor = customColor.black33
        coverView.layer.zPosition = 10
        view.addSubview(coverView)
        imageView.frame = CGRect(x: 141, y: 274, width: 93, height: 119)
        imageView.image = #imageLiteral(resourceName: "logo93x119")
        imageView.frame.origin.x = view.frame.midX - 93/2
        imageView.frame.origin.y = view.frame.midY - 119/2
        imageView.layer.zPosition = 11
        view.addSubview(imageView)
        
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.alreadyAUser = true
                self.cont()
            } else {
                UIView.animate(withDuration: 1.0) {
                self.imageView.alpha = 0.0
                self.coverView.alpha = 0.0
                }
                self.populateView()
            }
        }
        
        (ti,_,_,_,_,_) = loadsave.loadBlocks()
        
        
        for i in 0..<ti.count {
            getOneYearData(stockName: ti[i]) {
             print("WEEEEE")
                print($1)
                print($0)
                Set.oneYearDictionary[$1] = $0
                if i >= self.ti.count - 1 {
                    
                    self.delay(bySeconds: 0.5) {
                    self.doneLoading = true
                    self.myTimer.invalidate()
                    }
                }
            }
        }
        if ti != [""] {
            Set.ti = ti
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
    var oopsNotTwice = true
    func checkIfDone() {
        if doneLoading && oopsNotTwice {
            oopsNotTwice = false
            if ti == [""] {
                self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
            } else {
                print("!!!!!!")
                print(ti)
                print(ti.count)
                self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
            }
        }
        
    }
    
    @objc private func continueFunc(_ sender: UIButton) {
        FIRAuth.auth()!.signIn(withEmail: myTextFields[0].text!, password: myTextFields[1].text!)
        
        self.view.addSubview(progressHUD)
        
    }
    
    private func cont() {
        
        if doneLoading { // check if alert stocks have loaded
            if ti == [""] {
                self.performSegue(withIdentifier: "fromLoginToAdd", sender: self)
            } else {
                print("!!!!!!")
                print(ti)
                print(ti.count)
                self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
            }
            
        } else {
            
            myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LoginViewController.checkIfDone), userInfo: nil, repeats: true)
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
