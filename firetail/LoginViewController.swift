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


final class LoginViewController: ViewSetup, UITextFieldDelegate {

    var login = UIButton()
    var continueB = UIButton()
    var createAccount = UIButton()
    var resetPassword = UIButton()
    var myTextFields = [UITextField]()
    var activityView = UIActivityIndicatorView()
    let loadsave = LoadSaveCoreData()
    var myTimer = Timer()
    var ti = [String]()
    var alreadyAUser = false
 
    var retry = false
    var authenticated = false
    var noNils = true
    var tiLast = String()
 
    let myLoadSaveCoreData = LoadSaveCoreData()
    var isFirstLoading = true
    var tap = UITapGestureRecognizer()
    let alphaAPI = Alpha()
  
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard(_:)))
      resetPassword.setTitle("reset password", for: .normal)
        resetPassword.addTarget(self, action: #selector(resetPasswordTouchUpInside), for: .touchUpInside)
        alphaAPI.populateUserInfoMonth()
        loadsave.loadUsername()
        self.populateView()
        
    }
    
    @objc private func resetPasswordTouchUpInside() {
        
        let alert = UIAlertController(title: "Reset Password", message: "A reset link will be sent to your email.", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "myemail@address.com"
        }
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: { _ in
            if let text = alert.textFields?[0].text {
                Auth.auth().sendPasswordReset(withEmail: text) { (error) in
                    // nothing
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
        
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
            view.backgroundColor = CustomColor.black33
            let logo = UIImageView(frame: CGRect(x: screenWidth/2 - 93*screenHeight/1334, y: 42*screenHeight/667, width: 93*screenHeight/667, height: 119*screenHeight/667))
            logo.image = #imageLiteral(resourceName: "logo93x119")
            view.addSubview(logo)
            
            addButton(name: continueB, x: 0, y: 740, width: 750, height: 140, title: "CONTINUE", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(LoginViewController.continueFunc(_:)), addSubview: true, alignment: .center)

            resetPassword.frame.origin = CGPoint(x: 35*screenWidth/375, y: 200*screenHeight/667)
            resetPassword.frame.size = resetPassword.intrinsicContentSize
            resetPassword.setTitleColor(CustomColor.white, for: .normal)
            resetPassword.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
            view.addSubview(resetPassword)
            
            addButton(name: createAccount, x: 0, y: 1146, width: 750, height: 188, title: "         CREATE ACCOUNT", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: CustomColor.black30, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(LoginViewController.createAccountFunc(_:)), addSubview: true)
            let arrowView = UIImageView(frame: CGRect(x: screenWidth - 70*screenHeight/667, y: varyForDevice(normal: 370*screenHeight/667, iphoneX: 363*screenHeight/667), width: 70*screenHeight/667, height: 70*screenHeight/667))
            arrowView.image = #imageLiteral(resourceName: "forwardarrow")
            view.addSubview(arrowView)
            for i in 0...1 {
                let line = UILabel(frame: CGRect(x: 38*screenWidth/375, y: 306*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 300*screenWidth/375, height: 2*screenHeight/667))
                line.backgroundColor = CustomColor.fieldLines
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
        present(SignupViewController(), animated: true)
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
        UserInfo.username = cleanString
        
        Auth.auth().signIn(withEmail: myText, password: myText2, completion: { (user, error) in
            if error != nil {
                self.activityView.removeFromSuperview()
                let alert = UIAlertController(title: "Warning", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.activityView.removeFromSuperview()
                Alerts.eraseStockAlertFile()
                UserInfo.alerts.removeAll()
                UserInfo.tickerArray.removeAll()
                DashboardViewController.shared.collectionView?.reloadData()
                self.present(DashboardViewController.shared, animated: true)
                
            }
        })
      
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    @objc private func createAccountFunc(_ sender: UIButton) {
        present(SignupViewController(), animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        view.removeGestureRecognizer(tap)
        self.view.endEditing(true)
      
        return false
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}
