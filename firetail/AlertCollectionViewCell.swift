//
//  AlertCollectionViewCell.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/28/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit

final class AlertCollectionViewCell: UICollectionViewCell {
    
    private var ticker = UILabel()
    private var alertList = UILabel()
    private var price = UILabel()
    
    private var moveableView = UIView()
    private var xImageView = UIImageView(image: #imageLiteral(resourceName: "ex"))
    
    internal let xAlphaStart: CGFloat = 0.1
    internal let xAlphaEnd: CGFloat = 1.0
    
    var layoutContraints = [NSLayoutConstraint]()
    
    internal func set(tickerText: String, alertListText: String, priceText: String) {
        ticker.text = tickerText
        alertList.text = alertListText
        price.text = priceText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xImageView.alpha = xAlphaStart
        
        backgroundColor = CustomColor.white249
        moveableView.backgroundColor = CustomColor.background
        
        ticker.textColor = .white
        ticker.textAlignment = .left
        ticker.font = UIFont(name: "Roboto-Regular", size: 15*widthScalar)
        ticker.alpha = 0.5
        
        alertList.textColor = .white
        alertList.textAlignment = .left
        alertList.font = UIFont(name: "Roboto-Regular", size: 15*widthScalar)
        alertList.alpha = 0.5
        
        price.textColor = CustomColor.yellow
        price.textAlignment = .right
        price.font = UIFont(name: "Roboto-Medium", size: 13*widthScalar)
        price.alpha = 0.5
        addSubview(xImageView)
        addSubview(moveableView)
        
        for view in [ticker, alertList, price] as [UIView] {
            moveableView.addSubview(view)
        }
    
        setupLayoutConstraints()
        activateLayoutConstraints()
        
    }
    
    lazy var moveableXConstraint: NSLayoutConstraint = moveableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
    lazy var xImageViewRightConstraint: NSLayoutConstraint = xImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30*widthScalar)
    lazy var xImageViewRightConstraintInMotion: NSLayoutConstraint = xImageView.centerXAnchor.constraint(equalTo: moveableView.rightAnchor, constant: 30*widthScalar)
    
   private func setupLayoutConstraints() {
        
        xImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(xImageView.centerYAnchor.constraint(equalTo: centerYAnchor))
        layoutContraints.append(xImageViewRightConstraint)
        
        moveableView.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(moveableView.widthAnchor.constraint(equalTo: widthAnchor))
        layoutContraints.append(moveableView.heightAnchor.constraint(equalTo: heightAnchor))
        layoutContraints.append(moveableView.topAnchor.constraint(equalTo: topAnchor))
        layoutContraints.append(moveableXConstraint)
        
        ticker.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(ticker.leftAnchor.constraint(equalTo: leftAnchor, constant: 30*widthScalar))
        layoutContraints.append(ticker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 13*heightScalar))
        
        alertList.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(alertList.leftAnchor.constraint(equalTo: leftAnchor, constant: 130*widthScalar))
        layoutContraints.append(alertList.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 13*heightScalar))
        
        price.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(price.leftAnchor.constraint(equalTo: leftAnchor, constant: 310*widthScalar))
        layoutContraints.append(price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 13*heightScalar))
    }
    
    private func activateLayoutConstraints() {
        NSLayoutConstraint.activate(layoutContraints)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateLayoutConstraints()
    }
    
    private func animate() {
        UIView.animate(withDuration: 5) {
            self.moveableXConstraint.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
