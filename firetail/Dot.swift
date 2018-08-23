//
//  Dot.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/10/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

final class Dot: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        UIColor.white.setFill()
        path.fill()
        self.backgroundColor = .clear
    }
 

}
