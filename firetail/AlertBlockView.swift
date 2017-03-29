//
//  AlertBlockView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

class AlertBlockView: UIView {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
    var stockTickerLabel = UILabel()
    var alertList = UILabel()
    var stockPrice = UILabel()
    let customColor = CustomColor()
    let line = UILabel()
    var slideView = UIView()
    var tap = UITapGestureRecognizer()
    var ex = UIButton()
    var up = UIButton()
    var info = UIButton()
    var stockTickerGlobal: String = ""
    var currentPriceGlobal: Double = 0.0
    var smsGlobal: Bool = false
    var emailGlobal: Bool = false
    var flashGlobal: Bool = false
    var urgentGlobal: Bool = false
    
    init() {super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))}
    init(y: CGFloat, stockTicker: String, currentPrice: Double, sms: Bool = false, email: Bool = false, flash: Bool = false, urgent: Bool = false) {
        super.init(frame: CGRect(x: 0, y: y*screenHeight/1334, width: screenWidth, height: 120*screenHeight/1334))
        stockTickerGlobal = stockTicker
        currentPriceGlobal = currentPrice
        smsGlobal = sms
        emailGlobal = email
        flashGlobal = flash
        urgentGlobal = urgent
        let t = stockTicker
        self.backgroundColor = customColor.white153
        
        addButton(name: ex, x: 750 - 83.3, y: 0, width: 83.3, height: 120, title: "x", font: "HelveticalNeue-Bold", fontSize: 20, titleColor: .white, bgColor: customColor.white115, cornerRad: 0, boarderW: 0, boarderColor: .clear, addSubview: true)
        ex.setTitle(stockTicker, for: .disabled)
        slideView.backgroundColor = customColor.background
        slideView.frame = self.bounds
        slideView.layer.shadowColor = UIColor.black.cgColor
        slideView.layer.shadowOpacity = 0.7
        slideView.layer.shadowOffset = CGSize(width: 1, height: 1)
        slideView.layer.shadowRadius = 1
        self.addSubview(slideView)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(AlertBlockView.slide(_:)))
        swipe.direction = .left
        slideView.addGestureRecognizer(swipe)
        
        let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(AlertBlockView.slideR(_:)))
        swipeR.direction = .right
        slideView.addGestureRecognizer(swipeR)
        
        let pan = UISwipeGestureRecognizer(target: self, action: #selector(AlertBlockView.move(_:)))
        slideView.addGestureRecognizer(pan)
        let _stockTicker = stockTicker.uppercased()
        addLabel(name: stockTickerLabel, text: _stockTicker, textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 60, y: 70, width: 100, height: 36, lines: 1, alpha: 0.5)
        slideView.addSubview(stockTickerLabel)
        var alerts = ""
        if sms {
            alerts += "SMS"
        }
        if alerts != "" && alerts.characters.last != " " {
            alerts += ", "
        }
        if email {
            alerts += "Email"
        }
        if alerts != "" && alerts.characters.last != " "  {
            alerts += ", "
        }
        if flash {
            alerts += "Flash"
        }
        if alerts != "" && alerts.characters.last != " "  {
            alerts += ", "
        }
        if urgent {
            alerts += "Urgent"
        }
        if alerts.characters.last == " "  {
            alerts.remove(at: alerts.index(before: alerts.endIndex))
            alerts.remove(at: alerts.index(before: alerts.endIndex))
        }
        addLabel(name: alertList, text: alerts, textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 260, y: 70, width: 352, height: 36, lines: 1, alpha: 0.5)
        slideView.addSubview(alertList)
        let _currentPrice = "$" + String(format: "%.2f", currentPrice)
        addLabel(name: stockPrice, text: _currentPrice, textColor: customColor.yellow, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 620, y: 70, width: 130, height: 36, lines: 1)
        slideView.addSubview(stockPrice)
        addLabel(name: line, text: "", textColor: .clear, textAlignment: .center, fontName: "", fontSize: 1, x: 0, y: 118, width: 750, height: 2, lines: 0)
        line.backgroundColor = customColor.alertLines
        
        slideView.addSubview(line)
  
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func move(_ gesture: UIGestureRecognizer) {
        
    }
    
    @objc private func slide(_ gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.6) {
        if self.slideView.frame.origin.x == 0 {
            self.slideView.frame.origin.x = -self.screenWidth/9 - 1
            let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(AlertBlockView.slideR(_:)))
            swipeR.direction = .right
            self.slideView.addGestureRecognizer(swipeR)
        } else {
            self.slideView.frame.origin.x = 0
        }
        }
    }
    
    @objc private func slideR(_ gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.6) {
            
                self.slideView.frame.origin.x = 0
            
        }
    }
 
    func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int, alpha: CGFloat = 1.0) {
        name.text = text
        name.textColor = textColor
        name.textAlignment = textAlignment
        name.font = UIFont(name: fontName, size: fontSizeMultiplier*fontSize)
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: (width/750)*screenWidth, height: (height/750)*screenWidth)
        name.numberOfLines = lines
        name.alpha = alpha
    }
    
    func addButton(name: UIButton, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, font: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor, cornerRad: CGFloat, boarderW: CGFloat, boarderColor: UIColor,  addSubview: Bool, alignment: UIControlContentHorizontalAlignment = .center) {
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: width*screenWidth/750, height: height*screenWidth/750)
        name.setTitle(title, for: UIControlState.normal)
        name.titleLabel!.font = UIFont(name: font, size: fontSizeMultiplier*fontSize)
        name.setTitleColor(titleColor, for: .normal)
        name.backgroundColor = bgColor
        name.layer.cornerRadius = cornerRad
        name.layer.borderWidth = boarderW
        name.layer.borderColor = boarderColor.cgColor
        
        name.contentHorizontalAlignment = alignment
        if addSubview {
            self.addSubview(name)
        }
    }
}
