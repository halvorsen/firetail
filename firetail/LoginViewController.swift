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
import ReachabilitySwift

class LoginViewController: ViewSetup, UITextFieldDelegate {
    let coverInternet = UIView()
    let reachability = Reachability()!
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
    var tap = UITapGestureRecognizer()
    
  
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard(_:)))
        
        for xVal in Set3.shared.priceRectX {
            Set2.priceRectX.append(xVal*screenWidth/375)
        }
        
        loadsave.loadUsername()
        coverView.frame = view.frame
        coverView.backgroundColor = customColor.black33
        coverView.layer.zPosition = 10
        view.addSubview(coverView)
        imageView.frame.size = CGSize(width: 84*screenWidth/375, height: 108*screenHeight/667)
        imageView.image = #imageLiteral(resourceName: "logo161x207")
        imageView.frame.origin.x = 146*screenWidth/375
        imageView.frame.origin.y = 150*screenHeight/667
        imageView.layer.zPosition = 11
        view.addSubview(imageView)
        
        //reachabilityAddNotification()
        
        firetail.frame = CGRect(x: 0, y: 334*screenHeight/667, width: screenWidth, height: 58*screenHeight/667)
        firetail.text = "FIRETAIL"
        firetail.font = UIFont(name: "Roboto-Bold", size: 27*fontSizeMultiplier)
        firetail.textAlignment = .center
        firetail.textColor = .white
        firetail.backgroundColor = .clear
        firetail.layer.zPosition = 11
        view.addSubview(firetail)
        
        coverInternet.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        coverInternet.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        let imageView2 = UIImageView()
        imageView2.frame = CGRect(x: 127*screenWidth/375, y:64*screenHeight/667, width: 122*screenWidth/375, height: 157*screenHeight/667)
        imageView2.image = #imageLiteral(resourceName: "flames")
        coverInternet.addSubview(imageView2)
        let label = UILabel()
        label.frame = CGRect(x: 0, y:290*screenHeight/667, width: screenWidth, height: 30*screenHeight/667)
        label.text = "NO INTERNET"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Bold", size: fontSizeMultiplier*15)
        coverInternet.addSubview(label)
        coverInternet.layer.zPosition = 50
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
         
        } else {
            do {try Auth.auth().signOut()}catch { }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.alreadyAUser = true
                self.authenticated = true
                if Set1.username != "none" {
                   if self.isFirstLoading {
                    self.loadUserInfoFromFirebase(firebaseUsername: Set1.username)
                    
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
    
    func reachabilityAddNotification() {
        //declare this property where it won't go out of scope relative to your listener
        
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func loadUserInfoFromFirebase(firebaseUsername: String) {
        
        let ref = Database.database().reference()
        
        ref.child("users").child(firebaseUsername).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            Set1.token = value?["token"] as? String ?? "none"
            Set1.fullName = value?["fullName"] as? String ?? "none"
            Set1.email = value?["email"] as? String ?? "none"
            Set1.phone = value?["phone"] as? String ?? "none"
            Set1.premium = value?["premium"] as? Bool ?? false
            Set1.alertCount = value?["numOfAlerts"] as? Int ?? 0
            Set1.brokerName = value?["brokerName"] as? String ?? "none"
            Set1.brokerURL = value?["brokerURL"] as? String ?? "none"
            Set1.weeklyAlerts = value?["weeklyAlerts"] as? [String:Int] ?? ["mon":0,"tues":0,"wed":0,"thur":0,"fri":0]
            if Set1.alertCount > 0 {
                Set1.userAlerts = value?["userAlerts"] as! [String:String]
            }
            
            if Set1.userAlerts.count > 0 {

                var alertID: [String] {
                    var aaa = [String]()
                    for i in 0..<Set1.alertCount {
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
                let uA = Set1.userAlerts
                for i in (0..<Set1.userAlerts.count).reversed() {
                    if uA[alertID[i]] != nil {
                    ref.child("alerts").child(uA[alertID[i]]!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let _deleted = value?["deleted"] as? Bool ?? false
                        
                        if !_deleted {
                            
                            let _name = uA[alertID[i]]!
                            let value = snapshot.value as? NSDictionary
                            let _isGreaterThan = value?["isGreaterThan"] as? Bool ?? false
                            let _price = value?["priceString"] as? String ?? ""
                            let _email = value?["email"] as? Bool ?? false
                            let _flash = value?["flash"] as? Bool ?? false
                            let _sms = value?["sms"] as? Bool ?? false
                            let _ticker = value?["ticker"] as? String ?? ""
                            Set1.ti.append(_ticker)
                            let _push = value?["push"] as? Bool ?? false
                            let _urgent = value?["urgent"] as? Bool ?? false
                            let _triggered = value?["triggered"] as? Bool ?? false
                            let _timestamp = value?["data1"] as? Int ?? 1
                            Set1.alerts[uA[alertID[i]]!] = (_name, _isGreaterThan, _price, _deleted, _email, _flash, _sms, _ticker, _triggered, _push, _urgent, _timestamp)
                        }
                        self.ti = Set1.ti
                        if self.ti.count != 0 {
                            
                            self.fetch()
                            
                        } else {
                            if self.isFirstTimeSeguing {
                                self.isFirstTimeSeguing = false
                                self.performSegue(withIdentifier: "fromLoginToAddStockTicker", sender: self)
                            }
                        }
                        
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    }
                }
                Set1.saveUserInfo()
            } else {
                self.performSegue(withIdentifier: "fromLoginToAddStockTicker", sender: self)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
        
            removeNoInternetCover()
                
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            DispatchQueue.main.async {
            self.addNoInternetCover()
            }
        }
    }
    func removeNoInternetCover() {
        if coverInternet.isDescendant(of: view) {
        coverInternet.removeFromSuperview()
        }
    }
    func addNoInternetCover() {
        
        
        view.addSubview(coverInternet)
        
    }

    
    func textFieldDidBeginEditing(_ textField : UITextField)
        
    {
        view.addGestureRecognizer(tap)
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
                guard i < 6 else {return}
                getOneYearData(stockName: ti[i]) {
                    
                    if $0 == nil {
                        self._ti.append($1)
                        self.retry = true
                        self.noNils = false
                    }
                    if !stockStrings.contains($1) && $0 != nil {
                        stockStrings.append($1)
                        
                        Set1.oneYearDictionary[$1] = $0
                    }
                    
                    j += 1
                    if (j == self.ti.count && self.noNils) || (6 == j && self.noNils) {
                        
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
        
        var cleanString = myTextFields[0].text!
        cleanString = cleanString.replacingOccurrences(of: ".", with: ",")
        cleanString = cleanString.replacingOccurrences(of: "$", with: "")
        cleanString = cleanString.replacingOccurrences(of: "#", with: "")
        cleanString = cleanString.replacingOccurrences(of: "[", with: "(")
        cleanString = cleanString.replacingOccurrences(of: "]", with: ")")
        cleanString = cleanString.replacingOccurrences(of: "/", with: "")
        
        loadsave.saveUsername(username: cleanString)
        Set1.username = cleanString
        
        Auth.auth().signIn(withEmail: myTextFields[0].text!, password: myTextFields[1].text!, completion: { (user, error) in
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
        
        //  if doneLoading && !retry { // check if alert stocks have loaded
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
        if textField.text != nil && textField.delegate != nil {
            
            //do something with the --> textField.text!
            
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToAddStockTicker" {
            
            let addView: AddStockTickerViewController = segue.destination as! AddStockTickerViewController
            
            addView.newAlertTicker = "TICKER"
        }
    }
}
