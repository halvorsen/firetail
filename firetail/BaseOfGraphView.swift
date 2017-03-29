//
//  BallView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/7/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

class BaseOfGraphView: UIView {
    let customColor = CustomColor()
    let bez = UIBezierPath()
    var path = UIBezierPath()
    var path2 = UIBezierPath()
    var path3 = UIBezierPath()
    var path4 = UIBezierPath()
    var path5 = UIBezierPath()
    var baseLayer = CAShapeLayer()
    
    
    let layerAnimation = CABasicAnimation(keyPath: "path")
    let layerAnimation2 = CABasicAnimation(keyPath: "path")
    let layerAnimation3 = CABasicAnimation(keyPath: "path")
    let layerAnimation4 = CABasicAnimation(keyPath: "path")
    let layerAnimation5 = CABasicAnimation(keyPath: "path")
    let layerAnimation6 = CABasicAnimation(keyPath: "path")
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = customColor.black42
//        bez.move(to: CGPoint(x: 0, y: 0))
//        bez.addLine(to: CGPoint(x:0, y: 70*superview!.bounds.height/636))
//        bez.addLine(to: CGPoint(x: superview!.bounds.width, y: 70*superview!.bounds.height/636))
//        bez.addLine(to: CGPoint(x: superview!.bounds.width, y: 0))
//        bez.addLine(to: CGPoint(x:0, y:0))
//        bez.close()
        
//        path2 = UIBezierPath(ovalIn: CGRect(x: self.bounds.width/2 - self.bounds.width/20, y: -self.bounds.width/2, width: self.bounds.width/10, height: self.bounds.width/10))
//        
//        path3 = UIBezierPath(ovalIn: CGRect(x: self.bounds.width/2 - self.bounds.width/20, y: 0, width: self.bounds.width/10, height: self.bounds.width/10))
//        
//        path = UIBezierPath(ovalIn: CGRect(x: self.bounds.width/2 - self.bounds.width/20, y: 8*self.bounds.width/320, width: self.bounds.width/10, height: 24*self.bounds.width/320))
//        
//        path4 = UIBezierPath(ovalIn: CGRect(x: self.bounds.width/4, y: 28*self.bounds.width/320, width: self.bounds.width/2, height: 4*self.bounds.width/320))
        
//        path5 = UIBezierPath(rect: CGRect(x: 0, y: 30*self.bounds.width/320, width: self.bounds.width, height: 1*self.bounds.width/320))
        
//        let pathcg2 = path2.cgPath
//        
//        let pathcg3 = path3.cgPath
//        
//        let pathcg = path.cgPath
//        
//        let pathcg4 = path4.cgPath
        
//        let pathcg5 = path5.cgPath
//        baseLayer.fillColor = customColor.yellow.cgColor
////        baseLayer.path = pathcg2
//        
//        
//        layerAnimation.duration = 0.42
//        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//        layerAnimation.fillMode = kCAFillModeBoth
//        layerAnimation.isRemovedOnCompletion = false
//        layerAnimation.fromValue = pathcg2
//        layerAnimation.toValue = pathcg3
//        
//        layerAnimation2.duration = 0.12
//        layerAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        layerAnimation2.fillMode = kCAFillModeBoth
//        layerAnimation2.isRemovedOnCompletion = false
//        layerAnimation2.fromValue = pathcg3
//        layerAnimation2.toValue = pathcg
//        
//        layerAnimation3.duration = 0.12
//        layerAnimation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        layerAnimation3.fillMode = kCAFillModeBoth
//        layerAnimation3.isRemovedOnCompletion = false
//        layerAnimation3.fromValue = pathcg
//        layerAnimation3.toValue = pathcg3
//        
//        layerAnimation4.duration = 0.42
//        layerAnimation4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        layerAnimation4.fillMode = kCAFillModeBoth
//        layerAnimation4.isRemovedOnCompletion = false
//        layerAnimation4.fromValue = pathcg3
//        layerAnimation4.toValue = pathcg2
//        
//        layerAnimation5.duration = 0.05
//        layerAnimation5.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        layerAnimation5.fillMode = kCAFillModeBoth
//        layerAnimation5.isRemovedOnCompletion = false
//        layerAnimation5.fromValue = pathcg
//        layerAnimation5.toValue = pathcg4
//        
//        layerAnimation6.duration = 0.05
//        layerAnimation6.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        layerAnimation6.fillMode = kCAFillModeBoth
//        layerAnimation6.isRemovedOnCompletion = false
//        layerAnimation6.fromValue = pathcg4
//        layerAnimation6.toValue = pathcg5
//        
//        self.layer.addSublayer(baseLayer)
        
    }
    
    
    
    
}
