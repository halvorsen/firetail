//
//  StockGraphView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/19/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard
import Charts

public struct Label {
    public static var percentageValues = [String]()
    public static var changeValues = [String]()
    public static var percentageValuesIsPositive = [Bool]()
}

class StockGraphView2: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let customColor = CustomColor()
    let graphHeight: CGFloat = 6*UIScreen.main.bounds.width/7
    var curvePath = UIBezierPath()
    let (y1,y2,y3,y4,y5,x1,x2,x3,x4,x5,x6,x7) = (UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel())
    var xs = [UILabel]()
    var ys = [UILabel]()
    var _stockData = StockData2()
    var change = UILabel()
    var percentChange = UILabel()
    var cubicChartView = LineChartView()
    var globalCGPath: CGMutablePath? = nil
    var layerView = UIView()
    var baseOfGraphView = BaseOfGraphView()
    var base = UIView()
    var countinueBouncing = true
    var doneSquashing = false
    var graphAppearsInView = true
    var g = String()
    var upDownArrowView = UIImageView()
    
    
    
    // fills the graph view with the uploaded stock data on initialization and loaded by controller //
    func fillChartViewWithSetsOfData(dataPoints: [Double], cubic: Bool = true) {
       
        var yVal1 = [ChartDataEntry]()
        var yVal2 = [ChartDataEntry]()
        self.cubicChartView.xAxis.drawLabelsEnabled = false
        if cubic {
            self.cubicChartView.minOffset = 0
            self.cubicChartView.legend.enabled = false
            
            self.cubicChartView.rightAxis.enabled = false
            self.cubicChartView.legend.enabled = false
            self.cubicChartView.leftAxis.enabled = false
            self.cubicChartView.xAxis.labelPosition = .bottom
            self.cubicChartView.xAxis.drawGridLinesEnabled = false
            self.cubicChartView.xAxis.drawAxisLineEnabled = false
            self.cubicChartView.chartDescription?.text = ""
        }
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: dataPoints[i])
            yVal1.append(dataEntry)
        }
        
        let set1 = LineChartDataSet(values: yVal1, label: "")
        set1.mode = .horizontalBezier
        set1.drawCircleHoleEnabled = false
        set1.circleRadius = 3
        set1.cubicIntensity = 0.2
        set1.setColor(self.customColor.yellow, alpha: 1.0)
        set1.circleColors = [self.customColor.white]
        set1.lineWidth = 2
        set1.drawFilledEnabled = true
        set1.fillColor = self.customColor.yellow
        set1.fillAlpha = 1.0
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: dataPoints[i]-3.0)
            yVal2.append(dataEntry)
        }
        
        let set2 = LineChartDataSet(values: yVal2, label: "")
        set2.mode = .cubicBezier
        set2.drawCircleHoleEnabled = false
        set2.circleRadius = 2
        set2.cubicIntensity = 0.2
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        if cubic {
           
            self.cubicChartView.autoScaleMinMaxEnabled = false
            self.cubicChartView.frame = self.bounds
            self.cubicChartView.backgroundColor = UIColor.clear
            self.cubicChartView.data = data
        }
       
    }

    
//    func squash() {
//        baseOfGraphView.baseLayer.add(baseOfGraphView.layerAnimation, forKey: nil)
//        self.delay(bySeconds: 0.3) {
//            self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation2, forKey: nil)
//            self.delay(bySeconds: 0.05) {
//                self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation5, forKey: nil)
//                self.delay(bySeconds: 0.05) {
//                    self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation6, forKey: nil)
//                   // self.delay(bySeconds: 0.05) {
//                        self.doneSquashing = true
//                   // }
//                }
//            }
//            
//        }
//    }
    
