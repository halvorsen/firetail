//
//  AddStockPriceViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/5/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import ReachabilitySwift

enum DialUnit {
    case dollar, etcVsEth, euro
}

class AddStockPriceViewController: ViewSetup, UIScrollViewDelegate {
    var newAlertTicker = String()
    var newAlertTickerLabel = UILabel()
    var newAlertPrice = Double()
    let backArrow = UIButton()
    var graph = DailyGraphForAlertView()
    var container = UIScrollView()
    var dial = UIScrollView()
    var displayValues = [Double]()
    var priceLabel = UILabel()
    var sett = UIButton()
    var alertPrice: Double = 0.00 {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let weakself = self else {return}
                weakself.priceLabel.text = "$" + String(format: "%.2f", weakself.alertPrice)
                if let c = (weakself.priceLabel.text?.map { String($0) }),
                    let s = weakself.priceLabel.text {
                    if c[c.count-2] == "." {
                        weakself.priceLabel.text = s + "0"
                    }
                }
                if weakself.alertPrice > 999.99 {
                    if let priceText = weakself.priceLabel.text?.dropFirst() {
                        weakself.priceLabel.text = String(priceText)
                    }
                }
            }
        }
    }
    let stockSymbol = UILabel()
    var activityView = UIActivityIndicatorView()
    let unit: DialUnit = .dollar
    var lastPrice = Double()
    let setPriceAlert = UILabel()
    let arrow = UIImageView()
    var priceString = String()
    var collectionView: DialCollectionView?
    let cellSize: CGSize = CGSize(width: 75*commonScalar, height: 103*commonScalar)
    
    private func loadItAll() {
        
        let blockInBackground = UIView()
        blockInBackground.frame = CGRect(x: 0, y: 424*screenHeight/667, width: screenWidth, height: 70*screenHeight/667)
        blockInBackground.backgroundColor = CustomColor.black24
        
        
        arrow.frame = CGRect(x: 212*screenWidth/375, y: 456*screenHeight/667, width: 10*screenWidth/375, height: 11*screenWidth/375)
        
        
        addLabel(name: setPriceAlert, text: "Set Price Alert", textColor: CustomColor.white115, textAlignment: .left, fontName: "Roboto-Light", fontSize: 17, x: 56, y: 885, width: 300, height: 80, lines: 1)
        
        addLabel(name: newAlertTickerLabel, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "DroidSerif", fontSize: 20, x: 60, y: 606, width: 200, height: 56, lines: 1)
        
        
        addLabel(name: stockSymbol, text: "stock symbol", textColor: CustomColor.white115, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 56, y: 657, width: 240, height: 80, lines: 1)
        
        
        container = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260*screenHeight/667))
        container.contentSize = CGSize(width: 3.8*screenWidth, height: container.bounds.height)
        container.backgroundColor = CustomColor.black33
        container.contentOffset =  CGPoint(x: 2.7*screenWidth, y: 0)
        container.clipsToBounds = false
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        
        priceLabel.frame = CGRect(x: 0, y: 450*screenHeight/667, width: 205*screenWidth/375, height: 25*screenHeight/667)
        priceLabel.font = UIFont(name: "Roboto-Bold", size: 17*fontSizeMultiplier)
        priceLabel.textAlignment = .right
        priceLabel.textColor = .white
        
        dial.backgroundColor = CustomColor.black42
        dial.frame = CGRect(x: 0, y: 494*screenHeight/667, width: screenWidth, height: 103*screenWidth/375)
        dial.contentSize = CGSize(width: 400.182*screenWidth, height: dial.bounds.height)
        
        dial.contentOffset.x = screenWidth*4.285
        dial.showsHorizontalScrollIndicator = false
        dial.showsVerticalScrollIndicator = false
        dial.delegate = self
        let bottomOfDial = dial.frame.maxY*1334/screenHeight //or 1194
        view.addSubview(blockInBackground)
        view.addSubview(arrow)
        view.addSubview(setPriceAlert)
        view.addSubview(newAlertTickerLabel)
        view.addSubview(stockSymbol)
        view.addSubview(container)
        view.addSubview(priceLabel)
        dial.contentOffset.x = offset
        view.addSubview(dial)
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 167*screenWidth/375, y: 489*screenHeight/667))
        myBezier.addLine(to: CGPoint(x: 207*screenWidth/375, y: 489*screenHeight/667))
        myBezier.addLine(to: CGPoint(x: 187*screenWidth/375, y: 509*screenHeight/667))
        myBezier.close()
        let myLayer = CAShapeLayer()
        myLayer.path = myBezier.cgPath
        myLayer.fillColor = CustomColor.black24.cgColor
        
        addButton(name: sett, x: 0, y: bottomOfDial, width: 750, height: 1334 - bottomOfDial, title: "SET", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.setFunc(_:)), addSubview: true)
        sett.contentHorizontalAlignment = .center
        view.layer.addSublayer(myLayer)
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.back(_:)), addSubview: true)
        
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
        populateDialView()
        setDialConfiguration(unit: unit, price: lastPrice)
    }
    var rectsLabelsTop = [CGFloat]()
    var rectsLabelsBottom = [CGFloat]()
    var rectsLabelsTopBig = [CGFloat]()
    var rectsLabelsBottomBig = [CGFloat]()
    var rectsLabelsPrice = [CGFloat]()
    var dialPrice = Double()
    var offset = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColor.black33
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center.y = view.center.y
        activityView.center.x = view.center.x
        activityView.startAnimating()
        activityView.alpha = 1.0
        view.addSubview(activityView)
        
        prepareGraph() { [weak self ] (_dateArray,_closings) -> Void in
            guard let weakself = self,
                let closings = _closings,
                let dateArray = _dateArray,
                let lastClose = closings.last else {return}
            
            DispatchQueue.main.async {
                weakself.loadItAll()
            }
            
            DispatchQueue.main.async {
                weakself.graph = DailyGraphForAlertView(graphData: closings, dateArray: dateArray)
                
                weakself.container.addSubview(weakself.graph)
            }
            weakself.populateDisplayValues(currentPrice: lastClose)
            weakself.dialPrice = lastClose
            
            
            let a:CGFloat = -0.72
            let c:CGFloat = 1000
            weakself.offset = (CGFloat(lastClose) - a)*weakself.screenWidth*75053.5/(375*(c-a))
            
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0, y: -100)
            t = t.scaledBy(x: 1.0, y: 0.01)
            
            DispatchQueue.main.async {
                weakself.graph.transform = t
                weakself.activityView.removeFromSuperview()
                weakself.setupDialCollectionView()
                print("CELL")
                print(weakself.cellSize.width)
                print(weakself.lastPrice)
                print(weakself.denominationDouble)
                weakself.collectionView?.contentOffset.x = weakself.cellSize.width * CGFloat(weakself.lastPrice) / CGFloat(weakself.denominationDouble)
                UIView.animate(withDuration: 1.0) {
                    
                    weakself.graph.transform = CGAffineTransform.identity
                    weakself.graph.frame.origin.y = 50*weakself.screenHeight/667
                }
                
                
                weakself.delay(bySeconds: 0.6) {
                    
                    for i in 0..<weakself.graph.labels.count {
                        weakself.delay(bySeconds: 0.15) {
                            UIView.animate(withDuration: 0.15*Double(i)) {
                                
                                weakself.graph.grids[weakself.graph.labels.count - i - 1].alpha = 1.0
                                weakself.graph.labels[weakself.graph.labels.count - i - 1].alpha = 1.0
                                weakself.graph.dayLabels[weakself.graph.labels.count - i - 1].alpha = 1.0
                                
                            }
                        }
                    }
                }
            }
            weakself.alertPrice = lastClose
            weakself.lastPrice = lastClose
            // ##TODO: add unit = .dollar
        }
        
    }
    
    let dialCollectionCellID = "dialCell"
    private func setupDialCollectionView() {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 494*screenHeight/667 - 206*screenWidth/375, width: screenWidth, height: 103*screenWidth/375)
        collectionView?.contentSize = CGSize(width: cellSize.width * CGFloat(priceArray.count), height: 103*screenWidth/375)
        collectionView = DialCollectionView(frame: frame, collectionViewLayout: collectionLayout, delegate: self, dataSource: self, cellID: dialCollectionCellID)
       
        view.addSubview(collectionView!)
        
    }
    
    func populateDisplayValues(currentPrice: Double) {
        if displayValues.count > 0 {
            displayValues.removeAll()
        }
        if currentPrice > 32.0 && currentPrice < 160.0 {
            for i in -3..<357 {
                displayValues.append(currentPrice - 32.0 + Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        } else if currentPrice >= 160.00 && currentPrice < 320.0 {
            for i in 0..<360 {
                displayValues.append(currentPrice - 160.0 + 5*Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        } else if currentPrice >= 320.00 {
            for i in 0..<360 {
                displayValues.append(currentPrice - 320.0 + 10*Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        } else if currentPrice > 0.00 && currentPrice <= 32.0 {
            for i in -3..<357 {
                displayValues.append(Double(i)) //10*screenwidth goes 2-65 or 0-67 so 32 would be middle
            }
        }
    }
    
    func populateDialView() {
        
        let backdrop = UIView()
        backdrop.backgroundColor = CustomColor.black42
        backdrop.frame.size = dial.contentSize
        backdrop.frame.origin = CGPoint(x: 0, y: 0)
        for i in 0...50 {
            let dialImage = UIImageView()
            dialImage.frame.origin = CGPoint(x: CGFloat(i)*3000*screenWidth/375, y: 0)
            dialImage.frame.size = CGSize(width: 3000*screenWidth/375, height: 103*screenWidth/375)
            dialImage.image = #imageLiteral(resourceName: "Dial")
            dialImage.contentMode = UIViewContentMode.scaleAspectFit
            dial.addSubview(dialImage)
            
        }
        
        let f = 14*fontSizeMultiplier
        var count = 0
        for xVal in Set2.priceRectX {
            
            let alertOption = UILabel()
            alertOption.frame = CGRect(x: xVal, y: 19*screenWidth/375, width: 100*screenWidth/375, height: 62*screenWidth/375)
            
            alertOption.text = String(count)
            
            count += 1
            alertOption.textAlignment = .center
            alertOption.textColor = .white
            alertOption.font = UIFont(name: "Roboto-Bold", size: f)
            dial.addSubview(alertOption)
            
        }
        
        let dialMask = UILabel()
        dialMask.frame = CGRect(x: 0, y: 514*screenHeight/667, width: screenWidth, height: 60*screenWidth/375)
        dialMask.backgroundColor = CustomColor.black42Alpha0
        
        view.addSubview(dialMask)
        
        addGradient(mask: dialMask, color1: CustomColor.black42, color2: CustomColor.black42Alpha0, start: CGPoint(x: -0.2, y: 0.0), end: CGPoint(x: 0.45, y: 0.0))
        addGradient(mask: dialMask, color1: CustomColor.black42Alpha0, color2: CustomColor.black42, start: CGPoint(x: 0.55, y: 0.0), end: CGPoint(x: 1.2, y: 0.0))
        
    }
    
    @objc private func back(_ sender: UIButton) {
        performSegue(withIdentifier: "fromAddStockPriceToAddStockTicker", sender: self)
    }
    
    @objc private func setFunc(_ sender: UIButton) {
        performSegue(withIdentifier: "fromAddStockPriceToAddStockAlert", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddStockPriceToAddStockAlert" {
            if let destinationViewController: AddStockAlertViewController = segue.destination as? AddStockAlertViewController {
                destinationViewController.newAlertTicker = newAlertTicker
                destinationViewController.newAlertPrice = newAlertPrice
                destinationViewController.lastPrice = lastPrice
                destinationViewController.priceString = priceLabel.text ?? ""
            }
        }
    }
    
    // here i'm giving it two chances to fetch the data otherwise it returns to addstockticker controller view with no error displayed to user
    private func prepareGraph(result: @escaping (_ dateArray: [(String,Int)]?,_ closings: [Double]?) -> Void) {
        
        let alphaAPI = Alpha()
        alphaAPI.get20YearHistoricalData(ticker: newAlertTicker, isOneYear: false) { (dataSet) in
            if dataSet == nil {
                alphaAPI.get20YearHistoricalData(ticker: self.newAlertTicker, isOneYear: false) { [weak self] (dataSet) in
                    guard let dataSet = dataSet else {self?.performSegue(withIdentifier: "fromAddStockPriceToAddStockTicker", sender: self); return}
                    Set1.cachedInThisSession.append(dataSet.ticker)
                    Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                    Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                    
                    var dates = [(String,Int)]()
                    for i in 0..<dataSet.day.count {
                        dates.append((dataSet.month[i],dataSet.day[i]))
                    }
                    result(dates,dataSet.price)
                }
            } else {
                guard let dataSet = dataSet else {return}
                Set1.cachedInThisSession.append(dataSet.ticker)
                Set1.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                Set1.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
                var dates = [(String,Int)]()
                for i in 0..<dataSet.day.count {
                    dates.append((dataSet.month[i],dataSet.day[i]))
                }
                result(dates,dataSet.price)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reachabilityAddNotification()
    }
    
    var isFirst = true
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {

            let price = Double(scrollView.contentOffset.x / cellSize.width) * denominationDouble
          
//            alertPrice = Double(price)
            
            
            if price < 0.00 {
                priceLabel.text = "$0.00"
                priceString = "0.00"
            } else if price < 5.00 {
                priceLabel.text = "$" + String(format: "%.2f", price)
                priceString = String(format: "%.2f", price)
            } else if price < 1000 {
                priceLabel.text = "$" + String(format: "%.1f", price) + "0"
                priceString = String(format: "%.1f", price) + "0"
            } else if price < 10000 {
                let newprice = price/1000
                priceLabel.text = "$" + String(format: "%.1f", newprice) + "k"
                priceString = String(format: "%.1f", price)
            } else {
                priceLabel.text = "$" + String(format: "%.0f", price)
                priceString = String(format: "%.0f", price)
            }

            if let priceDoub = Double(priceString) {
                newAlertPrice = priceDoub
            }
            
            if !isFirst {
                if lastPrice > newAlertPrice + 0.1 && arrow.image != #imageLiteral(resourceName: "downArrow") {
                    arrow.image = #imageLiteral(resourceName: "downArrow")
                } else if lastPrice < newAlertPrice - 0.1 && arrow.image != #imageLiteral(resourceName: "upArrow") {
                    arrow.image = #imageLiteral(resourceName: "upArrow")
                }
            } else {
                isFirst = false
            }
            
        }
       
        
//        if scrollView == dial {
//
//            let offset = Float(scrollView.contentOffset.x)
//            // little messy here but should be just a linear calculation, the labeling could be wrong too
//
//            let a:Float = -0.72
//            let c:Float = 1000
//            let price = (offset*(c-a)/75053.5)*375/Float(screenWidth) + a
//            dialPrice = Double(price)
//
//
//            if price < 0.00 {
//                priceLabel.text = "$0.00"
//                priceString = "0.00"
//            } else if price < 5.00 {
//                priceLabel.text = "$" + String(format: "%.2f", price)
//                priceString = String(format: "%.2f", price)
//            } else if price > 2000.0 {
//                priceLabel.text = "$2000"
//                priceString = "2000"
//            } else {
//                priceLabel.text = "$" + String(format: "%.1f", price) + "0"
//                priceString = String(format: "%.1f", price) + "0"
//            }
//            if price > 999.99 {
//                if let textString = priceLabel.text?.dropFirst() {
//                    priceLabel.text = String(textString)
//                }
//            }
//            if let priceDoub = Double(priceString) {
//                newAlertPrice = priceDoub
//            }
//
//            if !isFirst {
//                if lastPrice > dialPrice + 0.1 && arrow.image != #imageLiteral(resourceName: "downArrow") {
//                    arrow.image = #imageLiteral(resourceName: "downArrow")
//                } else if lastPrice < dialPrice - 0.1 && arrow.image != #imageLiteral(resourceName: "upArrow") {
//                    arrow.image = #imageLiteral(resourceName: "upArrow")
//                }
//            } else {
//                isFirst = false
//            }
//
//        }
        
    }
    
    private func addGradient(mask: UILabel, color1: UIColor, color2: UIColor, start: CGPoint, end: CGPoint){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = mask.bounds.size
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.startPoint = start
        gradient.endPoint = end
        
        mask.layer.addSublayer(gradient)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachabilityRemoveNotification()
    }
    
    private func setDialConfiguration(unit: DialUnit, price: Double) {
        
        setPriceArray(priceStart: price)
        
    }
    
    var priceArray: [Double] = [-1,-1]
    private enum Denomination {
        case ones, tens, hundreds
    }
    private var denomination: Denomination = .ones
    private var denominationDouble: Double = 0.0
    func setPriceArray(priceStart: Double) {
        
        if priceStart > 10000 {
            denomination = .hundreds
            denominationDouble = 100
        } else if priceStart > 1000 {
            denomination = .tens
            denominationDouble = 10
        } else {
            denomination = .ones
            denominationDouble = 1
        }
        var price: Double = 0.0
        while priceArray.count < 10000 {
            priceArray.append(price)
            price += denominationDouble
        }
        
    }
}

extension AddStockPriceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return priceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dialCollectionCellID, for: indexPath) as! DialCell
  
        cell.set(price: String(priceArray[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}
