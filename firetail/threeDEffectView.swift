//
//  3dEffectView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 4/3/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import QuartzCore

class threeDEffectView: UIView {
    
    var screenWidth: CGFloat {get{return UIScreen.main.bounds.width}}
    var screenHeight: CGFloat {get{return UIScreen.main.bounds.height}}
    let pathSquare = CGMutablePath()
    let pathPoly = CGMutablePath()
    let layer3d = CAShapeLayer()
    let customColor = CustomColor()
    var layerAnimation = CABasicAnimation(keyPath: "path")
    let animcolor = CABasicAnimation(keyPath: "fillColor")
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pathSquare.move(to: CGPoint(x: 0, y: 0))
        pathSquare.addLine(to: CGPoint(x: screenWidth, y: 0))
        pathSquare.addLine(to: CGPoint(x: screenWidth, y: screenWidth/2))
        pathSquare.addLine(to: CGPoint(x: 0, y: screenWidth/2))
        pathSquare.addLine(to: CGPoint(x: 0, y: 0))
        pathSquare.closeSubpath()
        
        pathPoly.move(to: CGPoint(x: 0, y: 0))
        pathPoly.addLine(to: CGPoint(x: screenWidth, y: 0))
        pathPoly.addLine(to: CGPoint(x: 1.55*screenWidth/3, y: screenWidth/2))
        pathPoly.addLine(to: CGPoint(x: 1.45*screenWidth/3, y: screenWidth/2))
        pathPoly.addLine(to: CGPoint(x: 0, y: 0))
        pathPoly.closeSubpath()
        
        layerAnimation.duration = 1.7
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layerAnimation.fillMode = kCAFillModeBoth
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.fromValue = pathSquare
        layerAnimation.toValue = pathPoly
        
        animcolor.fromValue         = customColor.black42.cgColor
        animcolor.toValue           = customColor.black14.cgColor
        animcolor.duration          = 2.0
        animcolor.isRemovedOnCompletion = false
        
        layer3d.path = pathSquare
        layer3d.fillColor = customColor.black42.cgColor
        self.layer.addSublayer(layer3d)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
