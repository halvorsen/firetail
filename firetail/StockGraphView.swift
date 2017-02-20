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
    let graphHeight: CGFloat = 646*UIScreen.main.bounds.height/1334
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
        for i in 0...4 {
            horizontalGridPath.move(to: CGPoint(x: 80*screenWidth/750, y: (CGFloat(i)*108 + 108)*screenHeight/1334))
            horizontalGridPath.addLine(to: CGPoint(x: screenWidth, y: (CGFloat(i)*108 + 108)*screenHeight/1334))
            horizontalGridPath.addLine(to: CGPoint(x: screenWidth, y: (CGFloat(i)*108 + 108)*screenHeight/1334+2*screenWidth/750))
            horizontalGridPath.addLine(to: CGPoint(x: 80*screenWidth/750, y: (CGFloat(i)*108 + 108)*screenHeight/1334+2*screenWidth/750))
            horizontalGridPath.addLine(to: CGPoint(x: 80*screenWidth/750, y: (CGFloat(i)*108 + 108)*screenHeight/1334))
            horizontalGridPath.close()
            UIColor.red.setStroke()
            // horizontalGridPath.lineWidth = 2.0
            horizontalGridPath.stroke()
            
            
        }
        let gridShape = CAShapeLayer()
        gridShape.zPosition = 2
        gridShape.path = horizontalGridPath.cgPath
        gridShape.fillColor = customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape)
        for i in 0...6 {
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
        let gridShape2 = CAShapeLayer()
        gridShape2.zPosition = 2
        gridShape2.path = vGridPath.cgPath
        gridShape2.fillColor = customColor.gridGray.cgColor
        self.layer.addSublayer(gridShape2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

func foo(stockName: String, result: @escaping (_ stockData: StockData?) -> Void) {
    BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
        var stockData = StockData()
        
        stock.mapOneMonthChartDataModule({
            if stock.oneMonthChartModule != nil {
                stockData.closingPrice.removeAll()
                stockData.dates.removeAll()
                print("stock.oneMonthChartModule!")
                print(stock.oneMonthChartModule?.dataPoints)
                for point in (stock.oneMonthChartModule?.dataPoints)! {
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
        }, failure: { (error) in
            print(error)
            result(nil)
        })
    }) { (error) in
        print(error)
        result(nil)
    }
    
}




