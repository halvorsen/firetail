//
//  addStockTickerViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

class AddStockTickerViewController: ViewSetup, UITextFieldDelegate {
    let backArrow = UIButton()
    let quickPick = UILabel()
    let customColor = CustomColor()
    var stockSymbolTextField = UITextField()
    let stockSymbol = UILabel()
    var newAlertTicker = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockTickerViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        addLabel(name: quickPick, text: "QUICK PICK", textColor: customColor.labelGray, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 11, x: 36, y: 180, width: 200, height: 44, lines: 1)
        
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
            //216x70
        ]
        
        for (x,y,ticker) in boxButtons {
            let myButton = UIButton()
            addButton(name: myButton, x: x, y: y, width: 216, height: 70, title: ticker, font: "Roboto-Bold", fontSize: 18, titleColor: .black, bgColor: .white, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockTickerViewController.quickPickFunc(_:)), addSubview: true)
        }
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: customColor.labelGray, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 60, y: 808, width: 400, height: 42, lines: 1)
        view.addSubview(stockSymbol)
        
        stockSymbolTextField = UITextField(frame: CGRect(x: 30*screenWidth/375,y: 368*screenHeight/667,width: 110*screenWidth/375 ,height: 28*screenHeight/667))
        stockSymbolTextField.placeholder = "TS"
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
    }
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockTickerToMain", sender: self)
    }
    
    @objc private func quickPickFunc(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddStockTickerToMain", sender: self)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.spellCheckingType = .no
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if stockSymbolTextField.text != nil && stockSymbolTextField.delegate != nil {
          newAlertTicker = stockSymbolTextField.text!.uppercased()
          self.performSegue(withIdentifier: "fromAddStockTickerToAddStockPrice", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddStockTickerToAddStockPrice" {
            let destinationViewController: AddStockPriceViewController = segue.destination as! AddStockPriceViewController
            
            destinationViewController.newAlertTicker = newAlertTicker
        }
    }

}
