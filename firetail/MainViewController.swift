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
    var slideView = UIView()
    var returnTap = UITapGestureRecognizer()
    var returnPan = UIPanGestureRecognizer()
    var returnSwipe = UISwipeGestureRecognizer()
    var date = UILabel()
    var alertAmount = UILabel()
    var alerts1102 = UILabel()
    var daysOfTheWeek = UILabel()
    var (alerts, changeEmail, addPhone, changeBroker, legal, support, goPremium) = (UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton())
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor.black33
        //menu stuff//
        addLabel(name: date, text: "12 June", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 124, width: 150, height: 32, lines: 1)
        view.addSubview(date)
        addLabel(name: alertAmount, text: "24", textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 52, x: 84, y: 226, width: 150, height: 90, lines: 1)
        view.addSubview(alertAmount)
        addLabel(name: alerts1102, text: "Alerts    $1102", textColor: customColor.alertLines, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 324, width: 260, height: 28, lines: 1)
        view.addSubview(alerts1102)
        addLabel(name: daysOfTheWeek, text: "M  T  W  T  F  S  S", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 14, x: 84, y: 506, width: 260, height: 28, lines: 1)
        view.addSubview(daysOfTheWeek)
        var bar1 = UILabel(frame: CGRect(x: 92*screenWidth/750, y: 406*screenHeight/1334, width: 6*screenWidth/750, height: 74*screenHeight/1334))
        bar1.backgroundColor = customColor.yellow
        view.addSubview(bar1)
        var bar2 = UILabel(frame: CGRect(x: 130*screenWidth/750, y: 446*screenHeight/1334, width: 6*screenWidth/750, height: 34*screenHeight/1334))
        bar2.backgroundColor = customColor.yellow
        view.addSubview(bar2)
        addButton(name: alerts, x: 82, y: 680, width: 280, height: 25, title: "ALERTS", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.alertsFunc(_:)), addSubview: true)
        addButton(name: changeEmail, x: 82, y: 760, width: 280, height: 25, title: "CHANGE EMAIL", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.changeEmailFunc(_:)), addSubview: true)
        addButton(name: addPhone, x: 82, y: 840, width: 280, height: 25, title: "ADD PHONE", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.addPhoneFunc(_:)), addSubview: true)
        addButton(name: changeBroker, x: 82, y: 920, width: 280, height: 25, title: "CHANGE BROKER", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.changeBrokerFunc(_:)), addSubview: true)
        addButton(name: legal, x: 82, y: 1080, width: 280, height: 25, title: "LEGAL", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.legalFunc(_:)), addSubview: true)
        addButton(name: support, x: 82, y: 1160, width: 280, height: 25, title: "SUPPORT", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.supportFunc(_:)), addSubview: true)
        addButton(name: goPremium, x: 82, y: 1240, width: 280, height: 25, title: "GO PREMIUM", font: "Roboto-Medium", fontSize: 14, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.goPremiumFunc(_:)), addSubview: true)
        
        
        
        
        
        
        
        
        //slideview stuff//
        slideView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(slideView)
        slideView.backgroundColor = customColor.black42
        myTextField = UITextField(frame: CGRect(x: 0,y: 100,width: screenWidth ,height: 100*screenHeight/1334))
        myTextField.placeholder = "   Enter Stock Ticker To Enter Graph View"
        myTextField.setValue(customColor.yellow, forKeyPath: "_placeholderLabel.textColor")
        myTextField.font = UIFont.systemFont(ofSize: 15)
        //myTextField.borderStyle = UITextBorderStyle.roundedRect
        myTextField.autocorrectionType = UITextAutocorrectionType.no
        myTextField.keyboardType = UIKeyboardType.default
        myTextField.returnKeyType = UIReturnKeyType.done
        myTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        myTextField.delegate = self
        myTextField.backgroundColor = customColor.background
        myTextField.textColor = customColor.yellow
        slideView.addSubview(myTextField)
        addButton(name: menu, x: 0, y: 0, width: 116, height: 122, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.menuFunc), addSubview: false)
        slideView.addSubview(menu)
        addButton(name: add, x: 638, y: 0, width: 112, height: 120, title: "", font: "", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(MainViewController.addFunc(_:)), addSubview: false)
        slideView.addSubview(add)
        menu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        add.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addLabel(name: stockAlerts, text: "Stock Alerts", textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 60, y: 914, width: 300, height: 40, lines: 1)
        slideView.addSubview(stockAlerts)
        let line = UILabel()
        addLabel(name: line, text: "", textColor: .clear, textAlignment: .center, fontName: "", fontSize: 1, x: 0, y: 970, width: 750, height: 2, lines: 0)
        line.backgroundColor = customColor.alertLines
        slideView.addSubview(line)
        let tslaBlock = AlertBlockView(y: 972, stockTicker: "TSLA", currentPrice: "257", sms: true, email: false, push: true, urgent: false)
        slideView.addSubview(tslaBlock)
        let fbBlock = AlertBlockView(y: 1092, stockTicker: "FB", currentPrice: "135", sms: false, email: false, push: false, urgent: true)
        slideView.addSubview(fbBlock)
        let googBlock = AlertBlockView(y: 1212, stockTicker: "GOOG", currentPrice: "828", sms: true, email: true, push: true, urgent: true)
        slideView.addSubview(googBlock)
        slideView.layer.shadowColor = UIColor.black.cgColor
        slideView.layer.shadowOpacity = 1
        slideView.layer.shadowOffset = CGSize.zero
        slideView.layer.shadowRadius = 10
        returnTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.menuReturnFunc(_:)))
        returnPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.menuReturnFunc(_:)))
        returnSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.menuReturnFunc(_:)))
        

    }
    
    @objc private func alertsFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func changeEmailFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func addPhoneFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func changeBrokerFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func legalFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func supportFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    @objc private func goPremiumFunc(_ sender: UIButton) {
        sender.setTitle("NOT SETUP YET", for: .normal)
    }
    
    func menuFunc() {
        if slideView.frame.origin.x == 0 {
        UIView.animate(withDuration: 0.5) {self.slideView.frame.origin.x += 516*self.screenWidth/750}
            
            slideView.addGestureRecognizer(returnTap)
            slideView.addGestureRecognizer(returnSwipe)
            slideView.addGestureRecognizer(returnPan)
            
            
        }
    }
    func menuReturnFunc(_ gesture: UIGestureRecognizer) {
        if slideView.frame.origin.x != 0 {
            
            UIView.animate(withDuration: 0.5) {self.slideView.frame.origin.x -= 516*self.screenWidth/750}
            slideView.removeGestureRecognizer(returnTap)
            slideView.removeGestureRecognizer(returnSwipe)
            slideView.removeGestureRecognizer(returnPan)
            
        }
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
