//
//  Setup.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

struct CustomColor {
    

    //yellow
    var yellow = UIColor(red: 254/255, green: 203/255, blue: 9/255, alpha: 1.0)
    
    //gray
    var gray = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0)

    //background
    var background = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    
    //gridGray
    var gridGray = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.05)
    
    //black
    var black = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
    
    //white
    var white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    //white209
    var white209 = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0)
    //white128
    var white128 = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    //white68
    var white68 = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
    //white77
    var white77 = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
    
    
    //labelGray
    var labelGray = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    
    //alertLines
    var alertLines = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.1)
    
    //fieldLines
    var fieldLines = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.1)
    
    //black33
    var black33 = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    //black42
    var black42 = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
    //black30
    var black30 = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
    //black24
    var black24 = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1.0)
}

class ViewSetup: UIViewController {
    
    var screenWidth: CGFloat {get{return UIScreen.main.bounds.width}}
    var screenHeight: CGFloat {get{return UIScreen.main.bounds.height}}
    var fontSizeMultiplier: CGFloat {get{return UIScreen.main.bounds.width / 375}}
    var topMargin: CGFloat {get{return (269/1332)*UIScreen.main.bounds.height}}
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func addButton(name: UIButton, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, font: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor, cornerRad: CGFloat, boarderW: CGFloat, boarderColor: UIColor, act:
        Selector, addSubview: Bool, alignment: UIControlContentHorizontalAlignment = .left) {
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: width*screenWidth/750, height: height*screenWidth/750)
        name.setTitle(title, for: UIControlState.normal)
        name.titleLabel!.font = UIFont(name: font, size: fontSizeMultiplier*fontSize)
        name.setTitleColor(titleColor, for: .normal)
        name.backgroundColor = bgColor
        name.layer.cornerRadius = cornerRad
        name.layer.borderWidth = boarderW
        name.layer.borderColor = boarderColor.cgColor
        name.addTarget(self, action: act, for: .touchUpInside)
        name.contentHorizontalAlignment = alignment
        if addSubview {
            view.addSubview(name)
        }
    }
    
    func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int) {
        
        name.text = text
        name.textColor = textColor
        name.textAlignment = textAlignment
        name.font = UIFont(name: fontName, size: fontSizeMultiplier*fontSize)
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: (width/750)*screenWidth, height: (height/750)*screenWidth)
        name.numberOfLines = lines
        
    }
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    
    class ProgressHUD: UIVisualEffectView {
        
        var text: String? {
            didSet {
                label.text = text
            }
        }
        
        let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        let label: UILabel = UILabel()
        let blurEffect = UIBlurEffect(style: .light)
        let vibrancyView: UIVisualEffectView
        
        init(text: String) {
            self.text = text
            self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
            super.init(effect: blurEffect)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.text = ""
            self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
            super.init(coder: aDecoder)
            self.setup()
        }
        
        func setup() {
            contentView.addSubview(vibrancyView)
            contentView.addSubview(activityIndictor)
            contentView.addSubview(label)
            activityIndictor.startAnimating()
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            if let superview = self.superview {
                
                let width = superview.frame.size.width / 2.3
                let height: CGFloat = 50.0
                self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                    y: superview.frame.height / 2 - height / 2,
                                    width: width,
                                    height: height)
                vibrancyView.frame = self.bounds
                
                let activityIndicatorSize: CGFloat = 40
                activityIndictor.frame = CGRect(x: 5,
                                                y: height / 2 - activityIndicatorSize / 2,
                                                width: activityIndicatorSize,
                                                height: activityIndicatorSize)
                
                layer.cornerRadius = 8.0
                layer.masksToBounds = true
                label.text = text
                label.textAlignment = NSTextAlignment.center
                label.frame = CGRect(x: activityIndicatorSize + 5,
                                     y: 0,
                                     width: width - activityIndicatorSize - 15,
                                     height: height)
                label.textColor = UIColor.gray
                label.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
        
        func show() {
            self.isHidden = false
        }
        
        func hide() {
            self.isHidden = true
        }
    }

}
