//
//  ChangePasswordViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 5/2/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ReachabilitySwift

class ChangePasswordViewController: ViewSetup, UITextFieldDelegate {

    var continueB = UIButton()
    var getSupport = UIButton()
    var accountSettings = UILabel()
    var myTextFields = [UITextField]()
    var doneLoading = false
    var backArrow = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor.black33
        
        addButton(name: continueB, x: 0, y: 1194, width: 750, height: 140, title: "SAVE", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: CustomColor.black42, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(ChangePasswordViewController.saveFunc(_:)), addSubview: true, alignment: .center)

        
        addLabel(name: accountSettings, text: "CHANGE PASSWORD", textColor: .white, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 15, x: 80, y: 334, width: 360, height: 30, lines: 1)
        view.addSubview(accountSettings)
        for i in 0...2 {
            let line = UILabel(frame: CGRect(x: 180*screenWidth/375, y: 271*screenHeight/667 + CGFloat(i)*60*screenHeight/667, width: 195*screenWidth/375, height: 2*screenHeight/667))
            line.backgroundColor = CustomColor.fieldLines
            view.addSubview(line)
            
            
            let l = UILabel()
            let name = ["Old Password","New Password","Confirm Password"]
            addLabel(name: l, text: name[i], textColor: CustomColor.white115, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 16, x: 56, y: 500 + CGFloat(i)*120, width: 300, height: 40, lines: 0)
            view.addSubview(l)
            
            
            
            var myTextField = UITextField()
            myTextField = UITextField(frame: CGRect(x: 177*screenWidth/375,y: 246*screenHeight/667 + CGFloat(i)*60*screenHeight/667,width: 198*screenWidth/375 ,height: 34*screenHeight/667))
            switch i {
            case 0:
                myTextField.placeholder = "********"
                myTextField.isSecureTextEntry = true
            case 1:
                myTextField.placeholder = "********"
                myTextField.isSecureTextEntry = true
            case 2:
                myTextField.placeholder = "********"
                myTextField.isSecureTextEntry = true
            default:
                myTextField.isSecureTextEntry = true
               
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
            
            addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(ChangePasswordViewController.back(_:)), addSubview: true)
            backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        }

    }

    
    @objc func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
        @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromChangePasswordToSettings", sender: self)
    }
    
    @objc private func saveFunc(_ sender: UIButton) {
        
        saveNewPassword()
        
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }

    
   
    var oldPass = String()
    var newPass = String()
    var newPass2 = String()
    //FIXIT: check password and change firebase password
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        if textField.text != nil && textField.delegate != nil {
            
            switch textField.tag {
            case 0:
                oldPass = myTextFields[0].text!
                myTextFields[1].becomeFirstResponder()
            //change email with firebase
            case 1:
                newPass = myTextFields[1].text!
                myTextFields[2].becomeFirstResponder()
                
            case 2:
                newPass2 = myTextFields[2].text!
                saveNewPassword()
            default:
                // change password with firebase:   myTextFields[2].text!
                break
            }
        }
        
        return false
    }
    
    private func saveNewPassword() {
        
        let passwordField = myTextFields[1].text
        let passwordField2 = myTextFields[2].text
        let _oldPassword = myTextFields[0].text
        
        guard let password1 = passwordField else {return}
        guard let password2 = passwordField2 else {return}
        guard let oldPassword = _oldPassword else {return}
        
        guard password1 == password2 else {
            let alert = UIAlertController(title: "Warning", message: "Passwords Do Not Match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard password1.isValidPassword == true else {
            let alert = UIAlertController(title: "Invalid Password", message: "6-20 Characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let user = Auth.auth().currentUser
        let newPassword = password1
        
        let credential = EmailAuthProvider.credential(withEmail: Set1.email, password: oldPassword)
        user?.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "Error reauthenticating user", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                user?.updatePassword(to: newPassword) { (error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "Error changing user password", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.performSegue(withIdentifier: "fromChangePasswordToSettings", sender: self)
                }
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}


