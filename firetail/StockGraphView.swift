//
//  StockGraphView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/19/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import BigBoard

class StockGraphView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let customColor = CustomColor()
    let graphHeight: CGFloat = 6*UIScreen.main.bounds.width/7
    var curvePath = UIBezierPath()
    //let stockData = StockData()
    
    
    init(stockData: StockData) {
        
        super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))
        
        
        
        var dataEntries = GraphSet()
        for i in 0..<stockData.closingPrice.count {
            var dataEntry = DataPoint()
            dataEntry.xValue = CGFloat(i) + 1
            dataEntry.yValue = CGFloat(stockData.closingPrice[i])
            dataEntries.allPoints.append(dataEntry)
        }
        print("graph height: \(graphHeight)")
        let plotShape = CAShapeLayer()
        let scaleRange: CGFloat = 1.0
        let scaleBottom: CGFloat = 1.0*graphHeight
        let yRange = dataEntries.yMaximum - dataEntries.yMinimum
        print("yRange: \(yRange)")
        print("datapoints: \(dataEntries.allPoints.count)")
        let tic = self.bounds.width/CGFloat(dataEntries.allPoints.count - 1)
        let first = 0.666*(graphHeight - scaleRange*graphHeight*((dataEntries.allPoints[0].yValue - dataEntries.yMinimum)/yRange))+0.1666*graphHeight
        curvePath.move(to: CGPoint(x: 0, y: first))
        for i in 1..<dataEntries.allPoints.count {
            curvePath.addLine(to: CGPoint(x: CGFloat(i)*tic, y: 0.666*(graphHeight - scaleRange*graphHeight*((dataEntries.allPoints[i].yValue - dataEntries.yMinimum)/yRange))+0.1666*graphHeight))
            
        }
        curvePath.addLine(to: CGPoint(x: self.bounds.width, y: scaleBottom))
        curvePath.addLine(to: CGPoint(x: 0, y: scaleBottom))
        curvePath.addLine(to: CGPoint(x: 0, y: first))
        
        curvePath.close()
        //  curvePath.lineJoinStyle = .round
        //  curvePath.lineJoinStyle
        customColor.yellow.setStroke()
        curvePath.stroke()
        plotShape.path = curvePath.cgPath
        plotShape.fillColor = customColor.yellow.cgColor
        self.layer.addSublayer(plotShape)
        //layer.bounds.origin.x = 0
        // plotShape.bounds.origin.y = -graphHeight
        
        self.backgroundColor = customColor.gray
        
        
        var horizontalGridPath = UIBezierPath()
        var vGridPath = UIBezierPath()
        for i in 1...5 {
            horizontalGridPath.move(to: CGPoint(x: 80*screenWidth/750, y: graphHeight/6*CGFloat(i) - 1))
            horizontalGridPath.addLine(to: CGPoint(x: screenWidth, y: graphHeight/6*CGFloat(i) - 1))
            horizontalGridPath.addLine(to: CGPoint(x: screenWidth, y: graphHeight/6*CGFloat(i)))
            horizontalGridPath.addLine(to: CGPoint(x: 80*screenWidth/750, y: graphHeight/6*CGFloat(i)))
            horizontalGridPath.addLine(to: CGPoint(x: 80*screenWidth/750, y: graphHeight/6*CGFloat(i) - 1))
            horizontalGridPath.close()
            UIColor.red.setStroke()
            horizontalGridPath.stroke()
        }
        let gridShape = CAShapeLayer()
        gridShape.zPosition = 2
        gridShape.path = horizontalGridPath.cgPath
        gridShape.fillColor = customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape)
        for i in 0...5 {
            vGridPath.move(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 - screenWidth/750, y: 0))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 - screenWidth/750, y: self.frame.height))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 + screenWidth/750, y: self.frame.height))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 + screenWidth/750, y: 0))
            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 - screenWidth/750, y: 0))
            vGridPath.close()
            UIColor.red.setStroke()
            // horizontalGridPath.lineWidth = 2.0
            vGridPath.stroke()
            
            
        }
        //        for i in 0...7 {
        //            vGridPath.move(to: CGPoint(x: CGFloat(i)*screenWidth/9 + screenWidth/9 - screenWidth/750, y: 0))
        //            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/9 + screenWidth/9 - screenWidth/750, y: self.frame.height))
        //            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/9 + screenWidth/9 + screenWidth/750, y: self.frame.height))
        //            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/9 + screenWidth/9 + screenWidth/750, y: 0))
        //            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/9 + screenWidth/9 - screenWidth/750, y: 0))
        //            vGridPath.close()
        //            UIColor.red.setStroke()
        //            vGridPath.stroke()
        //
        //
        //        }
        let gridShape2 = CAShapeLayer()
        gridShape2.zPosition = 2
        gridShape2.path = vGridPath.cgPath
        gridShape2.fillColor = customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape2)
        
        let (y1,y2,y3,y4,y5,x1,x2,x3,x4,x5,x6,x7,x8,x9) = (UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel())
        let ys = [y1,y2,y3,y4,y5]
        let xs = [x1,x2,x3,x4,x5,x6,x7,x8,x9]
        var yLabels: [String] {
            get {
                
                var _yLabels = [String]()
                for i in 0...4 {
                    let atom = Float(i)*Float(dataEntries.yMaximum - dataEntries.yMinimum)/4
                    if i != 0 && i != 4 {
                        _yLabels.append(String(Int(Float(dataEntries.yMinimum) + atom)) + ".00")
                    } else {
                        
                        _yLabels.append(String(format: "%.2f", Float(dataEntries.yMinimum) + atom))
                        
                    }
                }
                return _yLabels
            }
        }
        var xLabels: [String] {
            get {
                var _xLabels = ["MAX","5yr","1yr","3m","1m","5d","1d"]
                //                var _xLabels = [String]()
                //                for i in 0...5 {
                //
                //                    _xLabels.append(String(i))
                //
                //                }
                return _xLabels
            }
        }
        for i in 0...4 {
            let yY = (1111.66-222.33*CGFloat(i))*graphHeight/screenHeight - 9
            addLabel(name: ys[i], text: yLabels[i], textColor: customColor.labelGray, textAlignment: .right, fontName: "HelveticaNeue-Bold", fontSize: 10, x: 0, y: yY, width: 70, height: 18, lines: 1)
            self.addSubview(ys[i])
        }
        
        //make a switch for different graph ranges
        
        for i in 0...6 {
            addLabel(name: xs[i], text: xLabels[i], textColor: customColor.labelGray, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 10, x: (screenWidth/8)*(CGFloat(i)+1)*1334/screenHeight - 30, y: graphHeight*1334/screenHeight + 20, width: 60, height: 75, lines: 1)
            if xs[i].text == "1m" {
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

struct GraphSet {
    var allPoints = [DataPoint]()
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

struct DataPoint {
    var xValue = CGFloat()
    var yValue = CGFloat()
    
}
struct StockData {
    var dates = [Date]()
    var closingPrice = [Double]()
}

//class BigBoardStock : Mappable {
//    open func mapOneDayChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//    open func mapFiveDayChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//    open func mapOneMonthChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//    open func mapThreeMonthChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//    open func mapOneYearChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//    open func mapFiveYearChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//    open func mapLifetimeChartDataModule(success:(() -> Void)?, failure:(BigBoardError) -> Void) -> Request?
//}


func callCorrectGraph(stockName: String, chart: String, result: @escaping (_ stockData: StockData?) -> Void) {
    BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in

        var stockData = StockData()
        let charts = ["1d":stock.mapOneDayChartDataModule,"5d":stock.mapFiveDayChartDataModule,"1m":stock.mapOneMonthChartDataModule,"3m":stock.mapThreeMonthChartDataModule,"1y":stock.mapOneYearChartDataModule,"5y":stock.mapFiveYearChartDataModule,"max":stock.mapLifetimeChartDataModule]

            charts[chart]!({
                let chartsModule = ["1d":stock.oneDayChartModule,"5d":stock.fiveDayChartModule,"1m":stock.oneMonthChartModule,"3m":stock.threeMonthChartModule,"1y":stock.oneYearChartModule,"5y":stock.fiveYearChartModule,"max":stock.lifetimeChartModule]
                let asdf: BigBoardChartDataModule? = chartsModule[chart]!
                if asdf != nil { //oneMonthChartModule
                    stockData.closingPrice.removeAll()
                    stockData.dates.removeAll()
                    //                print("stock.oneMonthChartModule!")
                    //                print(stock.oneMonthChartModule?.dataPoints)
                    for point in (asdf?.dataPoints)! {
                        stockData.dates.append(point.date)
                        stockData.closingPrice.append(point.close)
                        print(point.date)
                        print(point.close)
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




