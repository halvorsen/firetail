//
//  GridLine.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/16/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

final class GridLine: UIView {
   
    override init(frame: CGRect = CGRect(x: 0, y:0, width: 0.5, height: 260*UIScreen.main.bounds.height/667)) {
        super.init(frame: frame)
        self.backgroundColor = CustomColor.whiteAlpha
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
