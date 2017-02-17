//
//  ViewController.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//



import BigBoard
import UIKit
import Charts

class GraphViewController: ViewSetup, UITextFieldDelegate {
    let customColor = CustomColor()
    var enter = UIButton()
    var sampleTextField = UITextField()
    var stockName = String()
    var stockLabel = UILabel()
    var barView = BarChartView()
    var graphView = UIView()
    var dates = [Date]()
    var closingPrice = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor.background
        addButton(name: enter, x: 0, y: 200, width: 750, height: 120, title: "Update", font: "HelveticaNeue-Bold", fontSize: 40, titleColor: .white, bgColor: customColor.yellow, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GraphViewController.enter(_:)), addSubview: true)
        addLabel(name: stockLabel, text: "", textColor: customColor.yellow, textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 40, x: 0, y: 320, width: 300, height: 120, lines: 0)
        view.addSubview(stockLabel)
        
        sampleTextField = UITextField(frame: CGRect(x: 0,y: 0,width: screenWidth ,height: 100*screenHeight/1334))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sampleTextField.delegate = self
        self.view.addSubview(sampleTextField)
        
        graphView.frame = CGRect(x: 0, y: 500*screenHeight/1334, width: screenWidth, height: screenWidth)
        barView.frame = CGRect(x: 0, y: 500*screenHeight/1334, width: screenWidth, height: screenWidth)
        
        
    }
    
    func enter(_ sender: UIButton) {
        
        if sampleTextField.text != nil && sampleTextField.delegate != nil {
            
            stockName = sampleTextField.text!
            stockLabel.text = stockName
            updateChartWithData(chartType: "line")
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
    
    var curvePath = UIBezierPath()
    func updateChartWithData(chartType: String) {
        
        
        
        if chartType == "bar" || chartType == "Bar" {
            view.addSubview(barView)
            var dataEntries: [BarChartDataEntry] = []
            for i in 0..<closingPrice.count {
                let dataEntry = BarChartDataEntry(x: Double(i)+1.0, y: closingPrice[i])
                dataEntries.append(dataEntry)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "\(stockName) Closing Prices")
            let chartData = BarChartData(dataSet: chartDataSet)
            barView.data = chartData
        }
        
        
        if chartType == "line" || chartType == "Line" {
            view.addSubview(graphView)
            var dataEntries = GraphSet()
            for i in 0..<closingPrice.count {
                var dataEntry = DataPoint()
                dataEntry.xValue = CGFloat(i) + 1
                dataEntry.yValue = CGFloat(closingPrice[i])
                dataEntries.allPoints.append(dataEntry)
            }
            let layer = CAShapeLayer()
            let heightOfGraph = dataEntries.yMaximum - dataEntries.yMinimum
            let tic = graphView.bounds.width/30
            let first = self.graphView.bounds.height - 0.8*self.graphView.bounds.height*(dataEntries.allPoints[0].yValue/heightOfGraph) + 0.1*self.graphView.bounds.height
            curvePath.move(to: CGPoint(x: 0, y: first/10))
            for i in 1..<dataEntries.allPoints.count {
                curvePath.addLine(to: CGPoint(x: CGFloat(i)*tic, y: (self.graphView.bounds.height - 0.8*self.graphView.bounds.height*(dataEntries.allPoints[i].yValue/heightOfGraph) + 0.1*self.graphView.bounds.height)/10))
            }
            curvePath.addLine(to: CGPoint(x: self.graphView.bounds.width, y: self.graphView.bounds.height/20))
            curvePath.addLine(to: CGPoint(x: 0, y: self.graphView.bounds.height/10))
            curvePath.addLine(to: CGPoint(x: 0, y: first/10))
            curvePath.close()
            customColor.yellow.setStroke()
            curvePath.stroke()
            layer.path = curvePath.cgPath
            layer.fillColor = customColor.yellow.cgColor
            graphView.layer.addSublayer(layer)
            graphView.backgroundColor = UIColor.white
            graphView.frame.origin.y += 300
            graphView.frame.origin.x += 120
            
            
            
        }
    }
    
    
    
    func oneMonthChart (stock: BigBoardStock) {
        stock.mapOneMonthChartDataModule({
            if stock.oneMonthChartModule != nil {
                self.closingPrice.removeAll()
                self.dates.removeAll()
                print("stock.oneMonthChartModule!")
                print(stock.oneMonthChartModule?.dataPoints)
                for point in (stock.oneMonthChartModule?.dataPoints)! {
                    self.dates.append(point.date)
                    self.closingPrice.append(point.close)
                    print(point.date)
                    print(point.close)
                }
                self.updateChartWithData(chartType: "line")
            } else {
                print("Error stock.onemonthchartmodule is nil")
            }
            // oneMonthChartModule is now mapped to the stock
        }, failure: { (error) in
            print(error)
        })
    }
    
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        print("TextField did begin editing method called")
    //    }
    //
    //    func textFieldDidEndEditing(textField: UITextField) {
    //        print("TextField did end editing method called")
    //    }
    //
    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    //        print("TextField should begin editing method called")
    //        return true;
    //    }
    //
    //    func textFieldShouldClear(textField: UITextField) -> Bool {
    //        print("TextField should clear method called")
    //        return true;
    //    }
    //
    //    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    //        print("TextField should snd editing method called")
    //        return true;
    //    }
    //
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    //        print("While entering the characters this method gets called")
    //        return true;
    //    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        self.view.endEditing(true)
        if sampleTextField.text != nil {
            stockName = sampleTextField.text!
            stockLabel.text = stockName
            //        textField.resignFirstResponder()
            
            BigBoard.stockWithSymbol(symbol: stockName, success: { (stock) in
                self.oneMonthChart(stock: stock)
                
            }) { (error) in
                print(error)
            }
            
        }
        return false
    }
    //
    
}


