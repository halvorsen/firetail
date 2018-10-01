//
//  PremiumInformationViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/21/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit
import SwiftyStoreKit

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
    
    var activityView = UIActivityIndicatorView()
    @objc func purchase(productId: String = "vulture2103532") {
        
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center.x = view.center.x
        activityView.center.y = view.center.y - 100
        activityView.startAnimating()
        activityView.alpha = 1.0
        view.addSubview(activityView)
        SwiftyStoreKit.purchaseProduct(productId) { [weak self] result in
            guard let weakself = self else {return}
       
            switch result {
                
            case .success( _):
                UserInfo.vultureSubscriber = true
                if let presenter = self?.presentingViewController as? DashboardViewController {
                presenter.goPremium.setTitle("PREMIUM MEMBER", for: .normal)
                }
                Firebase.persistSubscriber(true)
                weakself.activityView.removeFromSuperview()
                self?.dismiss(animated: false, completion: nil)
            case .error(let error):
                print("error: \(error)")
                print("Purchase Failed: \(error)")
                weakself.activityView.removeFromSuperview()
            }
        }
    }
    
    @objc private func goPremiumTouchUpInside() {
        // Create the alert controller
        if UserInfo.vultureSubscriber == false {
            let alertController = UIAlertController(title: "Premium Alerts", message: "Sign up now", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak self] UIAlertAction in
                guard let weakself = self else {return}
                weakself.purchase()
                
            }
            let okActionDismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak self] UIAlertAction in
                self?.dismiss(animated: false, completion: nil)
            }
            let okActionNoDismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                //do nothing
            }
            let restoreAction = UIAlertAction(title: "Restore Purchase", style: UIAlertAction.Style.default) { UIAlertAction in
                SwiftyStoreKit.restorePurchases(atomically: true) { results in
                    AppStore.shared.checkIfSubscribedToProduct() { (isVultureSubscriber, expirationDate) in
                        if let subscriber = isVultureSubscriber, let expiration = expirationDate {
                            if subscriber {
                                let alert = UIAlertController(title: "Premium Member", message: "Premium Membership Restored", preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(okActionDismiss)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateStyle = .medium
                                dateFormatter.timeStyle = .none
                                let alert = UIAlertController(title: "Premium Member", message: "Premium Membership Expired \(dateFormatter.string(from: expiration))", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(okActionNoDismiss)
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            let alert = UIAlertController(title: "Premium Member", message: "Not a subscriber", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(okActionNoDismiss)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            }
            
            alertController.addAction(okAction)
            alertController.addAction(restoreAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: false)
        } else {
            
            let alert = UIAlertController(title: "Premium Member", message: "You are a premium member", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
        
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
