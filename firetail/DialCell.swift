//
//  DialCell.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/8/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit


final class DialCell: UICollectionViewCell {
    
    private var price = UILabel()
    private var backgroundImage = UIImageView(image: #imageLiteral(resourceName: "dialCellImage"))
  
    var layoutContraints = [NSLayoutConstraint]()
    
    internal func set(price: Double) {
//        var priceString: String = ""
        if price < 0.00 {
            self.price.text = "0"
        } else if price < 1.00 {
            self.price.text = String(format: "%.6f", price)
        } else {
            self.price.text = String(format: "%.0f", price)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        price.textColor = .white
        price.textAlignment = .right
        price.font = UIFont(name: "Roboto-Medium", size: 14*widthScalar)
        addSubview(backgroundImage)
       addSubview(price)
        
        setupLayoutConstraints()
        activateLayoutConstraints()
        
    }
    
    private func setupLayoutConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(backgroundImage.leftAnchor.constraint(equalTo: leftAnchor))
        layoutContraints.append(backgroundImage.rightAnchor.constraint(equalTo: rightAnchor))
        layoutContraints.append(backgroundImage.topAnchor.constraint(equalTo: topAnchor))
        layoutContraints.append(backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor))
        
        price.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(price.centerXAnchor.constraint(equalTo: centerXAnchor))
        layoutContraints.append(price.centerYAnchor.constraint(equalTo: centerYAnchor))
       
    }
    
    private func activateLayoutConstraints() {
        NSLayoutConstraint.activate(layoutContraints)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
