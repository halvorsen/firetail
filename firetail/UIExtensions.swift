//
//  UIExtentions.swift
//
//
//  Created by Aaron Halvorsen on 5/2/17.
//
//

import UIKit

extension ViewSetup {
    
    
    func addNoInternetCover() {
        cover.frame = view.bounds
        cover.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        view.addSubview(cover)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 127*screenWidth/375, y:64*screenHeight/667, width: 122*screenWidth/375, height: 157*screenHeight/667)
        imageView.image = #imageLiteral(resourceName: "flames")
        cover.addSubview(imageView)
        let label = UILabel()
        label.frame = CGRect(x: 0, y:290*screenHeight/667, width: screenWidth, height: 157*screenHeight/667)
        label.text = "NO INTERNET"
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Bold", size: fontSizeMultiplier*15)
        cover.addSubview(label)
    }
    
    func removeNoInternetCover() {
        cover.removeFromSuperview()
    }
}
