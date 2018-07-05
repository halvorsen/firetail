//
//  addStockTickerViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import ReachabilitySwift

class AddStockTickerViewController: ViewSetup, UITextFieldDelegate {
    
    let backArrow = UIButton()
    let quickPick = UILabel()
    var stockSymbolTextField = UITextField()
    let stockSymbol = UILabel()
    var newAlertTicker = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColor.black24
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockTickerViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        addLabel(name: quickPick, text: "QUICK PICK", textColor: CustomColor.labelGray, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 11, x: 36, y: 180, width: 200, height: 44, lines: 1)
        view.addSubview(quickPick)
        let boxButtons:[(CGFloat,CGFloat,String)] = [
            
            (220,164,"TSLA"),
            (484,164,"AAPL"),
            (40,282,"AMZN"),
            (304,282,"NFLX"),
            (568,282,"T"),
            (-46,400,"FB"),
            (220,400,"GPRO"),
            (484,400,"NKE"),
            (40,520,"TWTR"),
            (304,520,"SNAP"),
            (568,520,"VZ")
          
        ]
        
        for (x,y,ticker) in boxButtons {
            let myButton = UIButton()
            addButton(name: myButton, x: x, y: y, width: 216, height: 70, title: ticker, font: "Roboto-Bold", fontSize: 18, titleColor: .black, bgColor: .white, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockTickerViewController._quickPickFunc(_:)), addSubview: true)
            myButton.contentHorizontalAlignment = .center
        }
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: CustomColor.labelGray, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 60, y: 808, width: 400, height: 42, lines: 1)
        view.addSubview(stockSymbol)
        stockSymbolTextField.delegate = self
        stockSymbolTextField = UITextField(frame: CGRect(x: 30*screenWidth/375,y: 368*screenHeight/667,width: 110*screenWidth/375 ,height: 28*screenHeight/667))
        stockSymbolTextField.placeholder = "Search"
        stockSymbolTextField.textAlignment = .left
        stockSymbolTextField.clearsOnBeginEditing = true
        stockSymbolTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        stockSymbolTextField.font = UIFont(name: "DroidSerif-Regular", size: 20*fontSizeMultiplier)
        stockSymbolTextField.autocorrectionType = UITextAutocorrectionType.no
        stockSymbolTextField.keyboardType = UIKeyboardType.default
        stockSymbolTextField.returnKeyType = UIReturnKeyType.done
        stockSymbolTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        stockSymbolTextField.delegate = self
        stockSymbolTextField.backgroundColor = .clear
        stockSymbolTextField.textColor = .white
        stockSymbolTextField.keyboardAppearance = .dark
        view.addSubview(stockSymbolTextField)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stockSymbolTextField.becomeFirstResponder()
        
        reachabilityAddNotification()
        
    }
    
    @objc private func back(_ sender: UIButton) {
        performSegue(withIdentifier: "fromAddStockTickerToMain", sender: self)
    }
    
    @objc private func quickPickFunc(callback: (_ isGoodToGo: Bool) -> Void) {
        
        var isGoodToGo = false
        
        if IndexListOfStocks.amex.contains(newAlertTicker) || IndexListOfStocks.nyse.contains(newAlertTicker) || IndexListOfStocks.nasdaq.contains(newAlertTicker) || IndexListOfStocks.otcmkts.contains(newAlertTicker) {
            
            isGoodToGo = true
            let charArray = newAlertTicker.map { String($0) }
            
            for char in charArray {
                if char == "^" || char == "~" {
                    isGoodToGo = false
                    
                    callback(isGoodToGo)
                }
            }
            
            callback(isGoodToGo)
        } else {
            
            callback(isGoodToGo)
        }
        
    }
    
    private func __quickPickFunc() {
        
        quickPickFunc() { [weak self] (isGoodToGo) -> Void in
            guard let weakself = self else {return}
            if isGoodToGo {
                weakself.performSegue(withIdentifier: "fromAddStockTickerToAddStockPrice", sender: weakself)
            } else {
                let alert = UIAlertController(title: "", message: "Ticker Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                weakself.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func _quickPickFunc(_ sender: UIButton) {
        guard let title = sender.titleLabel,
            let newAlertTicker = title.text else {return}
        self.newAlertTicker = newAlertTicker
        quickPickFunc() { [weak self] (isGoodToGo) -> Void in
            guard let weakself = self else {return}
            if isGoodToGo {
                
                weakself.performSegue(withIdentifier: "fromAddStockTickerToAddStockPrice", sender: weakself)
            } else {
                
                let alert = UIAlertController(title: "", message: "Ticker Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                weakself.present(alert, animated: true, completion: nil)
            }
        }
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
            __quickPickFunc()
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddStockTickerToAddStockPrice" {
            if let destinationViewController: AddStockPriceViewController = segue.destination as? AddStockPriceViewController {
                destinationViewController.newAlertTicker = newAlertTicker
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
}