//    func bounce() {
//        //     DispatchQueue.global(qos: .userInteractive).async {
//        self.delay(bySeconds: 0.0) {
//            self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation, forKey: nil)
//            self.delay(bySeconds: 0.4) {
//                self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation2, forKey: nil)
//                self.delay(bySeconds: 0.1) {
//                    self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation3, forKey: nil)
//                    self.delay(bySeconds: 0.1) {
//                        self.baseOfGraphView.baseLayer.add(self.baseOfGraphView.layerAnimation4, forKey: nil)
//                        self.delay(bySeconds: 0.4) {
//                            
//                            if self.countinueBouncing == true {
//                                self.bounce()
//                            } else {
//                                self.squash()
//                            }
//                            
//                        }
//                    }
//                }
//                
//            }
//        }
//        //  }
//        
//    }
//    
    
    var _outputValues = [Double]()
    
    func reduceDataPoints(original: [Double]) -> [Double] {
        let originalAmount = original.count
        var _original = original
        
      //  let last = original.last! //<--added to get the last value equal to last closing price and not average
        
        let setAmount: Int = originalAmount/15
        var outputValues = [Double](repeating: 0, count: 15)
        
        while _original.count%15 != 0 {
            _original.remove(at: 0)
            
        }
        for i in 0..<_original.count {
            
            let j = Int(i/setAmount)
        
            if j != 14 { //<--added to get the last value equal to last closing price and not average
         
            outputValues[j] += _original[i]
            }
        }
        outputValues[14] += Double(setAmount)*Set.currentPrice //<--added to get the last value equal to last closing price and not average
        //outputValues.append(Double(setAmount)*Set.currentPrice)

        if g == "1d" {
 
            outputValues[0] = Double(setAmount)*Set.yesterday
            
        }
   
        _outputValues = outputValues.map { $0 / Double(setAmount) }

               return _outputValues
        
    }

    func animateIt() {
        self.baseOfGraphView.alpha = 1.0
        self.baseOfGraphView.frame = CGRect(x: 0, y: 565*self.bounds.height/636, width: self.bounds.width, height: 70*self.bounds.height/636)
        
//        baseOfGraphView.baseLayer.path = baseOfGraphView.bez.cgPath
//        baseOfGraphView.baseLayer.fillColor = customColor.yellow.cgColor
//        baseOfGraphView.layer.addSublayer(baseOfGraphView.baseLayer)
 
    }
    
    override func draw(_ rect: CGRect) {
        if graphAppearsInView {
            DispatchQueue.global(qos: .utility).async {
        let horizontalGridPath = UIBezierPath()
        let vGridPath = UIBezierPath()
        for i in 1...5 {
            horizontalGridPath.move(to: CGPoint(x: 80*self.screenWidth/750, y: self.graphHeight/6*CGFloat(i) - 1))
            horizontalGridPath.addLine(to: CGPoint(x: self.screenWidth, y: self.graphHeight/6*CGFloat(i) - 1))
            horizontalGridPath.addLine(to: CGPoint(x: self.screenWidth, y: self.graphHeight/6*CGFloat(i)))
            horizontalGridPath.addLine(to: CGPoint(x: 80*self.screenWidth/750, y: self.graphHeight/6*CGFloat(i)))
            horizontalGridPath.addLine(to: CGPoint(x: 80*self.screenWidth/750, y: self.graphHeight/6*CGFloat(i) - 1))
            horizontalGridPath.close()

        }
        let gridShape = CAShapeLayer()
        gridShape.zPosition = 7
        gridShape.path = horizontalGridPath.cgPath
        gridShape.fillColor = self.customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape)
        for i in 0...5 {
            vGridPath.move(to: CGPoint(x: CGFloat(i)*self.screenWidth/7 + self.screenWidth/7 - self.screenWidth/750, y: 0))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*self.screenWidth/7 + self.screenWidth/7 - self.screenWidth/750, y: self.frame.height))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*self.screenWidth/7 + self.screenWidth/7 + self.screenWidth/750, y: self.frame.height))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*self.screenWidth/7 + self.screenWidth/7 + self.screenWidth/750, y: 0))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*self.screenWidth/7 + self.screenWidth/7 - self.screenWidth/750, y: 0))
            vGridPath.close()
  
        }
        
        let gridShape2 = CAShapeLayer()
        gridShape2.zPosition = 7
        gridShape2.path = vGridPath.cgPath
        gridShape2.fillColor = self.customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape2)
        }
        }
    }

    init() {super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))}
    init(stockData: StockData2, key: String, cubic: Bool) {

        _stockData = stockData
        super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))
        ys = [y1,y2,y3,y4,y5]
        xs = [x1,x2,x3,x4,x5,x6,x7]
        graphAppearsInView = !cubic
        baseOfGraphView.frame = CGRect(x: 0, y: 565*bounds.height/636, width: bounds.width, height: 70*bounds.height/636)
        baseOfGraphView.backgroundColor = .clear
        baseOfGraphView.layer.zPosition = 5
        self.addSubview(baseOfGraphView)
        base.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 1)
        base.backgroundColor = customColor.yellow
        base.alpha = 0.0
        base.layer.zPosition = 5
        self.addSubview(base)
        g = key

        var dataEntries = GraphSet2()
        if stockData.closingPrice.count <= 15 {
            fillChartViewWithSetsOfData(dataPoints: stockData.closingPrice, cubic: cubic)
        } else {
           // if
            fillChartViewWithSetsOfData(dataPoints: reduceDataPoints(original: stockData.closingPrice), cubic: cubic)
        }
        if cubic {
            self.addSubview(cubicChartView)
        }
        if cubic {
            var changeValue: String {
                get {
                    var _changeValue = String()
                    if (stockData.closingPrice.last)! - (stockData.closingPrice.first)! > 0 {
                        _changeValue = "+" + String(format: "%.2f", Float((stockData.closingPrice.last)! - (stockData.closingPrice.first)!))
                        
                    } else {
                        _changeValue = String(format: "%.2f", Float((stockData.closingPrice.last)! - (stockData.closingPrice.first)!))
                    }
                    return _changeValue
                }
            }
            Label.changeValues.append(changeValue)
            var percentageValue: String {
                get {
                    var _changeValue = String()
                    if (stockData.closingPrice.last! - stockData.closingPrice.first!) > 0 {
                        Label.percentageValuesIsPositive.append(true)
                        _changeValue = String(format: "%.2f", Float(100*(stockData.closingPrice.last! - stockData.closingPrice.first!)/stockData.closingPrice.first!)) + "%"
                        
                    } else {
                        Label.percentageValuesIsPositive.append(false)
                        _changeValue = String(format: "%.2f", Float(100*(stockData.closingPrice.first! - stockData.closingPrice.last!)/stockData.closingPrice.first!)) + "%"
                    }
                    return _changeValue
                }
            }
            Label.percentageValues.append(percentageValue)
        }
        
        
        addLabel(name: change, text: "", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 66, y: -86, width: 120, height: 32, lines: 1)
        self.addSubview(change)
        addLabel(name: percentChange, text: "", textColor: customColor.yellow, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 220, y: -86, width: 300, height: 32, lines: 1)
        self.addSubview(percentChange)
        upDownArrowView.frame = CGRect(x: 188*screenWidth/750, y: -44*screenHeight/667, width: 10*screenWidth/375, height: 11*screenWidth/375)
        self.addSubview(upDownArrowView)
        
        self.backgroundColor = customColor.gray
        layerView.frame = self.bounds
        self.addSubview(layerView)
         var xLabels: [String] {
            get {
                let _xLabels = ["Max","5y","1y","3m","1m","5d","1d"]
                return _xLabels
            }
        }
        for i in 0...4 {
            let yY = (1111.66-222.33*CGFloat(i))*graphHeight/screenHeight - 9
            addLabel(name: ys[i], text: "", textColor: customColor.labelGray, textAlignment: .right, fontName: "Roboto-Regular", fontSize: 12, x: 0, y: yY, width: 85, height: 20, lines: 1)
            ys[i].layer.zPosition = 7
           // if i == 0 || i == 4 { // leave the middle graph labels out
            self.addSubview(ys[i])
           // }
        }
        
        //make a switch for different graph ranges
        
        for i in 0...6 {
            addLabel(name: xs[i], text: xLabels[i], textColor: customColor.labelGray, textAlignment: .center, fontName: "Roboto-Regular", fontSize: 12, x: (screenWidth/8)*(CGFloat(i)+1)*1334/screenHeight - 30, y: graphHeight*1334/screenHeight + 20, width: 60, height: 75, lines: 1)
            if xs[i].text == key {
                xs[i].textColor = customColor.yellow
            }
            self.addSubview(xs[i])
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int) {
        
        name.text = text
        name.textColor = textColor
        name.textAlignment = textAlignment
        name.font = UIFont(name: fontName, size: fontSizeMultiplier*fontSize)
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: (width/750)*screenWidth, height: (height/750)*screenWidth)
        name.numberOfLines = lines
        
    }
    
    func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
}

