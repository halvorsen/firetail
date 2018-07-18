//
//  BallView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/7/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

class BaseOfGraphView: UIView {
   
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
        self.backgroundColor = CustomColor.black42

    }
    
    
    
    
}
