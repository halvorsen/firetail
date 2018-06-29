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
    
    var layoutContraints = [NSLayoutConstraint]()
    
    internal func set(tickerText: String, alertListText: String, priceText: String) {
        ticker.text = tickerText
        alertList.text = alertListText
        price.text = priceText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        for view in [ticker, alertList, price] as [UIView] {
            addSubview(view)
        }
    
        setupLayoutConstraints()
        activateLayoutConstraints()
        
    }
    
    func setupLayoutConstraints() {
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
    
    func activateLayoutConstraints() {
        NSLayoutConstraint.activate(layoutContraints)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
