//
//  AlertBlockView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

protocol deleteAlertDelegate: class {
    func act(blockLongName: String)
    var scrolling:Bool {get}
}

class AlertBlockView: UIView, UIGestureRecognizerDelegate {
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
    var stockTickerGlobal: String = ""
    var currentPriceGlobal: String = ""
    var smsGlobal: Bool = false
    var emailGlobal: Bool = false
    var flashGlobal: Bool = false
    var urgentGlobal: Bool = false
    var blockLongName = String()
    var priceDouble = Double()
    let xAlphaStart: CGFloat = 0.1
    let xAlphaEnd: CGFloat = 1.0
    var x = UIImageView()
    var deleteDelegate:deleteAlertDelegate?
    
    init() {super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))}
    init(y: CGFloat, stockTicker: String, currentPrice: String, sms: Bool = false, email: Bool = false, flash: Bool = false, urgent: Bool = false, longName: String, push: Bool = false, isGreaterThan: Bool, timestamp: Int, triggered: Bool) {
        super.init(frame: CGRect(x: 0, y: y*screenHeight/1334, width: screenWidth, height: 120*screenHeight/1334))
        blockLongName = longName
        stockTickerGlobal = stockTicker
        currentPriceGlobal = currentPrice
        smsGlobal = sms
        emailGlobal = email
        flashGlobal = flash
        urgentGlobal = urgent
        priceDouble = Double(currentPriceGlobal.chopPrefix())!
        self.backgroundColor = customColor.white249
        
        addButton(name: ex, x: 750 - 120, y: 0, width: 120, height: 120, title: "", font: "HelveticaNeue-light", fontSize: 40, titleColor: customColor.black33, bgColor: customColor.white249, cornerRad: 0, boarderW: 0, boarderColor: .clear, addSubview: true)
        
        x.image = #imageLiteral(resourceName: "ex")
        x.frame.size = CGSize(width: 16*screenWidth/375, height: 16*screenWidth/375)
        x.frame.origin = CGPoint(x: 44*screenWidth/750, y: 44*screenWidth/750)
        x.alpha = xAlphaStart
        ex.addSubview(x)
        
        ex.setTitle(longName, for: .disabled)
        slideView.backgroundColor = customColor.background
        slideView.frame = self.bounds
        self.addSubview(slideView)

        let _stockTicker = stockTicker.uppercased()
        addLabel(name: stockTickerLabel, text: _stockTicker, textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 60, y: 70, width: 100, height: 36, lines: 1, alpha: 0.5)
        slideView.addSubview(stockTickerLabel)
        var alerts = ""
        if urgent {
            alerts += "All"
        } else {
            if email {
                alerts += "Email"
            }
            if alerts != "" && alerts.characters.last != " "  {
                alerts += ", "
            }
            if sms {
                alerts += "SMS"
            }
            if alerts != "" && alerts.characters.last != " " {
                alerts += ", "
            }
            if push {
                alerts += "Push"
            }
            if alerts != "" && alerts.characters.last != " " {
                alerts += ", "
            }
            
            if flash {
                alerts += "Flash"
            }
            if alerts != "" && alerts.characters.last != " "  {
                alerts += ", "
            }
            
            if alerts.characters.last == " "  {
                alerts.remove(at: alerts.index(before: alerts.endIndex))
                alerts.remove(at: alerts.index(before: alerts.endIndex))
            }
        }
        addLabel(name: alertList, text: alerts, textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 260, y: 70, width: 352, height: 36, lines: 1, alpha: 0.5)
        slideView.addSubview(alertList)
        let _currentPrice = currentPrice //"$" + String(format: "%.2f", currentPrice)
        addLabel(name: stockPrice, text: _currentPrice, textColor: customColor.yellow, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 13, x: 620, y: 70, width: 130, height: 36, lines: 1)
        if !isGreaterThan {
            stockPrice.textColor = customColor.red
        }
        if triggered {
            stockPrice.textColor = .white
            stockPrice.alpha = 0.5
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "lighteningBolt")
            imageView.frame = CGRect(x: 91*screenWidth/375, y: 31*screenHeight/667, width: 14*screenWidth/375, height: 18*screenHeight/667)
            slideView.addSubview(imageView)
        }
        slideView.addSubview(stockPrice)
        addLabel(name: line, text: "", textColor: .clear, textAlignment: .center, fontName: "", fontSize: 1, x: 0, y: 118, width: 750, height: 2, lines: 0)
        line.backgroundColor = customColor.alertLines
        
        slideView.addSubview(line)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return false
    }
}
