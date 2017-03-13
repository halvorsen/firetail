//
//  SignupViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/27/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard

class SignupViewController: ViewSetup, UITextFieldDelegate {
    var customColor = CustomColor()
    var login = UIButton()
    var username = UILabel()
    var continueB = UIButton()
    var createAccount = UILabel()
    var myTextFields = [UITextField]()
    var doneLoading = false
    var progressHUD = ProgressHUD(text: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for stock in ["t","k","fig"] {
            getOneMonthData(stockName: stock) {
                
                Set.oneYearDictionary[$1] = $0
                if stock == "fig" {
                    self.doneLoading = true
                }
            }
            
        }

        view.backgroundColor = customColor.black33
        var logo = UIImageView(frame: CGRect(x: screenWidth/2 - 93*screenHeight/1334, y: 42*screenHeight/667, width: 93*screenHeight/667, height: 119*screenHeight/667))
        logo.image = #imageLiteral(resourceName: "logo93x119")
        view.addSubview(logo)
        let accountView = UIView(frame: CGRect(x: 0, y: 266*screenHeight/667, width: screenWidth, height: 401*screenHeight/667))
        accountView.backgroundColor = customColor.black30
        view.addSubview(accountView)
        addButton(name: login, x: 0, y: 400, width: 254, height: 76, title: "LOGIN", font: "Roboto-Bold", fontSize: 15, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(SignupViewController.loginFunc(_:)), addSubview: true, alignment: .center)
        addLabel(name: username, text: "as Jordan Halvorsen", textColor: .white, textAlignment: .right, fontName: "Roboto-Medium", fontSize: 15, x: 200, y: 400, width: 470, height: 76, lines: 1)
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
                myTextField.placeholder = "Password"
            default:
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
            myTextFields.append(myTextField)
        }
    }
    
    @objc private func loginFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromSignupToLogin", sender: self)
        
    }
    @objc private func continueFunc(_ sender: UIButton) {
        if doneLoading { // check if alert stocks have loaded
        self.performSegue(withIdentifier: "fromSignupToMain", sender: self)
        } else {
               self.view.addSubview(progressHUD)
            let myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SignupViewController.checkIfDone), userInfo: nil, repeats: true)
        }
        
    }
    
    func checkIfDone() {
        if doneLoading {
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
    
    func getOneMonthData(stockName: String, result: @escaping (_ closingPrices: ([Double]?), _ stockName: String) -> Void) {
        print("stockname: \(stockName)")
        BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
            
            var stockData = [Double]()
            
            stock.mapOneYearChartDataModule({
                
                print("stockname: \(stockName)")
                
                for point in (stock.oneYearChartModule?.dataPoints)! {
                    
                    // stockData.dates.append(point.date)
                    stockData.append(point.close)
                    
                    print("\(point.close!)" + ",")
                }
                
                result(stockData, stockName)
                
            }, failure: { (error) in
                print(error)
                result(nil, stockName)
            })
            
        }) { (error) in
            print(error)
            result(nil, stockName)
        }
        
        
        
    }
    
    
    
}
