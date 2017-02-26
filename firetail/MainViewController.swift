//
//  MainViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

class MainViewController: ViewSetup, UITextFieldDelegate {
    
    var myTextField = UITextField()
    var stringToPass = "Patriots"
    let customColor = CustomColor()
    var menu = UIButton()
    var add = UIButton()
    var stockAlerts = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor.background
        myTextField = UITextField(frame: CGRect(x: 0,y: 100,width: screenWidth ,height: 100*screenHeight/1334))
        myTextField.placeholder = "Enter Stock Ticker To Enter Graph View"
        myTextField.setValue(customColor.yellow, forKeyPath: "_placeholderLabel.textColor")
        myTextField.font = UIFont.systemFont(ofSize: 15)
        myTextField.borderStyle = UITextBorderStyle.roundedRect
        myTextField.autocorrectionType = UITextAutocorrectionType.no
        myTextField.keyboardType = UIKeyboardType.default
        myTextField.returnKeyType = UIReturnKeyType.done
        myTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        myTextField.delegate = self
        myTextField.backgroundColor = customColor.background
        myTextField.textColor = customColor.yellow
        self.view.addSubview(myTextField)
        addButton(name: menu, x: 42, y: 46, width: 32, height: 30, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.menuFunc(_:)), addSubview: true)
        addButton(name: add, x: 664, y: 40, width: 40, height: 40, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.addFunc(_:)), addSubview: true)
        menu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        add.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addLabel(name: stockAlerts, text: "Stock Alerts", textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 60, y: 914, width: 300, height: 40, lines: 1)
        view.addSubview(stockAlerts)
        let line = UILabel()
        addLabel(name: line, text: "", textColor: .clear, textAlignment: .center, fontName: "", fontSize: 1, x: 0, y: 970, width: 750, height: 2, lines: 0)
        line.backgroundColor = customColor.alertLines
        view.addSubview(line)
        let tslaBlock = AlertBlockView(y: 972, stockTicker: "TSLA", currentPrice: "257", sms: true, email: false, push: true, urgent: false)
        view.addSubview(tslaBlock)
        let fbBlock = AlertBlockView(y: 1092, stockTicker: "FB", currentPrice: "135", sms: false, email: false, push: false, urgent: true)
        view.addSubview(fbBlock)

    }
    
    @objc private func menuFunc(_ sender: UIButton) {
    
    
    }
    @objc private func addFunc(_ sender: UIButton) {
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        if myTextField.text != nil && myTextField.delegate != nil {
            
            stringToPass = myTextField.text!
            goToGraph()
        }
        return false
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let graphView: GraphViewController = segue.destination as! GraphViewController
        
        graphView.passedString = stringToPass
        
    }
    
    @objc private func goToGraph() {
        self.performSegue(withIdentifier: "fromMainToGraph", sender: self)
    }

}
