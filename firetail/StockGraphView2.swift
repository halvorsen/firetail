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
    var bazShape = CAShapeLayer()
    var globalCGPath: CGMutablePath? = nil
    
// fills the graph view with the uploaded stock data on initialization and loaded by controller //
    func fillChartViewWithSetsOfData(dataPoints: [Double]) {
        var yVal1 = [ChartDataEntry]()    //BarChartDataEntry] = []
        var yVal2 = [ChartDataEntry]()
        //        cubicChartView.xAxis.drawAxisLineEnabled = false
        //        cubicChartView.xAxis.drawGridLinesEnabled = false
        cubicChartView.xAxis.drawLabelsEnabled = false
        //        cubicChartView.accessibilityElementsHidden = true
        //        cubicChartView.drawBordersEnabled = false
        //        cubicChartView.drawGridBackgroundEnabled = false
        //        cubicChartView.leftAxis.drawGridLinesEnabled = false
        //        cubicChartView.rightAxis.drawGridLinesEnabled = false
        //        cubicChartView.leftAxis.drawLabelsEnabled = false
        //        cubicChartView.rightAxis.drawLabelsEnabled = false
        //        cubicChartView.leftAxis.drawZeroLineEnabled = false
        //        cubicChartView.rightAxis.drawZeroLineEnabled = false
        //        cubicChartView.leftAxis.drawTopYLabelEntryEnabled = false
        //        cubicChartView.leftAxis.drawAxisLineEnabled = false
        //        cubicChartView.rightAxis.drawTopYLabelEntryEnabled = false
        //        cubicChartView.rightAxis.drawAxisLineEnabled = false
        cubicChartView.minOffset = 0
        cubicChartView.legend.enabled = false
        
        cubicChartView.rightAxis.enabled = false
        cubicChartView.legend.enabled = false
        cubicChartView.leftAxis.enabled = false
        cubicChartView.xAxis.labelPosition = .bottom
        cubicChartView.xAxis.drawGridLinesEnabled = false
        cubicChartView.xAxis.drawAxisLineEnabled = false
        cubicChartView.chartDescription?.text = ""
        
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: dataPoints[i])
            yVal1.append(dataEntry)
            
        }
        
        let set1 = LineChartDataSet(values: yVal1, label: "")
        set1.mode = .horizontalBezier
        set1.drawCircleHoleEnabled = false
        set1.circleRadius = 3
        set1.cubicIntensity = 0.2
        set1.setColor(customColor.yellow, alpha: 1.0)
        set1.circleColors = [customColor.white]
        set1.lineWidth = 2
        set1.drawFilledEnabled = true
        set1.fillColor = customColor.yellow
        set1.fillAlpha = 1.0
        
//trying to get set1's shape "bazshape" to morph it to the next shape //
        
        
        
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
        // dataSets.append(set2)
        
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        cubicChartView.frame = self.bounds
        cubicChartView.backgroundColor = UIColor.clear
        cubicChartView.data = data
  
//        var shape = CALayer()
//        cubicChartView.layer.sublayers?.forEach { print($0) }
//
//        self.layer.addSublayer(bazShape)
        
    }
    
    
    func reduceDataPoints(original: [Double]) -> [Double] {
        let originalAmount = original.count
        var _original = original
        let setAmount: Int = originalAmount/15
        var outputValues = [Double](repeating: 0, count: 15)
        
        while _original.count%15 != 0 {
            _original.remove(at: 0)
           
        }
        for i in 0..<_original.count {
            let j = Int(i/setAmount)
            outputValues[j] += _original[i]
        }
        let _outputValues = outputValues.map { $0 / 15 }
        
        return _outputValues
        
    }
    
    
    init() {super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))}
    init(stockData: StockData2, key: String) {
     
        _stockData = stockData
        super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))
        ys = [y1,y2,y3,y4,y5]
        xs = [x1,x2,x3,x4,x5,x6,x7]
        var dataEntries = GraphSet2()
        if stockData.closingPrice.count <= 15 {
            fillChartViewWithSetsOfData(dataPoints: stockData.closingPrice)
        } else {
            fillChartViewWithSetsOfData(dataPoints: reduceDataPoints(original: stockData.closingPrice))
        }
        self.addSubview(cubicChartView)