struct GraphSet2 {
    var allPoints = [DataPoint2]()
    var yMaximum: CGFloat {
        get {
            var maxx = CGFloat()
            if allPoints.count > 0 {
                maxx = allPoints[0].yValue
                for point in allPoints {
                    if point.yValue > maxx {
                        maxx = point.yValue
                    }
                }
            }
            return maxx
        }
    }
    var yMinimum: CGFloat {
        get {
            var minn = CGFloat()
            if allPoints.count > 0 {
                minn = allPoints[0].yValue
                for point in allPoints {
                    if point.yValue < minn {
                        minn = point.yValue
                    }
                }
            }
            return minn
        }
    }
    var xMaximum: CGFloat {
        get {
            var maxx = CGFloat()
            if allPoints.count > 0 {
                maxx = allPoints[0].xValue
                for point in allPoints {
                    if point.xValue > maxx {
                        maxx = point.xValue
                    }
                }
            }
            return maxx
        }
    }
    var xMinimum: CGFloat {
        get {
            var minn = CGFloat()
            if allPoints.count > 0 {
                minn = allPoints[0].xValue
                for point in allPoints {
                    if point.xValue < minn {
                        minn = point.xValue
                    }
                }
            }
            return minn
        }
    }
    
    
    
}

struct DataPoint2 {
    var xValue = CGFloat()
    var yValue = CGFloat()
    
}
struct StockData2 {
    var dates = [Date]()
    var closingPrice = [Double]()
    var text = String()
}


//sends the data for each graph to the controller that sends to the view to be initiated//






