//
//  AlertCollectionViewCell.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/28/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit

protocol AlertCellDelegate: class {
    func deleteCell(withAlert: String)
    func tappedCell(withAlertTicker: String)
}

final class AlertCollectionViewCell: UICollectionViewCell {
    
    private var ticker = UILabel()
    private var alertList = UILabel()
    private var price = UILabel()
    private var alertName = ""
    private let line = UILabel()
    private let lighteningBolt = UIImageView(image: #imageLiteral(resourceName: "lighteningBolt"))
    internal weak var alertCellDelegate: AlertCellDelegate?
    
    private var moveableView = UIView()
    private var xImageView = UIImageView(image: #imageLiteral(resourceName: "ex"))
    
    private let xAlphaStart: CGFloat = 0.1
    private let xAlphaEnd: CGFloat = 1.0
    internal var currentXAlpha: CGFloat = 0.1 {
        didSet {
            xImageView.alpha = currentXAlpha
        }
    }
   
  
    var layoutContraints = [NSLayoutConstraint]()
    
    private var isGreaterThan: Bool = false
    private var isTriggered: Bool = false
    
    @objc private func tapped() {
     
        if let ticker = ticker.text {
        alertCellDelegate?.tappedCell(withAlertTicker: ticker)
        }
    }
    
    internal func set(alertName: String, tickerText: String, alertListText: String, priceText: String, isTriggered: String, isGreaterThan: Bool, cellIndex: Int, delegate: AlertCellDelegate) {
        ticker.text = tickerText
        alertList.text = alertListText
        price.text = priceText
        self.alertName = alertName
        alertCellDelegate = delegate
        if isTriggered.lowercased() == "true" {
            self.isTriggered = true
        } else {
            self.isTriggered = false
        }
        
        self.isGreaterThan = isGreaterThan
        if isGreaterThan {
            price.textColor = CustomColor.yellow
        } else {
            price.textColor = CustomColor.red
        }
        if self.isTriggered {
            price.textColor = .white
            price.alpha = 0.5
            lighteningBolt.isHidden = false
        } else {
            price.alpha = 1.0
            lighteningBolt.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(deletePan(_:))))
        
        xImageView.alpha = xAlphaStart
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        backgroundColor = CustomColor.white249
        moveableView.backgroundColor = CustomColor.background
        isUserInteractionEnabled = true
        moveableView.isUserInteractionEnabled = false
        
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
    
        line.backgroundColor = CustomColor.alertLines
        lighteningBolt.isHidden = true
        
        [xImageView, moveableView].forEach { addSubview($0) }
        [ticker, alertList, price, line, lighteningBolt].forEach { moveableView.addSubview($0) }
    
        setupLayoutConstraints()
        activateLayoutConstraints()
        
    }
    
    lazy var moveableXConstraint: NSLayoutConstraint = moveableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
    
   private func setupLayoutConstraints() {

        lighteningBolt.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(lighteningBolt.centerXAnchor.constraint(equalTo: moveableView.leftAnchor, constant: 98*commonScalar))
        layoutContraints.append(lighteningBolt.bottomAnchor.constraint(equalTo: ticker.bottomAnchor))
    
        line.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(line.bottomAnchor.constraint(equalTo: bottomAnchor))
        layoutContraints.append(line.leftAnchor.constraint(equalTo: leftAnchor))
        layoutContraints.append(line.rightAnchor.constraint(equalTo: rightAnchor))
        layoutContraints.append(line.heightAnchor.constraint(equalToConstant: 1))
        
        xImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(xImageView.centerYAnchor.constraint(equalTo: centerYAnchor))
        let lowerConstraint = xImageView.centerXAnchor.constraint(equalTo: moveableView.rightAnchor, constant: 30*widthScalar)
        lowerConstraint.priority = UILayoutPriority.init(rawValue: 750)
        layoutContraints.append(lowerConstraint)
        let constraint = xImageView.centerXAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30*widthScalar)
        constraint.priority = UILayoutPriority.init(rawValue: 1000)
        layoutContraints.append(constraint)
    
        moveableView.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(moveableView.widthAnchor.constraint(equalTo: widthAnchor))
        layoutContraints.append(moveableView.heightAnchor.constraint(equalTo: heightAnchor))
        layoutContraints.append(moveableView.topAnchor.constraint(equalTo: topAnchor))
        layoutContraints.append(moveableXConstraint)
        
        ticker.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(ticker.leftAnchor.constraint(equalTo: moveableView.leftAnchor, constant: 30*widthScalar))
        layoutContraints.append(ticker.bottomAnchor.constraint(equalTo: moveableView.bottomAnchor, constant: -13*heightScalar))
        
        alertList.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(alertList.leftAnchor.constraint(equalTo: moveableView.leftAnchor, constant: 130*widthScalar))
        layoutContraints.append(alertList.bottomAnchor.constraint(equalTo: moveableView.bottomAnchor, constant: -13*heightScalar))
        
        price.translatesAutoresizingMaskIntoConstraints = false
        layoutContraints.append(price.leftAnchor.constraint(equalTo: moveableView.leftAnchor, constant: 310*widthScalar))
        layoutContraints.append(price.bottomAnchor.constraint(equalTo: moveableView.bottomAnchor, constant: -13*heightScalar))
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
    
    @objc private func deletePan(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: moveableView).x
        if translationX < 0 {
            moveableXConstraint.constant = translationX
        }
        xImageView.alpha = -translationX/60
        layoutIfNeeded()
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            if moveableXConstraint.constant < -60 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.moveableXConstraint.constant = -375*widthScalar
                    self.layoutIfNeeded()
                    self.alertCellDelegate?.deleteCell(withAlert: self.alertName)
                }) { _ in
              
                    
                    self.moveableXConstraint.constant = 0

                }
                
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.moveableXConstraint.constant = 0
                    self.layoutIfNeeded()
                }
            }
        }
    }

    
}
