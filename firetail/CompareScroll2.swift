//
//  CompareScroll.swift
//  firetail
//
//  Created by Aaron Halvorsen on 3/8/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//
//252 doubles in a year of stock closings. (12 sets of 21)
//screenWidth fits 5 months, need 12 months plus 1 future projection 3mo out? or 1mo out?

import UIKit

class CompareScroll2: UIScrollView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let customColor = CustomColor()
    var yScrollCenterLocation: CGFloat = 3000*UIScreen.main.bounds.height/600
    var __set = [Double]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        //drawCubicBezier(dataSet: __set)
        
        //        // create path (see previous code)
        //        let path = createBezierPath()
        //
        //        // fill
        //        let fillColor = UIColor.white
        //        fillColor.setFill()
        //
        //        // stroke
        //        path.lineWidth = 1.0
        //        let strokeColor = UIColor.blue
        //        strokeColor.setStroke()
        //
        //        // Move the path to a new location
        //        path.apply(CGAffineTransform(translationX: 10, y: 10))
        //
        //        // fill and stroke the path (always do these last)
        //        path.fill()
        //        path.stroke()
        
    }
    
    
    
    
    
    init(graphData: ([String],[[Double]]), frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = customColor.fieldLines
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        var _set = [Double]()
        for i in 0...11 {
            _set.append(set[Int(21*i)])
        }
        print("_set: \(_set)")
        _set = _set.map { $0 / _set.first! - 1 }
        __set = [0.0] + _set + [0.0]
        print("__set: \(__set)")
        setup(dataSet: __set)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func drawCubicBezier(dataSet: [Double]) -> UIBezierPath      //dataSet: ILineChartDataSet)
    {
        
        let phaseY: Double = 1.0
        
        
        let intensity: CGFloat = 2.0
        
        // the path for the cubic-spline
        let cubicPath = UIBezierPath()
        let cubicPath2 = UIBezierPath()
        
        //    let valueToPixelMatrix = trans.valueToPixelMatrix
        
        if dataSet.count > 0
        {
            var prevDx: CGFloat = 0.0
            var prevDy: CGFloat = 0.0
            var curDx: CGFloat = 0.0
            var curDy: CGFloat = 0.0
            
            
            cubicPath.move(to: CGPoint(x: 0, y: self.bounds.height/2))
            
            for j in 2...(dataSet.count-3) {
                
                let mult = self.bounds.height*intensity
                
                prevDx = CGFloat(screenWidth/2.5) * intensity // this will be dx graph location
                prevDy = CGFloat((1 - dataSet[j]/0.2) - (1 - dataSet[j - 2])) * mult // this will be dy graph location
                curDx = CGFloat(screenWidth/2.5) * intensity
                curDy = CGFloat((1-dataSet[j + 1]/0.2) - (1 - dataSet[j - 1])) * mult
                print("POINT")
                print(CGPoint(
                    x: CGFloat(CGFloat(j-1)*screenWidth/5),
                    y: CGFloat(1 - dataSet[j]/0.2) * self.bounds.height * CGFloat(phaseY)))
                cubicPath.addCurve(
                    to: CGPoint(
                        x: CGFloat(CGFloat(j-1)*screenWidth/5),
                        y: CGFloat(1 - dataSet[j]/0.2) * self.bounds.height * CGFloat(phaseY)),
                    controlPoint1: CGPoint(
                        x: CGFloat(CGFloat(j-2)*screenWidth/5) + prevDx,
                        y: (CGFloat(1 - dataSet[j - 1])*self.bounds.height + prevDy) * CGFloat(phaseY)),
                    controlPoint2: CGPoint(
                        x: CGFloat(CGFloat(j-1)*screenWidth/5) - curDx,
                        y: (CGFloat(1 - dataSet[j])*self.bounds.height - curDy) * CGFloat(phaseY)))//,
                //transform: valueToPixelMatrix)
            }
        }
        
        UIColor.red.set()
        
        cubicPath.lineWidth = 6
        cubicPath.lineCapStyle = .round
        cubicPath.stroke()
        
        cubicPath2.lineWidth = 6
        cubicPath2.lineCapStyle = .round
        cubicPath2.stroke()
        
        return cubicPath
    }
    
    func setup(dataSet: [Double]) {
        
        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.path = drawCubicBezier(dataSet: dataSet).cgPath
        
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.blue.cgColor
        
        shapeLayer.lineWidth = 3.0
        shapeLayer.position = CGPoint(x: 0, y: 0)
        
        // add the new layer to our custom view
        self.layer.addSublayer(shapeLayer)
    }
    
    let set = [202.6,
               208.72,
               205.18,
               207.5,
               215.15,
               218.34,
               221.93,
               226.38,
               232.74,
               238.32,
               234.24,
               222.58,
               227.75,
               230.26,
               230.13,
               226.89,
               229.77,
               237.59,
               246.99,
               255.47,
               265.42,
               257.2,
               250.07,
               249.92,
               247.82,
               254.53,
               251.86,
               254.51,
               253.88,
               247.37,
               249.97,
               248.29,
               253.75,
               251.82,
               253.74,
               251.47,
               247.71,
               240.76,
               241.8,
               232.32,
               222.56,
               211.53,
               214.93,
               208.92,
               208.69,
               208.96,
               207.28,
               207.61,
               208.29,
               204.66,
               211.17,
               215.21,
               220.28,
               216.22,
               217.91,
               219.58,
               225.12,
               223.04,
               223.23,
               219.56,
               218.96,
               218.99,
               220.68,
               232.34,
               235.52,
               229.36,
               218.79,
               217.87,
               214.96,
               217.7,
               217.93,
               215.47,
               219.7,
               219.61,
               196.66,
               196.4,
               193.15,
               198.55,
               201.79,
               210.19,
               212.28,
               216.5,
               213.98,
               214.44,
               215.94,
               216.78,
               224.78,
               224.65,
               222.53,
               221.53,
               220.4,
               226.25,
               225.26,
               228.36,
               220.5,
               222.27,
               230.01,
               229.51,
               228.49,
               230.61,
               234.79,
               230.01,
               227.2,
               225.79,
               230.61,
               230.03,
               226.16,
               229.08,
               225.65,
               224.91,
               225.61,
               225.59,
               223.61,
               223.24,
               223.51,
               225.0,
               222.93,
               224.84,
               222.62,
               220.96,
               219.99,
               215.2,
               211.34,
               212.01,
               200.77,
               197.78,
               202.83,
               201.71,
               197.36,
               194.47,
               198.3,
               196.05,
               196.41,
               200.42,
               205.4,
               206.34,
               204.64,
               205.22,
               206.43,
               207.45,
               208.99,
               205.81,
               206.27,
               200.7,
               204.03,
               213.7,
               211.41,
               208.46,
               201.0,
               196.61,
               200.95,
               200.1,
               201.51,
               200.24,
               196.51,
               193.96,
               199.1,
               203.56,
               199.1,
               200.09,
               202.76,
               202.34,
               202.24,
               204.01,
               199.97,
               197.73,
               190.79,
               188.02,
               187.42,
               190.56,
               193.21,
               194.94,
               190.06,
               185.35,
               188.56,
               181.45,
               183.77,
               183.93,
               188.66,
               185.02,
               184.52,
               191.17,
               193.14,
               196.65,
               196.12,
               189.57,
               189.4,
               181.88,
               181.47,
               186.8,
               185.85,
               193.15,
               192.29,
               192.18,
               192.43,
               198.15,
               198.69,
               197.58,
               202.49,
               202.73,
               208.79,
               207.7,
               208.45,
               213.34,
               219.53,
               219.74,
               214.68,
               213.69,
               216.99,
               226.99,
               226.75,
               229.01,
               231.28,
               229.87,
               229.73,
               229.59,
               237.75,
               235.58,
               238.36,
               243.76,
               244.73,
               248.92,
               254.61,
               254.47,
               252.51,
               252.95,
               250.63,
               251.93,
               249.24,
               251.55,
               251.33,
               257.77,
               257.48,
               262.08,
               269.2,
               269.23,
               280.6,
               280.98,
               279.76,
               268.95,
               272.23,
               277.39,
               273.51,
               255.99,
               257.0,
               246.23,
               249.99,
               250.02,
               250.48,
               251.57,
               251.21,
               248.59,
               ]

    
}
