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
    
    //  init() {super.init(frame: CGRect)}
    init(y: CGFloat, stockTicker: String, currentPrice: String, sms: Bool = false, email: Bool = false, push: Bool = false, urgent: Bool = false) {
        super.init(frame: CGRect(x: 0, y: y*screenHeight/1334, width: screenWidth, height: 120*screenHeight/1334))
        self.backgroundColor = customColor.background
        let _stockTicker = stockTicker.uppercased()
        addLabel(name: stockTickerLabel, text: _stockTicker, textColor: .white, textAlignment: .left, fontName: "Roboto-Regular", fontSize: 15, x: 60, y: 70, width: 100, height: 36, lines: 1, alpha: 0.5)
        self.addSubview(stockTickerLabel)
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
        if push {
            alerts += "Push"
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
        self.addSubview(alertList)
        let _currentPrice = "$" + currentPrice
        addLabel(name: stockPrice, text: _currentPrice, textColor: customColor.yellow, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 620, y: 70, width: 130, height: 36, lines: 1)
        self.addSubview(stockPrice)
        addLabel(name: line, text: "", textColor: .clear, textAlignment: .center, fontName: "", fontSize: 1, x: 0, y: 118, width: 750, height: 2, lines: 0)
        line.backgroundColor = customColor.alertLines
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
