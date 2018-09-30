//
//  PremiumInformationViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/21/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit

final class PremiumInformationViewController: UIViewController {
    
    let star = UIImageView(image: #imageLiteral(resourceName: "yellowStar"))
    let stack = UIStackView()
    let textView = UITextView()
    let premiumAlerts = UILabel()
    let backButton = UIButton()
    let goPremium = UIButton()

    override func viewDidLoad() {
        view.backgroundColor = CustomColor.black33
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.layoutMargins = UIEdgeInsets(top: 40, left: 5, bottom: 40, right: 5)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 30
        view.addSubview(stack)
        [star,premiumAlerts,textView].forEach { stack.addArrangedSubview($0) }
        goPremium.setTitle("GO PREMIUM", for: .normal)
        goPremium.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        goPremium.backgroundColor = CustomColor.black42
        goPremium.addTarget(self, action: #selector(goPremiumTouchUpInside), for: .touchUpInside)
        premiumAlerts.text = "PREMIUM ALERTS"
        premiumAlerts.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        premiumAlerts.textColor = .white
        textView.backgroundColor = .clear
        
        let text = """
Firetail has partnered with Vulture Intelligence to bring you real time social based alerts for crypto currency at $10/mo.

By becoming a Premium Member you will receive intelligent Crypto alerts via an artificial engine monitoring society and Crypto chatter in real time.

Know when to move your Crypto before the next guy.

Joining premium also gives you access to unlimted monthly Firetail alerts.
"""
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        textView.textColor = CustomColor.white115
        textView.font = UIFont(name: "HelveticaNeue", size: 15)
        textView.isEditable = false
        textView.isScrollEnabled = false
        backButton.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 48, height: 57)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTouchUpInside), for: .touchUpInside)
        
        view.addSubview(goPremium)
        setConstraints()
        
    }
    
    @objc private func backButtonTouchUpInside() {
        dismiss(animated: true)
    }
    
    @objc private func goPremiumTouchUpInside() {
        // Go premium IAP
    }
    
    private func setConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: goPremium.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        goPremium.translatesAutoresizingMaskIntoConstraints = false
        goPremium.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        goPremium.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        goPremium.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        goPremium.heightAnchor.constraint(equalTo: goPremium.widthAnchor, multiplier: 0.18).isActive = true
        
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        star.setContentHuggingPriority(.defaultHigh, for: .vertical)
        premiumAlerts.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
