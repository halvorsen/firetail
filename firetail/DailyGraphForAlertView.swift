

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



class DailyGraphForAlertView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let customColor = CustomColor()
    var yScrollCenterLocation: CGFloat = 3000*UIScreen.main.bounds.height/600
    var __set = [CGFloat]()
    var passedColor = UIColor()
    let scale: CGFloat = 4
    var stock = ""
    var pointSet = [CGFloat]()
    var labels = [UILabel]()
    var allStockValues = [String]()
    var grids = [GridLine]()
    var dayLabels = [UILabel]()
    var date = [Date]()
    
    
    init() {super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))}
    
    init(graphData: [Double], dateArray: [Date], frame: CGRect = CGRect(x: 0, y:0*UIScreen.main.bounds.height/667, width: 4*UIScreen.main.bounds.width, height: 160*UIScreen.main.bounds.height/667)) {
        super.init(frame: frame)
        self.backgroundColor = customColor.black42
        date = dateArray
        var _set = [Double]()
        let max = graphData.max()!
        let min = graphData.min()!
        let range = max - min
        let x = 59*screenHeight/667
        let y = 140*screenHeight/667
        _set = graphData.map {1 - ($0 - min / range) } // values go from 0 to 1
        pointSet = _set.map { CGFloat(x + CGFloat($0)*y) }
        __set = [pointSet.first!] + pointSet + [pointSet.last!] //adds extra datapoint to make quadratic curves look good on ends
        print("__set: \(__set)")
        //data = __set
        data = graphData.map {CGFloat(($0-min)/range)}
        allStockValues = graphData.map {String($0)}
        //allStockValues = __set.map {String(Double($0))}
        print("HERE IS DATA POST PROCESS: \(data)")
        setNeedsDisplay()
        let l = UILabel()
        l.frame = CGRect(x: 0, y: 160*screenHeight/667, width: 4*screenWidth, height: 4)
        l.backgroundColor = customColor.black33
        self.addSubview(l)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.translateBy(x: 0, y: 5)
        ctx!.scaleBy(x: scale, y: 0.9*scale)
        let path = quadCurvedPath()
        path.addLine(to: CGPoint(x: points.last!.x + 200, y: points.last!.y))
        path.addLine(to: CGPoint(x: points.last!.x + 200, y: -10))
        path.addLine(to: CGPoint(x: 0, y: -10))
        path.addLine(to: CGPoint(x: 0, y: points.last!.y))
        path.addLine(to: points.first!)
        path.close()
        
        
       // customColor.whiteAlpha.setStroke()
        customColor.black33.setFill()
        path.lineWidth = 1
        path.fill()
       // path.stroke()
        
        for i in 1..<points.count {
            drawPoint(point: points[i], color: .white, radius: 1)
            print("point \(point)")

        }
        
        
    }
    
    var data: [CGFloat] = [0, 0, 0, 0, 0, 0] //{
    
    func coordXFor(index: Int) -> CGFloat {
        return bounds.height / scale - (bounds.height/scale) * data[index] / (data.max() ?? 0)
    }
    
    
    var points = [CGPoint]()
    func quadCurvedPath() -> UIBezierPath {
        let path = UIBezierPath()
        let step = bounds.width / CGFloat(data.count - 1) / (scale * 1.1)
        
        var p1 = CGPoint(x: 0, y: coordXFor(index: 0))
        points.append(p1)
        path.move(to: p1)
        
        //drawPoint(point: p1, color: .white, radius: 1)
        
        if (data.count == 2) {
            path.addLine(to: CGPoint(x: step, y: coordXFor(index: 1)))
            return path
        }
        
        var oldControlP: CGPoint?
        
        for i in 1..<data.count {
            let p2 = CGPoint(x: step * CGFloat(i), y: coordXFor(index: i))
            //     drawPoint(point: p2, color: .white, radius: 1)
            points.append(p2)
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
        let v = UIView(frame: CGRect(x: 0, y: -50*screenHeight/667, width: self.frame.width, height: 50*screenHeight/667))
        v.backgroundColor = customColor.black33
        self.addSubview(v)
        let w = UIView(frame: CGRect(x: -400, y: -50*screenHeight/667, width: 400, height: 0.9*4*points.first!.y + 55*screenHeight/667))
        w.backgroundColor = customColor.black33
        self.addSubview(w)
        let ww = UIView(frame: CGRect(x: self.frame.maxX, y: -50*screenHeight/667, width: 400, height: 0.9*4*points.last!.y + 55*screenHeight/667))
        ww.backgroundColor = customColor.black33
        self.addSubview(ww)
        let extraBottomGray = UIView(frame: CGRect(x: 0, y: 160*screenHeight/667, width: screenWidth*5, height: 30*screenHeight/667))
        extraBottomGray.backgroundColor = customColor.black42
        self.addSubview(extraBottomGray)
        
        let monthString = ["","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
        for i in 1..<points.count {
            let l = UILabel()
            let monthInt = date[i].month
            let dayInt = date[i].day
            
            l.text = allStockValues[i]
            l.frame = CGRect(x: scale*(points[i].x)-25*screenWidth/375, y: 0.9*scale*(points[i].y + 5) - 60*screenHeight/667, width: 50*screenWidth/375, height: 40*screenHeight/667)
            l.font = UIFont(name: "Roboto-Medium", size: 12*fontSizeMultiplier)
            l.textColor = .white
            l.textAlignment = .center
            l.alpha = 0.0
            self.addSubview(l)
            labels.append(l)
            
            let k = UILabel()
            //k.text = dayLabelsText[i]
            k.text = "\(dayInt) \(monthString[monthInt])"
            k.frame = CGRect(x: scale*(points[i].x)-22*screenWidth/375, y: 155*screenHeight/667, width: 50*screenWidth/375, height: 40*screenHeight/667)
            k.font = UIFont(name: "Roboto-Regular", size: 13*fontSizeMultiplier)
            k.textColor = customColor.whiteAlpha30
            k.textAlignment = .center
            k.alpha = 0.0
            self.addSubview(k)
            dayLabels.append(k)
            
            
            let grid = GridLine()
            grid.frame = CGRect(x: 4*points[i].x, y: -100*screenWidth/667, width: screenWidth/375, height: 245*screenHeight/667)
            grid.backgroundColor = customColor.whiteAlpha
            self.addSubview(grid)
            grids.append(grid)
            print("grid Count: \(grids.count)")
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
