//
//  addViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/13/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard
import QuartzCore

class AddViewController: ViewSetup, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var myTextField = UITextField()
    var textField2 = UITextField()
    var phoneTextField = UITextField()
    let customColor = CustomColor()
    //let alertLabel2 = UILabel()
    var alertChangeTimer = Timer()
    var alertPrice: Double = 0.00 {didSet{textField2.text = "$" + String(format: "%.2f", alertPrice); getPickerData()
        let c = (textField2.text?.characters.map { String($0) })!
        let s = textField2.text!
        if c[c.count-2] == "." {
            textField2.text = s + "0"
        }

        }}
    var touchDown = UILongPressGestureRecognizer()
    var touchUp = UILongPressGestureRecognizer()
    var tapDown = UITapGestureRecognizer()
    var tapUp = UITapGestureRecognizer()
    let stockTitle = UIButton()
    var container = UIScrollView()
    var graph = DailyGraphForAlertView()
    var newAlertTicker = "TSLA"
    var newAlertPrice = Double()
    var newAlertBoolTuple = (false, false, false, false)
    let backArrow = UIButton()
    var amountOfBlocksOld = Int()
    let loadsave = LoadSaveCoreData()
    let stockSymbol = UILabel()
    let toolBar = UIToolbar()
    var pickerData = ["$10","$11","$12","$13","$14"]
    var pickerData2 = [".00",".05",".10",".15",".20",".25",".30",".35",".40",".45",".50",".55",".60",".65",".70",".75",".80",".85",".90",".95"]
    var myPicker = UIPickerView()
    var myLabel = UILabel()
    let mask = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 60, y: 1082, width: 240, height: 80, lines: 1)
        view.addSubview(stockSymbol)
        amountOfBlocksOld = loadsave.amount()
        
        view.backgroundColor = customColor.black33
        let bottomBar = UIView()
        bottomBar.frame = CGRect(x: 0, y: 597*screenHeight/667, width: screenWidth, height: 70*screenHeight/667)
        bottomBar.backgroundColor = customColor.black24
        view.addSubview(bottomBar)
        
        let alertLabel = UILabel()
        addLabel(name: alertLabel, text: "Price Alert", textColor: customColor.white216, textAlignment: .left, fontName: "Roboto-Light", fontSize: 17, x: 64, y: 1242, width: 240, height: 40, lines: 0)
        view.addSubview(alertLabel)
        
        //addLabel(name: alertLabel2, text: "$", textColor: customColor.white216, textAlignment: .left, fontName: "Roboto-Bold", fontSize: 17, x: 256, y: 1252, width: 240, height: 40, lines: 0)
        //view.addSubview(alertLabel2)
        
        textField2 = UITextField(frame: CGRect(x: 256*screenWidth/750,y: 1242*screenHeight/1334,width: 240*screenWidth/750 ,height: 40*screenHeight/1334))
        //textField.placeholder = newAlertTicker
        textField2.textAlignment = .left
        textField2.setValue(customColor.white216, forKeyPath: "_placeholderLabel.textColor")
        textField2.font = UIFont(name: "Roboto-Bold", size: 17*fontSizeMultiplier)
        textField2.autocorrectionType = UITextAutocorrectionType.no
        textField2.keyboardType = UIKeyboardType.default
        textField2.returnKeyType = UIReturnKeyType.done
        textField2.clearsOnBeginEditing = true
        textField2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField2.delegate = self
        textField2.backgroundColor = .clear
        textField2.textColor = customColor.white216
        textField2.tag = 0
        view.addSubview(textField2)
        
        myTextField = UITextField(frame: CGRect(x: 60*screenWidth/750,y: 1014*screenHeight/1334,width: 240*screenWidth/750 ,height: 80*screenHeight/1334))
        myTextField.placeholder = newAlertTicker
        myTextField.textAlignment = .left
        myTextField.clearsOnBeginEditing = true
        myTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        myTextField.font = UIFont(name: "Roboto-Medium", size: 20*fontSizeMultiplier)
        myTextField.autocorrectionType = UITextAutocorrectionType.no
        myTextField.keyboardType = UIKeyboardType.default
        myTextField.returnKeyType = UIReturnKeyType.done
        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        myTextField.delegate = self
        myTextField.backgroundColor = .clear
        myTextField.textColor = .white
        myTextField.tag = 1
        view.addSubview(myTextField)
        
        phoneTextField = UITextField(frame: CGRect(x: 375*screenWidth/750,y: 800*screenHeight/1334,width: 375*screenWidth/750 ,height: 80*screenHeight/1334))
        phoneTextField.placeholder = "(000) 000-0000"
        phoneTextField.textAlignment = .left
        phoneTextField.clearsOnBeginEditing = true
        phoneTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        phoneTextField.font = UIFont(name: "Roboto-Medium", size: 20*fontSizeMultiplier)
        phoneTextField.autocorrectionType = UITextAutocorrectionType.no
        phoneTextField.keyboardType = UIKeyboardType.default
        phoneTextField.returnKeyType = UIReturnKeyType.done
        phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        phoneTextField.delegate = self
        phoneTextField.backgroundColor = .clear
        phoneTextField.textColor = .white
        phoneTextField.tag = 2
        view.addSubview(phoneTextField)
        phoneTextField.alpha = 0.0

        var add = UIButton()
        addButton(name: add, x: 610, y: 0, width: 140, height: 140, title: "  +", font: "Roboto-Light", fontSize: 45, titleColor: customColor.black33, bgColor: .white, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddViewController.add(_:)), addSubview: false)
        add.titleLabel?.textAlignment = .center //this isnt working for some reason
        bottomBar.addSubview(add)
        
        //    addButton(name: stockTitle, x: 60, y: 1014, width: 240, height: 80, title: newAlertTicker, font: "Roboto-Medium", fontSize: 20, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddViewController.changeTicker(_:)), addSubview: true)
        
        view.addSubview(stockTitle)
        
        for i in 0...3 {
            let l = UILabel()
            let name = ["Email","SMS","Flash","Urgent"]
            addLabel(name: l, text: name[i], textColor: customColor.white115, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 16, x: 212, y: 608 + CGFloat(i)*96, width: 150, height: 40, lines: 0)
            view.addSubview(l)
        }
        
        let mySwitchEmail = UISwitch()
        mySwitchEmail.frame = CGRect(x: 27*screenWidth/375, y: 299*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchEmail.setOn(false, animated: false)
        mySwitchEmail.tintColor = customColor.white229
        mySwitchEmail.layer.cornerRadius = 16
        mySwitchEmail.backgroundColor = .white
        mySwitchEmail.onTintColor = customColor.yellow
        //    mySwitchEmail.thumbTintColor = customColor.white229
        mySwitchEmail.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchEmail.tag = 0
        view.addSubview(mySwitchEmail)
        
        let mySwitchSMS = UISwitch()
        mySwitchSMS.frame = CGRect(x: 27*screenWidth/375, y: 347*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchSMS.setOn(false, animated: false)
        mySwitchSMS.tintColor = customColor.white229
        mySwitchSMS.layer.cornerRadius = 16
        mySwitchSMS.backgroundColor = .white
        mySwitchSMS.onTintColor = customColor.yellow
        //     mySwitchSMS.thumbTintColor = customColor.white229
        mySwitchSMS.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchSMS.tag = 1
        view.addSubview(mySwitchSMS)
        
        let mySwitchFlash = UISwitch()
        mySwitchFlash.frame = CGRect(x: 27*screenWidth/375, y: 395*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchFlash.setOn(false, animated: false)
        mySwitchFlash.tintColor = customColor.white229
        mySwitchFlash.layer.cornerRadius = 16
        mySwitchFlash.backgroundColor = .white
        mySwitchFlash.onTintColor = customColor.yellow
        // mySwitchFlash.thumbTintColor = customColor.white229
        mySwitchFlash.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchFlash.tag = 2
        view.addSubview(mySwitchFlash)
        
        let mySwitchUrgent = UISwitch()
        mySwitchUrgent.frame = CGRect(x: 27*screenWidth/375, y: 443*screenHeight/667, width: 51*screenWidth/375, height: 31*screenHeight/667)
        mySwitchUrgent.setOn(false, animated: false)
        // mySwitchUrgent.tintColor = .blue //customColor.white229
        
        mySwitchUrgent.layer.cornerRadius = 16
        mySwitchUrgent.layer.borderWidth = 1.5
        mySwitchUrgent.layer.borderColor = customColor.white229.cgColor
        mySwitchUrgent.backgroundColor = .white
        mySwitchUrgent.onTintColor = customColor.yellow
        //  mySwitchUrgent.thumbTintColor = customColor.white229
        mySwitchUrgent.addTarget(self, action: #selector(AddViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        mySwitchUrgent.tag = 3
        view.addSubview(mySwitchUrgent)
        
        
        
        container = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260*screenHeight/667))
        container.contentSize = CGSize(width: 3.8*screenWidth, height: container.bounds.height)
        container.backgroundColor = customColor.black33
        container.contentOffset =  CGPoint(x: 2.7*screenWidth, y: 0)
        container.clipsToBounds = false
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        view.addSubview(container)
        
        //        callCorrectGraph2(stockName: self.stockName) {(_ stockData: ([String],[StockData2?])) -> Void in
        
        prepareGraph() {(_ dateArray: [Date]?,_ closings: [Double]?) -> Void in
            if closings != nil && dateArray != nil {
                self.graph = DailyGraphForAlertView(graphData: closings!, dateArray: dateArray!)
                self.container.addSubview(self.graph)
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: 0, y: -100)
                t = t.scaledBy(x: 1.0, y: 0.01)
                self.graph.transform = t
                let effectView = threeDEffectView(frame: CGRect(x: 0, y: -8*self.screenHeight/667, width: self.screenWidth, height: self.screenWidth/2))
                effectView.clipsToBounds = true
                    self.view.addSubview(effectView)
                    effectView.layer3d.add(effectView.layerAnimation, forKey: nil)
                effectView.layer3d.add(effectView.animcolor, forKey: "fillColor")
                effectView.alpha = 0.0
                UIView.animate(withDuration: 0.2) {
                    effectView.alpha = 1.0
                }
                UIView.animate(withDuration: 2.0) {
               
                    effectView.frame = CGRect(x: 0, y: 240*self.screenHeight/667, width: self.screenWidth, height: 0)
                    self.graph.transform = CGAffineTransform.identity
                    self.graph.frame.origin.y = 50*self.screenHeight/667
                }
                self.delay(bySeconds: 1.2) {
                    
                    for i in 0..<self.graph.labels.count {
                        self.delay(bySeconds: 0.3) {
                            UIView.animate(withDuration: 0.3*Double(i)) {
                                self.graph.grids[self.graph.labels.count - i - 1].alpha = 1.0
                                self.graph.labels[self.graph.labels.count - i - 1].alpha = 1.0
                                self.graph.dayLabels[self.graph.labels.count - i - 1].alpha = 1.0
                            }
                        }
                    }
                    
                }
                
                
                self.alertPrice = closings!.last!
            }
            
        }

        
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddViewController.back(_:)), addSubview: true)
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)


        myPicker.dataSource = self
        myPicker.delegate = self
        myPicker.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 177*screenHeight/667)
        myPicker.backgroundColor = .white
        myPicker.showsSelectionIndicator = true
        
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 21/255, green: 127/255, blue: 249/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField2.inputView = myPicker
        textField2.inputAccessoryView = toolBar
        
        
    }

    func donePicker() {
        
        view.frame.origin.y = 0
        myPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerData.count
        default:
            return pickerData2.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return pickerData[row]
        default:
            return pickerData2[row]
        }
    }
    var dd = "$1"
    var cc = ".00"
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch component {
        case 0:
            dd = pickerData[row]
        default:
            cc = pickerData2[row]
        }
        textField2.text = dd + cc
    }
    var apDollar = Int()
    var apDollarString = String()
    var apCentString = String()
    override func viewWillAppear(_ animated: Bool) {
        getOneYearData(stockName: newAlertTicker) {
            
            Set.oneYearDictionary[$1] = $0
            
        }
       // getPickerData()
    }
    
    private func getPickerData() {
        pickerData.removeAll()
        let ap = alertPrice
        apDollar = Int(alertPrice)
        print("apDollar \(apDollar)")
        apDollarString = String(apDollar)
        var apCent: String {
            var a = textField2.text!
            var last3 = a.substring(from:a.index(a.endIndex, offsetBy: -3))
            let last2 = a.substring(from:a.index(a.endIndex, offsetBy: -2))
            let last1 = a.substring(from:a.index(a.endIndex, offsetBy: -1))
            switch last1 {
            case "1","2","3","4":last3.remove(at: last3.index(before: last3.endIndex)); last3 += "0"
            case "6","7","8","9":last3.remove(at: last3.index(before: last3.endIndex)); last3 += "5"
            default: break
            }
            return last3
        }
        apCentString = apCent
        for i in 0...100 {
            if i - 50 + apDollar > 0 {
                pickerData.append(String(i - 50 + apDollar))
            }
        }
        
    }
    
    
    @objc private func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromAddToMain", sender: self)
    }
    
    @objc private func switchChanged(_ sender: UISwitch!) {
        if sender.isOn {
            switch sender.tag {
            case 0:
                newAlertBoolTuple.0 = true
            case 1:
                if Set.phoneNumber == "none" {
                    phoneTextField.alpha = 1.0
                    phoneTextField.becomeFirstResponder()
                } else {
                newAlertBoolTuple.1 = true
                }
            case 2:
                newAlertBoolTuple.2 = true
            case 3:
                newAlertBoolTuple.3 = true
            default:
                break
            }
        } else {
            switch sender.tag {
            case 0:
                newAlertBoolTuple.0 = false
            case 1:
                newAlertBoolTuple.1 = false
            case 2:
                newAlertBoolTuple.2 = false
            case 3:
                newAlertBoolTuple.3 = false
            default:
                break
            }
        }
        print("Switch value is \(sender.isOn)")
    }
    
    let myloadsave = LoadSaveCoreData()
    @objc private func add(_ button: UIButton) {
        Set.ti.append(newAlertTicker)
        loadsave.saveBlockAmount(amount: amountOfBlocksOld + 1)
        loadsave.saveBlock(stockTicker: newAlertTicker, currentPrice: alertPrice, sms: newAlertBoolTuple.0, email: newAlertBoolTuple.1, flash: newAlertBoolTuple.2, urgent: newAlertBoolTuple.3)
        myloadsave.saveAlertToFirebase(username: "aaronhalvorsengmailcom", ticker: newAlertTicker, price: alertPrice, isGreaterThan: true, deleted: false, email: newAlertBoolTuple.1, sms: newAlertBoolTuple.0, flash: newAlertBoolTuple.2, urgent: newAlertBoolTuple.3, triggered: false, push: false)
        self.performSegue(withIdentifier: "fromAddToMain", sender: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTextField {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        } else {
            return true
        }
    }


    func textFieldDidBeginEditing(_ textField : UITextField) {
        if textField.tag == 2 {
        } else {
        if textField.tag == 1 {
            textField.text = ""
        }
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.spellCheckingType = .no
    }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 2 {
        } else {
        if textField.tag == 0 {
            var row0 = Int()
            var row1 = Int()
            for i in 0..<pickerData.count {
                if pickerData[i] == apDollarString {
                   row0 = i
                }
            }
            for i in 0..<pickerData2.count {
                print("apCentString \(apCentString)")
                if pickerData2[i] == apCentString {
                    row1 = i
                }
            }
            myPicker.selectRow(row0, inComponent: 0, animated: false)
            pickerView(myPicker, didSelectRow: row0, inComponent: 0)
            myPicker.selectRow(row1, inComponent: 1, animated: false)
            pickerView(myPicker, didSelectRow: row1, inComponent: 1)
            UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 446-667

            }
        } else {
        self.view.frame.origin.y = -135*screenHeight/667
        }
        }
        return true
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("EEEEW")
        print(textField.tag)
        
        if textField.tag == 2 {
            phoneTextField.alpha = 0.0
            if phoneTextField.text != nil {
            Set.phoneNumber = phoneTextField.text!
            }
            
            //check if phone number is valid then turn on switch else send invalid alert
        } else if textField.tag == 0 {
            UIView.animate(withDuration: 0.6) {
                self.view.frame.origin.y = 0
            }
            textField2.tintColor = .clear
        } else {
            print("WAAAAA")
            if myTextField.text != nil && myTextField.delegate != nil {
                
                getOneYearData(stockName: myTextField.text!.uppercased()) {
                    
                    Set.oneYearDictionary[$1] = $0
                    
                }
                
                newAlertTicker = myTextField.text!.uppercased()
                myTextField.text = myTextField.text!.uppercased()
                myTextField.tintColor = .clear
                
                graph.removeFromSuperview()
                graph = DailyGraphForAlertView()
                prepareGraph() {(_ dateArray: [Date]?,_ closings: [Double]?) -> Void in
                    if closings != nil && dateArray != nil {
                        self.graph = DailyGraphForAlertView(graphData: closings!, dateArray: dateArray!)
                        self.container.addSubview(self.graph)
                        var t = CGAffineTransform.identity
                        t = t.translatedBy(x: 0, y: -100)
                        t = t.scaledBy(x: 1.0, y: 0.01)
                        self.graph.transform = t
                        let effectView = threeDEffectView(frame: CGRect(x: 0, y: -8*self.screenHeight/667, width: self.screenWidth, height: self.screenWidth/2))
                        effectView.clipsToBounds = true
                        self.view.addSubview(effectView)
                        effectView.layer3d.add(effectView.layerAnimation, forKey: nil)
                        effectView.layer3d.add(effectView.animcolor, forKey: "fillColor")
                        effectView.alpha = 0.0
                        UIView.animate(withDuration: 0.2) {
                            effectView.alpha = 1.0
                        }
                        UIView.animate(withDuration: 2.0) {
                            
                            effectView.frame = CGRect(x: 0, y: 240*self.screenHeight/667, width: self.screenWidth, height: 0)
                            self.graph.transform = CGAffineTransform.identity
                            self.graph.frame.origin.y = 50*self.screenHeight/667
                        }

                        self.delay(bySeconds: 1.2) {
                            
                            for i in 0..<self.graph.labels.count {
                                self.delay(bySeconds: 0.3) {
                                    UIView.animate(withDuration: 0.3*Double(i)) {
                                        self.graph.grids[self.graph.labels.count - i - 1].alpha = 1.0
                                        self.graph.labels[self.graph.labels.count - i - 1].alpha = 1.0
                                        self.graph.dayLabels[self.graph.labels.count - i - 1].alpha = 1.0
                                    }
                                }
                            }
                            
                        }
                        
                        
                        self.alertPrice = closings!.last!
                    }
                    
                }
                self.view.frame.origin.y = 0
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainView: DashboardViewController = segue.destination as! DashboardViewController
        mainView.previousViewContoller = "Add"
        mainView.amountOfBlocks = amountOfBlocksOld + 1
        Set.alertCount += 1
        print("SETCOUNT")
        print(Set.ti.count)
    }
    
    private func prepareGraph(result: @escaping (_ dateArray: [Date]?,_ closings: [Double]?) -> Void) {
        BigBoard.stockWithSymbol(symbol: newAlertTicker, success: { (stock) in
            
            var stockData = [Double]()
            var dates = [Date]()
            
            stock.mapOneMonthChartDataModule({
                
                
                for point in (stock.oneMonthChartModule?.dataPoints)! {
                    
                    dates.append(point.date)
                    stockData.append(point.close)
                }
                
                result(dates, stockData)
                
            }, failure: { (error) in
                if self.newAlertTicker != "#@$%" {
                    var des = error.description
                    for i in 0...14 {
                        des.remove(at: des.startIndex)
                    }
                self.userWarning(title: "", message: des)
                }
                print(error)
                result(nil, nil)
            })
            
        }) { (error) in
            if self.newAlertTicker != "#@$%" {
                var des = error.description
                for i in 0...14 {
                    des.remove(at: des.startIndex)
                }
                self.userWarning(title: "", message: des)
            }
            print(error)
            result(nil, nil)
        }
    }
}
