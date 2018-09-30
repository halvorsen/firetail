//
//  AlertSwitch.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/21/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//
import UIKit

final class AlertSwitch: UIControl {
    
    let stocks = UILabel()
    let crypto = UILabel()
    
    public var offTintColor = UIColor.black
    public var onTintColor = UIColor.black
    public var thumbTintColor = CustomColor.black63
    public var isStock: Bool {
        return UserInfo.isStockMode
    }
    public var animationDuration: Double = 0.5
    
    public var thumbSize = CGSize.zero
    public var padding: CGFloat = 2
    
    private lazy var thumbViewWidth = ToggleConstant.width - padding * 2.0
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var isStockConstant: CGFloat = 0
    fileprivate var isCryptoConstant: CGFloat = 0
    fileprivate var isAnimating = false
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupUI() {
        
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
        backgroundColor = .black
        onTintColor = .black
        stocks.text = "STOCKS"
        crypto.text = "CRYPTO"
        stocks.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        crypto.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        addSubview(stocks)
        addSubview(crypto)
        stocks.translatesAutoresizingMaskIntoConstraints = false
        crypto.translatesAutoresizingMaskIntoConstraints = false
        stocks.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        crypto.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stocks.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        crypto.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        isStockConstant = padding
        isCryptoConstant = ToggleConstant.width*0.5 + padding
        leftAnchorConstraint.constant = self.isStock ? isStockConstant : isCryptoConstant
        self.layer.cornerRadius = ToggleConstant.height * 0.5
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -2*padding).isActive = true
        thumbView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0, constant: -2*padding).isActive = true
        thumbView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftAnchorConstraint = thumbView.leftAnchor.constraint(equalTo: leftAnchor, constant: isStockConstant)
        leftAnchorConstraint.isActive = true
        thumbView.layer.cornerRadius = (ToggleConstant.height - 2*padding) * 0.5
            stocks.textColor = isStock ? CustomColor.white128 : CustomColor.black63
        crypto.textColor = !isStock ? CustomColor.white128 : CustomColor.black63
        layoutIfNeeded()
        
    }
    
    override init(frame: CGRect = CGRect.zero) {
       super.init(frame: frame)
        setupUI()
   
    }
    private var leftAnchorConstraint = NSLayoutConstraint()
    private func animate() {
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
            print("isStock: \(self.isStock)")
            self.leftAnchorConstraint.constant = self.isStock ? self.isCryptoConstant : self.isStockConstant
            self.stocks.textColor = !self.isStock ? CustomColor.white128 : CustomColor.black63
            self.crypto.textColor = self.isStock ? CustomColor.white128 : CustomColor.black63
            self.layoutIfNeeded()
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isAnimating {
            self.leftAnchorConstraint.constant = self.isStock ? self.isStockConstant : self.isCryptoConstant
            self.stocks.textColor = self.isStock ? CustomColor.white128 : CustomColor.black63
            self.crypto.textColor = !self.isStock ? CustomColor.white128 : CustomColor.black63
           
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    print("beginTracking")
        super.beginTracking(touch, with: event)
        self.animate()
        return true
        
    }
}

enum ToggleConstant {
    static let width: CGFloat = 186
    static let height: CGFloat = 36
}