//        print("DID THE GLOBALPATH MAKE IT???: \(globalCGPath)")
//        globalCGPath = cubicChartView.globalPath
   
//        let layer = CAShapeLayer()
//        layer.path = globalCGPath
//        layer.fillColor = UIColor.red.cgColor
//        self.layer.addSublayer(layer)
        
        
        addLabel(name: change, text: "bla", textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 70, y: -86, width: 120, height: 32, lines: 1)
        self.addSubview(change)
        addLabel(name: percentChange, text: "blah", textColor: customColor.yellow, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 184, y: -86, width: 300, height: 32, lines: 1)
        self.addSubview(percentChange)
        
        self.backgroundColor = customColor.gray
        
        
        let gridShape2 = CAShapeLayer()
        gridShape2.zPosition = 2
        //    gridShape2.path = vGridPath.cgPath
        gridShape2.fillColor = customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape2)

        var yLabels: [String] {
            get {
                var _yLabels = [String]()
                for i in 0...4 {
                    let atom = Float(i)*Float(dataEntries.yMaximum - dataEntries.yMinimum)/4
                    if i != 0 && i != 4 {
                        _yLabels.append(String(format: "%.1f", Float(dataEntries.yMinimum) + atom) + "0")
                        // _yLabels.append(String(Int(Float(dataEntries.yMinimum) + atom)) + ".00")
                    } else {
                        _yLabels.append(String(format: "%.2f", Float(dataEntries.yMinimum) + atom))
                    }
                }
                return _yLabels
            }
        }
        var xLabels: [String] {
            get {
                var _xLabels = ["Max","5y","1y","3m","1m","5d","1d"]
                return _xLabels
            }
        }
        for i in 0...4 {
            let yY = (1111.66-222.33*CGFloat(i))*graphHeight/screenHeight - 9
            addLabel(name: ys[i], text: yLabels[i], textColor: customColor.labelGray, textAlignment: .right, fontName: "Roboto-Regular", fontSize: 12, x: 0, y: yY, width: 85, height: 18, lines: 1)
            self.addSubview(ys[i])
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
func callCorrectGraph2(stockName: String, chart: String, result: @escaping (_ stockData: StockData2?) -> Void) {
    BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
       
        var stockData = StockData2()
        stockData.text = chart
        let charts = ["1d":stock.mapOneDayChartDataModule,"5d":stock.mapFiveDayChartDataModule,"1m":stock.mapOneMonthChartDataModule,"3m":stock.mapThreeMonthChartDataModule,"1y":stock.mapOneYearChartDataModule,"5y":stock.mapFiveYearChartDataModule,"Max":stock.mapLifetimeChartDataModule]
       
            charts[chart]!({
                let chartsModule = ["1d":stock.oneDayChartModule,"5d":stock.fiveDayChartModule,"1m":stock.oneMonthChartModule,"3m":stock.threeMonthChartModule,"1y":stock.oneYearChartModule,"5y":stock.fiveYearChartModule,"Max":stock.lifetimeChartModule]
                let asdf: BigBoardChartDataModule? = chartsModule[chart]!
                if asdf != nil {
                    stockData.closingPrice.removeAll()
                    stockData.dates.removeAll()
                    
                    for point in (asdf?.dataPoints)! {
                        stockData.dates.append(point.date)
                        stockData.closingPrice.append(point.close)
                  
                    }
                   
                    result(stockData)
                } else {
                    print("Error stock.onemonthchartmodule is nil")
                }
                // oneMonthChartModule is now mapped to the stock
            }, { (error) in
                print(error)
                result(nil)
            })
        
    }) { (error) in
        print(error)
        result(nil)
    }
    
}






