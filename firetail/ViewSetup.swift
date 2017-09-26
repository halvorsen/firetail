//
//  Setup.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ViewSetup: UIViewController {
    
    //Reachability
    
    @objc let coverInternet = UIView()
    let reachability = Reachability()!
    
    @objc func reachabilityAddNotification() {
        //declare this property where it won't go out of scope relative to your listener
        
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        
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
        
    }
    
    @objc func reachabilityRemoveNotification() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
    
    
    @objc func reachabilityChanged(note: NSNotification) {
        
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
    
    @objc func removeNoInternetCover() {
        DispatchQueue.main.async {
            if self.coverInternet.isDescendant(of: self.view) {
                self.coverInternet.removeFromSuperview()
            }
        }
        
    }
    
    @objc func addNoInternetCover() {
        view.addSubview(coverInternet)
    }

    @objc var screenWidth: CGFloat {get{return UIScreen.main.bounds.width}}
    @objc var screenHeight: CGFloat {get{return UIScreen.main.bounds.height}}
    @objc var fontSizeMultiplier: CGFloat {get{return UIScreen.main.bounds.width / 375}}
    @objc var topMargin: CGFloat {get{return (269/1332)*UIScreen.main.bounds.height}}
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    
    @objc func addButton(name: UIButton, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, font: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor, cornerRad: CGFloat, boarderW: CGFloat, boarderColor: UIColor, act:
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
    
    @objc func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int) {
        
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
        
        @objc var text: String? {
            didSet {
                label.text = text
            }
        }
        
        @objc let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        @objc let label: UILabel = UILabel()
        @objc let blurEffect = UIBlurEffect(style: .light)
        @objc let vibrancyView: UIVisualEffectView
        
        @objc init(text: String) {
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
        
        @objc func setup() {
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
        
        @objc func show() {
            self.isHidden = false
        }
        
        @objc func hide() {
            self.isHidden = true
        }
    }
    
    @objc func userWarning(title: String, message: String, answer: String = "Okay") {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
    
        }))
        
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
}

extension String {
    subscript(pos: Int) -> String {
        precondition(pos >= 0, "character position can't be negative")
        return self[pos...pos]
    }
    subscript(range: CountableRange<Int>) -> String {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)])
    }
    subscript(range: ClosedRange<Int>) -> String {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)])
    }
}

extension String {
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
 
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    
    
    
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
}

