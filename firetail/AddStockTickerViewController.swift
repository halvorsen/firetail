//
//  addStockTickerViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import ReachabilitySwift

final class AddStockTickerViewController: ViewSetup, UITextFieldDelegate {
    
    let backArrow = UIButton()
    let quickPick = UILabel()
    var stockSymbolTextField = UITextField()
    let stockSymbol = UILabel()
    var newAlertTicker = String()
    var signIn = false
    
    func switchBackbuttonToAccountsButton() {
        backArrow.setImage(nil, for: .normal)
        backArrow.setTitle("Account", for: .normal)
        backArrow.setTitleColor(.white, for: .normal)
        backArrow.contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 20)
        backArrow.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        backArrow.frame.size = backArrow.intrinsicContentSize
        signIn = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColor.black24
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockTickerViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        addLabel(name: quickPick, text: "QUICK PICK", textColor: CustomColor.labelGray, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 11, x: 36, y: 180, width: 200, height: 44, lines: 1)
        quickPick.frame.origin.y = 180 * UIScreen.main.bounds.width/750
        view.addSubview(quickPick)
        let boxButtons:[(CGFloat,CGFloat,String)] = [
            
            (220,164,"BTC"),
            (484,164,"TSLA"),
            (40,282,"AMZN"),
            (304,282,"NFLX"),
            (568,282,"ETH"),
            (-46,400,"FB"),
            (220,400,"ZRX"),
            (484,400,"NKE"),
            (40,520,"TWTR"),
            (304,520,"SNAP"),
            (568,520,"BAT")
          
        ]
        
        for (x,y,ticker) in boxButtons {
            let myButton = UIButton()
            addButton(name: myButton, x: x, y: y, width: 216, height: 70, title: ticker, font: "Roboto-Bold", fontSize: 18, titleColor: .black, bgColor: .white, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockTickerViewController.quickPickFunc(_:)), addSubview: true)
            myButton.frame.origin.y = y * UIScreen.main.bounds.width/750
            myButton.contentHorizontalAlignment = .center
        }
        
        addLabel(name: stockSymbol, text: "symbol", textColor: CustomColor.labelGray, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 60, y: 808, width: 400, height: 42, lines: 1)
        view.addSubview(stockSymbol)
        stockSymbolTextField.delegate = self
        stockSymbolTextField = UITextField(frame: CGRect(x: 30*screenWidth/375,y: 368*screenHeight/667,width: 110*screenWidth/375 ,height: 28*screenHeight/667))
        stockSymbolTextField.placeholder = "SEARCH"
        stockSymbolTextField.textAlignment = .left
        stockSymbolTextField.clearsOnBeginEditing = true
        stockSymbolTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        stockSymbolTextField.font = UIFont(name: "DroidSerif-Regular", size: 20*fontSizeMultiplier)
        stockSymbolTextField.autocorrectionType = UITextAutocorrectionType.no
        stockSymbolTextField.keyboardType = UIKeyboardType.default
        stockSymbolTextField.returnKeyType = UIReturnKeyType.done
        stockSymbolTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        stockSymbolTextField.delegate = self
        stockSymbolTextField.backgroundColor = .clear
        stockSymbolTextField.textColor = .white
        stockSymbolTextField.keyboardAppearance = .dark
        view.addSubview(stockSymbolTextField)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let email = UserInfo.currentUserEmail {
            backArrow.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stockSymbolTextField.becomeFirstResponder()
        
        reachabilityAddNotification()
        if Reachability()!.isReachable {
            if UserInfo.currentUserUID == nil {
                UserInfo.signInAnonymously()
            }
        }
    }
    
    @objc private func back(_ sender: UIButton) {
        if signIn {
            present(SignupViewController(), animated: true, completion: nil)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func transitionAndFetch() {
        if Binance.isCryptoTickerSupported(ticker: newAlertTicker) {
            UserInfo.dashboardMode = .crypto
        } else {
        UserInfo.dashboardMode = .stocks
        }
        DashboardViewController.shared.refreshCompareGraph()
        let viewController = AddStockPriceViewController()
        viewController.newAlertTicker = newAlertTicker
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
        
    }
    
    @objc private func quickPickFunc(_ sender: UIButton) {
        
        guard let title = sender.titleLabel, let newAlertTicker = title.text else {return}
        self.newAlertTicker = newAlertTicker
        transitionAndFetch()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.spellCheckingType = .no
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if stockSymbolTextField.text != nil && stockSymbolTextField.delegate != nil {
            newAlertTicker = stockSymbolTextField.text!.uppercased()
            transitionAndFetch()
        }
        return false
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}
