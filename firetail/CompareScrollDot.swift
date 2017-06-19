

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

class CompareScrollDot: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let customColor = CustomColor()
    var yScrollCenterLocation: CGFloat = 3000*UIScreen.main.bounds.height/600
    var __set = [CGFloat]()
    var passedColor = UIColor()
    let rangeMultiplier: CGFloat = 10
    let scale: CGFloat = 1.5
    
    init() {super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))}
    
    init(graphData: [Double], stockName: String, color: UIColor, frame: CGRect = CGRect(x: -2.5*UIScreen.main.bounds.width/13 - 267*UIScreen.main.bounds.width/375, y:0, width: 13*2.5*UIScreen.main.bounds.width/5, height: 259*UIScreen.main.bounds.height/667)) {
        super.init(frame: frame)
        var _graphData = graphData
        self.backgroundColor = .clear
        passedColor = color
        var _set = [CGFloat]()
        _set.append(CGFloat(_graphData.first!))
        if _graphData.count < 252 {
            while _graphData.count < 252 {
                _graphData = [_graphData.first!] + _graphData
            }
        }
        for i in 1...11 {
            _set.append(CGFloat(_graphData[Int(21*i)]))
        }
        _set.append(CGFloat(_graphData.last!))
        
        _set = _set.map { $0 * rangeMultiplier / _set.first! }
        __set = [rangeMultiplier] + _set + [_set.last!] //adds extra datapoint to make quadratic curves look good on ends

        data = __set

        setNeedsDisplay()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let path = quadCurvedPath()
        let diff = path.bounds.height * scale
        let m = __set.max()!
        let n = __set.min()!
        let f = __set.first!
        let diff2 = (m-f)/(m-n)
        ctx!.translateBy(x: 0, y: self.bounds.height/2 - diff2*diff)
        ctx!.scaleBy(x: scale, y: scale)
               
        UIColor.white.setStroke()
        path.lineWidth = 6/scale
        path.stroke()
     
        
        
    }
    
    var data: [CGFloat] = [0, 0, 0, 0, 0, 0] //{

    func coordXFor(index: Int) -> CGFloat {
        return bounds.height - bounds.height * data[index] / (data.max() ?? 0)
    }
    
    
    
    func quadCurvedPath() -> UIBezierPath {
        let path = UIBezierPath()
        let step = bounds.width / CGFloat(data.count - 1) / (scale * 1.1)
        
        var p1 = CGPoint(x: 0, y: coordXFor(index: 0))
        path.move(to: p1)
        
       // drawPoint(point: p1, color: .clear, radius: 3)
        
        if (data.count == 2) {
            path.addLine(to: CGPoint(x: step, y: coordXFor(index: 1)))
            return path
        }
        
        var oldControlP: CGPoint?
        
        for i in 1..<data.count {
            let p2 = CGPoint(x: step * CGFloat(i), y: coordXFor(index: i))
        //    drawPoint(point: p2, color: customColor.fieldLines, radius: 3)
            var p3: CGPoint?
            if i == data.count - 1 {
                p3 = nil
            } else {
                p3 = CGPoint(x: step * CGFloat(i + 1), y: coordXFor(index: i + 1))
            }
            
            let newControlP = controlPointForPoints(p1: p1, p2: p2, p3: p3)
            
            path.addCurve(to: p2, controlPoint1: oldControlP ?? p1, controlPoint2: newControlP ?? p2)
            
            p1 = p2
            oldControlP = imaginFor(point1: newControlP, center: p2)
        }
        return path;
    }
    
    func imaginFor(point1: CGPoint?, center: CGPoint?) -> CGPoint? {
        guard let p1 = point1, let center = center else {
            return nil
        }
        let newX = 2 * center.x - p1.x
        let diffY = abs(p1.y - center.y)
        let newY = center.y + diffY * (p1.y < center.y ? 1 : -1)
        
        return CGPoint(x: newX, y: newY)
    }
    
    func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2);
    }
    
    func controlPointForPoints(p1: CGPoint, p2: CGPoint, p3: CGPoint?) -> CGPoint? {
        guard let p3 = p3 else {
            return nil
        }
        
        let leftMidPoint  = midPointForPoints(p1: p1, p2: p2)
        let rightMidPoint = midPointForPoints(p1: p2, p2: p3)
        
        var controlPoint = midPointForPoints(p1: leftMidPoint, p2: imaginFor(point1: rightMidPoint, center: p2)!)
        
        
        // this part needs for optimization
        
        if p1.y < p2.y {
            if controlPoint.y < p1.y {
                controlPoint.y = p1.y
            }
            if controlPoint.y > p2.y {
                controlPoint.y = p2.y
            }
        } else {
            if controlPoint.y > p1.y {
                controlPoint.y = p1.y
            }
            if controlPoint.y < p2.y {
                controlPoint.y = p2.y
            }
        }
        
        let imaginContol = imaginFor(point1: controlPoint, center: p2)!
        if p2.y < p3.y {
            if imaginContol.y < p2.y {
                controlPoint.y = p2.y
            }
            if imaginContol.y > p3.y {
                let diffY = abs(p2.y - p3.y)
                controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
            }
        } else {
            if imaginContol.y > p2.y {
                controlPoint.y = p2.y
            }
            if imaginContol.y < p3.y {
                let diffY = abs(p2.y - p3.y)
                controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
            }
        }
        
        return controlPoint
    }
    
    func drawPoint(point: CGPoint, color: UIColor, radius: CGFloat) {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
        color.setFill()
        ovalPath.fill()
    }
    
}
