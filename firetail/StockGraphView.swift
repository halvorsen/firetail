////
////  StockGraphView.swift
////  firetail
////
////  Created by Aaron Halvorsen on 2/19/17.
////  Copyright © 2017 Aaron Halvorsen. All rights reserved.
////
//
//import UIKit
//import BigBoard
//
//class StockGraphView: UIView {
//
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
//    let customColor = CustomColor()
//    let graphHeight: CGFloat = 6*UIScreen.main.bounds.width/7
//    var curvePath = UIBezierPath()
//    let (y1,y2,y3,y4,y5,x1,x2,x3,x4,x5,x6,x7) = (UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel())
//    var xs = [UILabel]()
//    var ys = [UILabel]()
//    var _stockData = StockData()
//    var change = UILabel()
//    var percentChange = UILabel()
//
//    init() {super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))}
//    init(stockData: StockData) {
//        _stockData = stockData
//        super.init(frame: CGRect(x: 0, y: 388*screenHeight/1334, width: screenWidth, height: 646*screenHeight/1334))
//        ys = [y1,y2,y3,y4,y5]
//        xs = [x1,x2,x3,x4,x5,x6,x7]
//        var dataEntries = GraphSet()
//        for i in 0..<stockData.closingPrice.count {
//            var dataEntry = DataPoint()
//            dataEntry.xValue = CGFloat(i) + 1
//            dataEntry.yValue = CGFloat(stockData.closingPrice[i])
//            dataEntries.allPoints.append(dataEntry)
//        }
//
//        var changeValue: String {
//            get {
//                var _changeValue = String()
//                if (stockData.closingPrice.last)! - (stockData.closingPrice.first)! > 0 {
//                    _changeValue = "+" + String(format: "%.2f", Float((stockData.closingPrice.last)! - (stockData.closingPrice.first)!))
//
//                } else {
//                    _changeValue = String(format: "%.2f", Float((stockData.closingPrice.last)! - (stockData.closingPrice.first)!))
//                }
//                return _changeValue
//            }
//        }
//        var percentageValue: String {
//            get {
//                var _changeValue = String()
//                if (stockData.closingPrice.last! - stockData.closingPrice.first!) > 0 {
//                   _changeValue = "\u{2191}" + String(format: "%.2f", Float(100*(stockData.closingPrice.last! - stockData.closingPrice.first!)/stockData.closingPrice.first!)) + "%"
//
//                } else {
//                  _changeValue = "\u{2193}" + String(format: "%.2f", Float(100*(stockData.closingPrice.first! - stockData.closingPrice.last!)/stockData.closingPrice.first!)) + "%"
//                }
//                return _changeValue
//            }
//        }
//
//
//        addLabel(name: change, text: changeValue, textColor: .white, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 70, y: -86, width: 120, height: 32, lines: 1)
//        self.addSubview(change)
//        addLabel(name: percentChange, text: percentageValue, textColor: customColor.yellow, textAlignment: .left, fontName: "Roboto-Medium", fontSize: 15, x: 184, y: -86, width: 300, height: 32, lines: 1)
//        self.addSubview(percentChange)
//        let plotShape = CAShapeLayer()
//        let scaleRange: CGFloat = 1.0
//        let scaleBottom: CGFloat = 1.0*graphHeight
//        let yRange = dataEntries.yMaximum - dataEntries.yMinimum
//
//        let tic = self.bounds.width/CGFloat(dataEntries.allPoints.count - 1)
//        let first = 0.666*(graphHeight - scaleRange*graphHeight*((dataEntries.allPoints[0].yValue - dataEntries.yMinimum)/yRange))+0.1666*graphHeight
//        curvePath.move(to: CGPoint(x: 0, y: first))
//        for i in 1..<dataEntries.allPoints.count {
//            curvePath.addLine(to: CGPoint(x: CGFloat(i)*tic, y: 0.666*(graphHeight - scaleRange*graphHeight*((dataEntries.allPoints[i].yValue - dataEntries.yMinimum)/yRange))+0.1666*graphHeight))
//
//        }
//        curvePath.addLine(to: CGPoint(x: self.bounds.width, y: scaleBottom))
//        curvePath.addLine(to: CGPoint(x: 0, y: scaleBottom))
//        curvePath.addLine(to: CGPoint(x: 0, y: first))
//
//        curvePath.close()
//        customColor.yellow.setStroke()
//        curvePath.stroke()
//        plotShape.path = curvePath.cgPath
//        plotShape.fillColor = customColor.yellow.cgColor
//        self.layer.addSublayer(plotShape)
//
//
//        self.backgroundColor = customColor.gray
//
//
//        var horizontalGridPath = UIBezierPath()
//        var vGridPath = UIBezierPath()
//        for i in 1...5 {
//            horizontalGridPath.move(to: CGPoint(x: 80*screenWidth/750, y: graphHeight/6*CGFloat(i) - 1))
//            horizontalGridPath.addLine(to: CGPoint(x: screenWidth, y: graphHeight/6*CGFloat(i) - 1))
//            horizontalGridPath.addLine(to: CGPoint(x: screenWidth, y: graphHeight/6*CGFloat(i)))
//            horizontalGridPath.addLine(to: CGPoint(x: 80*screenWidth/750, y: graphHeight/6*CGFloat(i)))
//            horizontalGridPath.addLine(to: CGPoint(x: 80*screenWidth/750, y: graphHeight/6*CGFloat(i) - 1))
//            horizontalGridPath.close()
//            UIColor.red.setStroke()
//            horizontalGridPath.stroke()
//        }
//        let gridShape = CAShapeLayer()
//        gridShape.zPosition = 2
//        gridShape.path = horizontalGridPath.cgPath
//        gridShape.fillColor = customColor.gridGray.cgColor
//        self.layer.addSublayer(gridShape)
//        for i in 0...5 {
//            vGridPath.move(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 - screenWidth/750, y: 0))
//            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 - screenWidth/750, y: self.frame.height))
//            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 + screenWidth/750, y: self.frame.height))
//            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 + screenWidth/750, y: 0))
//            vGridPath.addLine(to: CGPoint(x: CGFloat(i)*screenWidth/7 + screenWidth/7 - screenWidth/750, y: 0))
//            vGridPath.close()
//            UIColor.red.setStroke()
//
//            vGridPath.stroke()
//
//
//        }
//
//        let gridShape2 = CAShapeLayer()
//        gridShape2.zPosition = 2
//        gridShape2.path = vGridPath.cgPath
//        gridShape2.fillColor = customColor.gridGray.cgColor
//        self.layer.addSublayer(gridShape2)
//
//
//        var yLabels: [String] {
//            get {
//                var _yLabels = [String]()
//                for i in 0...4 {
//                    let atom = Float(i)*Float(dataEntries.yMaximum - dataEntries.yMinimum)/4
//                    if i != 0 && i != 4 {
//                        _yLabels.append(String(format: "%.1f", Float(dataEntries.yMinimum) + atom) + "0")
//                       // _yLabels.append(String(Int(Float(dataEntries.yMinimum) + atom)) + ".00")
//                    } else {
//                        _yLabels.append(String(format: "%.2f", Float(dataEntries.yMinimum) + atom))
//                    }
//                }
//                return _yLabels
//            }
//        }
//        var xLabels: [String] {
//            get {
//                var _xLabels = ["Max","5y","1y","3m","1m","5d","1d"]
//                return _xLabels
//            }
//        }
//        for i in 0...4 {
//            let yY = (1111.66-222.33*CGFloat(i))*graphHeight/screenHeight - 9
//            addLabel(name: ys[i], text: yLabels[i], textColor: customColor.labelGray, textAlignment: .right, fontName: "Roboto-Regular", fontSize: 12, x: 0, y: yY, width: 85, height: 18, lines: 1)
//            self.addSubview(ys[i])
//        }
//
//        //make a switch for different graph ranges
//
//        for i in 0...6 {
//            addLabel(name: xs[i], text: xLabels[i], textColor: customColor.labelGray, textAlignment: .center, fontName: "Roboto-Regular", fontSize: 12, x: (screenWidth/8)*(CGFloat(i)+1)*1334/screenHeight - 30, y: graphHeight*1334/screenHeight + 20, width: 60, height: 75, lines: 1)
//            if xs[i].text == stockData.text {
//                xs[i].textColor = customColor.yellow
//            }
//            self.addSubview(xs[i])
//        }
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int) {
//
//        name.text = text
//        name.textColor = textColor
//        name.textAlignment = textAlignment
//        name.font = UIFont(name: fontName, size: fontSizeMultiplier*fontSize)
//        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: (width/750)*screenWidth, height: (height/750)*screenWidth)
//        name.numberOfLines = lines
//
//    }
//
//}
//
//struct GraphSet {
//    var allPoints = [DataPoint]()
//    var yMaximum: CGFloat {
//        get {
//            var maxx = CGFloat()
//            if allPoints.count > 0 {
//                maxx = allPoints[0].yValue
//                for point in allPoints {
//                    if point.yValue > maxx {
//                        maxx = point.yValue
//                    }
//                }
//            }
//            return maxx
//        }
//    }
//    var yMinimum: CGFloat {
//        get {
//            var minn = CGFloat()
//            if allPoints.count > 0 {
//                minn = allPoints[0].yValue
//                for point in allPoints {
//                    if point.yValue < minn {
//                        minn = point.yValue
//                    }
//                }
//            }
//            return minn
//        }
//    }
//    var xMaximum: CGFloat {
//        get {
//            var maxx = CGFloat()
//            if allPoints.count > 0 {
//                maxx = allPoints[0].xValue
//                for point in allPoints {
//                    if point.xValue > maxx {
//                        maxx = point.xValue
//                    }
//                }
//            }
//            return maxx
//        }
//    }
//    var xMinimum: CGFloat {
//        get {
//            var minn = CGFloat()
//            if allPoints.count > 0 {
//                minn = allPoints[0].xValue
//                for point in allPoints {
//                    if point.xValue < minn {
//                        minn = point.xValue
//                    }
//                }
//            }
//            return minn
//        }
//    }
//
//}
//
//struct DataPoint {
//    var xValue = CGFloat()
//    var yValue = CGFloat()
//
//}
//struct StockData {
//    var dates = [Date]()
//    var closingPrice = [Double]()
//    var text = String()
//}
//
//func callCorrectGraph(stockName: String, chart: String, result: @escaping (_ stockData: StockData?) -> Void) {
//    BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
//
//        var stockData = StockData()
//        stockData.text = chart
//        let charts = ["1d":stock.mapOneDayChartDataModule,"5d":stock.mapFiveDayChartDataModule,"1m":stock.mapOneMonthChartDataModule,"3m":stock.mapThreeMonthChartDataModule,"1y":stock.mapOneYearChartDataModule,"5y":stock.mapFiveYearChartDataModule,"Max":stock.mapLifetimeChartDataModule]
//
//            charts[chart]!({
//                let chartsModule = ["1d":stock.oneDayChartModule,"5d":stock.fiveDayChartModule,"1m":stock.oneMonthChartModule,"3m":stock.threeMonthChartModule,"1y":stock.oneYearChartModule,"5y":stock.fiveYearChartModule,"Max":stock.lifetimeChartModule]
//                let asdf: BigBoardChartDataModule? = chartsModule[chart]!
//                if asdf != nil { //oneMonthChartModule
//                    stockData.closingPrice.removeAll()
//                    stockData.dates.removeAll()
//                    //                print("stock.oneMonthChartModule!")
//                    //                print(stock.oneMonthChartModule?.dataPoints)
//                    for point in (asdf?.dataPoints)! {
//                        stockData.dates.append(point.date)
//                        stockData.closingPrice.append(point.close)
//                        print(point.date)
//                        print(point.close)
//                    }
//                    result(stockData)
//                } else {
//                    print("Error stock.onemonthchartmodule is nil")
//                }
//                // oneMonthChartModule is now mapped to the stock
//            }, { (error) in
//                print(error)
//                result(nil)
//            })
//        }) { (error) in
//            print(error)
//            result(nil)
//        }
//
//
//
//
//}
//
//
//
//
