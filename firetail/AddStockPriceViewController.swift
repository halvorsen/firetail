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

final class AddStockPriceViewController: ViewSetup, UIScrollViewDelegate {
    var newAlertTicker = String()
    var newAlertTickerLabel = UILabel()
    var newAlertPrice = Double()
    let backArrow = UIButton()
    var graph = DailyGraphForAlertView()
    var container = UIScrollView()
    let indicator = UIImageView(image: #imageLiteral(resourceName: "triangleIndicator"))

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
        blockInBackground.frame = CGRect(x: 0, y: screenHeight < 668 ? 424*screenHeight/667 : 435*screenHeight/667, width: screenWidth, height: 70*screenHeight/667)
        blockInBackground.backgroundColor = CustomColor.black24
        view.addSubview(blockInBackground)
        
        setPriceAlert.text = "Set Price Alert"
        setPriceAlert.textColor = CustomColor.white115
        setPriceAlert.textAlignment = .left
        setPriceAlert.font = UIFont(name: "Roboto-Light", size: 17*commonScalar)
        view.addSubview(setPriceAlert)
        setPriceAlert.translatesAutoresizingMaskIntoConstraints = false
        setPriceAlert.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28*commonScalar).isActive = true
        setPriceAlert.centerYAnchor.constraint(equalTo: blockInBackground.centerYAnchor).isActive = true
        addLabel(name: newAlertTickerLabel, text: newAlertTicker, textColor: .white, textAlignment: .left, fontName: "DroidSerif", fontSize: 20, x: 60, y: 606, width: 200, height: 56, lines: 1)
        addLabel(name: stockSymbol, text: "symbol", textColor: CustomColor.white115, textAlignment: .left, fontName: "Roboto-Italic", fontSize: 15, x: 56, y: 657, width: 240, height: 80, lines: 1)
        container = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260*screenHeight/667))
        container.contentSize = CGSize(width: 3.8*screenWidth, height: container.bounds.height)
        container.backgroundColor = CustomColor.black47
        container.contentOffset =  CGPoint(x: 2.7*screenWidth, y: 0)
       
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        
        
        priceLabel.font = UIFont(name: "Roboto-Bold", size: 17*fontSizeMultiplier)
        priceLabel.textAlignment = .right
        priceLabel.textColor = .white
        view.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: setPriceAlert.centerYAnchor).isActive = true
        var backupConstraint = NSLayoutConstraint()
        backupConstraint = priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: setPriceAlert.rightAnchor)
        backupConstraint.priority = .required
        backupConstraint.isActive = true
        view.addSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        arrow.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        view.addSubview(setPriceAlert)
        view.addSubview(newAlertTickerLabel)
        view.addSubview(stockSymbol)
        view.addSubview(container)
        
        addButton(name: sett, x: 0, y: 1194, width: 750, height: 140, title: "SET", font: "Roboto-Bold", fontSize: 17, titleColor: .white, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.setFunc(_:)), addSubview: true)
        sett.contentHorizontalAlignment = .center
        addButton(name: backArrow, x: 0, y: 0, width: 96, height: 114, title: "", font: "HelveticalNeue-Bold", fontSize: 1, titleColor: .clear, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(AddStockPriceViewController.back(_:)), addSubview: true)
        
        backArrow.setImage(#imageLiteral(resourceName: "backarrow"), for: .normal)
     
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
        activityView = UIActivityIndicatorView(style: .whiteLarge)
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
                
                weakself.graph = DailyGraphForAlertView(graphData: closings, dateArray: dateArray)
                
                weakself.container.addSubview(weakself.graph)
                
                
                weakself.dialPrice = lastClose
                
                let a:CGFloat = -0.72
                let c:CGFloat = 1000
                weakself.offset = (CGFloat(lastClose) - a)*weakself.screenWidth*75053.5/(375*(c-a))
                weakself.activityView.removeFromSuperview()
                weakself.setupDialCollectionView()
                weakself.collectionView?.contentOffset.x = weakself.cellSize.width * CGFloat(weakself.lastPrice) / CGFloat(weakself.denominationDouble)
                
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
        let frame = CGRect(x: 0, y: screenHeight < 668 ? 494*screenHeight/667 : screenHeight - 200, width: screenWidth, height: 103*screenWidth/375)
        collectionView?.contentSize = CGSize(width: cellSize.width * CGFloat(priceArray.count), height: 103*screenWidth/375)
        collectionView = DialCollectionView(frame: frame, collectionViewLayout: collectionLayout, delegate: self, dataSource: self, cellID: dialCollectionCellID)
       
        view.addSubview(collectionView!)
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.topAnchor.constraint(equalTo: collectionView!.topAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: collectionView!.centerXAnchor).isActive = true
        
        let dialMask = UILabel()
        dialMask.frame = CGRect(x: 0, y: 514*screenHeight/667, width: screenWidth, height: 60*screenWidth/375)
        dialMask.backgroundColor = CustomColor.black42Alpha0
        
        view.addSubview(dialMask)
        
        addGradient(mask: dialMask, color1: CustomColor.black42, color2: CustomColor.black42Alpha0, start: CGPoint(x: -0.2, y: 0.0), end: CGPoint(x: 0.45, y: 0.0))
        addGradient(mask: dialMask, color1: CustomColor.black42Alpha0, color2: CustomColor.black42, start: CGPoint(x: 0.55, y: 0.0), end: CGPoint(x: 1.2, y: 0.0))
        
    }

    @objc private func back(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func setFunc(_ sender: UIButton) {
        let destinationViewController = AddStockAlertViewController()
        destinationViewController.newAlertTicker = newAlertTicker
        destinationViewController.newAlertPrice = newAlertPrice
        destinationViewController.lastPrice = lastPrice
        destinationViewController.priceString = priceLabel.text ?? ""
        destinationViewController.modalTransitionStyle = .crossDissolve
        present(destinationViewController, animated: true)
    }
    
    private func displayAlert() {
        let alert = UIAlertController(title: "", message: "Symbol not supported", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true) {
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
        }
    }
    
    private func displayAlertCrypto() {
        let alert = UIAlertController(title: "", message: "Price fetch failed", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true) {
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
        }
    }
    
    // here i'm giving it two chances to fetch the data otherwise it returns to addstockticker controller view with no error displayed to user
    private func prepareGraph(result: @escaping (_ dateArray: [(String,Int)]?,_ closings: [Double]?) -> Void) {
        if UserInfo.dashboardMode == .crypto {
            Binance.dataSetBTC = nil
            Binance.fetchBinanceDollarPrice(forTicker: newAlertTicker) { (dataSet) in
                print("DATA1")
                print(dataSet)
                guard let dataSet = dataSet else {
                    self.displayAlertCrypto()
                    return
                }
                UserInfo.cachedInThisSession.append(self.newAlertTicker)
       
                UserInfo.tenYearDictionary[self.newAlertTicker] = Array(dataSet.price.suffix(1000))
                UserInfo.oneYearDictionary[self.newAlertTicker] = Array(dataSet.price.suffix(365))
     
                var dates = [(String,Int)]()
                for i in 0..<dataSet.day.count {
                    dates.append((dataSet.month[i],dataSet.day[i]))
                }
                result(dates,dataSet.price)
            }
        } else {
            IEXAPI.get20YearHistoricalData(ticker: newAlertTicker, isOneYear: false) { [weak self] (dataSet) in
                guard let dataSet = dataSet else {
                    self?.displayAlert()
                    return
                }
                UserInfo.cachedInThisSession.append(dataSet.ticker)
                UserInfo.tenYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(2520))
                UserInfo.oneYearDictionary[dataSet.ticker] = Array(dataSet.price.suffix(252))
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
          
            if price < 0.00 {
                priceLabel.text = "$0.00"
                priceString = "0.00"
            } else if price < 1.00 {
                priceLabel.text = "$" + String(format: "%.2f", price)
                priceString = String(format: "%.2f", price)
            } else if price < 5.00 {
                priceLabel.text = "$" + String(format: "%.2f", price)
                priceString = String(format: "%.2f", price)
            } else {
                priceLabel.text = "$" + String(format: "%.1f", price) + "0"
                priceString = String(format: "%.1f", price) + "0"
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
  
        cell.set(price: priceArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}
