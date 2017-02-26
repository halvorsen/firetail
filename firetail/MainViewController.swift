//
//  MainViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/26/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

class MainViewController: ViewSetup, UITextFieldDelegate {
    
    var myTextField = UITextField()
    var stringToPass = "Patriots"
    let customColor = CustomColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor.background
        myTextField = UITextField(frame: CGRect(x: 0,y: 0,width: screenWidth ,height: 100*screenHeight/1334))
        myTextField.placeholder = "Enter Stock Ticker"
        myTextField.setValue(customColor.yellow, forKeyPath: "_placeholderLabel.textColor")
        myTextField.font = UIFont.systemFont(ofSize: 15)
        myTextField.borderStyle = UITextBorderStyle.roundedRect
        myTextField.autocorrectionType = UITextAutocorrectionType.no
        myTextField.keyboardType = UIKeyboardType.default
        myTextField.returnKeyType = UIReturnKeyType.done
        myTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        myTextField.delegate = self
        myTextField.backgroundColor = customColor.background
        myTextField.textColor = customColor.yellow
        self.view.addSubview(myTextField)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        if myTextField.text != nil && myTextField.delegate != nil {
            
            stringToPass = myTextField.text!
            goToGraph()
        }
        return false
    }


//    func enter(_ sender: UIButton) {
//        
//        if sampleTextField.text != nil && sampleTextField.delegate != nil {
//            
//            stockName = sampleTextField.text!
//            stockLabel.text = stockName
//            
//        }
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let graphView: GraphViewController = segue.destination as! GraphViewController
        
        graphView.passedString = stringToPass
        
    }
    
    @objc private func goToGraph() {
        self.performSegue(withIdentifier: "fromMainToGraph", sender: self)
    }

}
