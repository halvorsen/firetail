//
//  AnimatedGraph.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/5/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit

class AnimatedGraph: UIView {
    
    static func createGraphs(dataPoints: [Double]) -> CGMutablePath {
        guard dataPoints.count > 4 else { return CGMutablePath()}
        let graph = GraphView(graphData: dataPoints)
        let path = graph.createPath()
        return path
    }
    
    class GraphView: UIView {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let fontSizeMultiplier = UIScreen.main.bounds.width / 375
        
        var __set = [CGFloat]()
        var passedColor = UIColor()
        let rangeMultiplier: CGFloat = 1
        let scale: CGFloat = 1
        var stock = ""
        var percentSet = [String]()
        var percentSetVal = [CGFloat]()
        var mutablePath: CGMutablePath?
        
        init(graphData: [Double], frame: CGRect = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)) {
            super.init(frame: frame)
            data = graphData.map { CGFloat($0) }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func createPath() -> CGMutablePath {
            
            let path = quadCurvedPath()
            path.addLine(to: CGPoint(x: screenWidth, y: screenWidth))
            path.addLine(to: CGPoint(x: 0, y: screenWidth))
            path.close()
            let mutablePath = CGMutablePath()
            mutablePath.addPath(path.cgPath)
            return mutablePath
        }
        
        var data: [CGFloat] = [1,1,1,1,1]
        let yadjust: CGFloat = 1.1
        let yadjust2: CGFloat = 1.18
        func coordXFor(index: Int) -> CGFloat {
            return bounds.height*yadjust2 - bounds.height * data[index] * yadjust / (data.max() ?? 1)
        }
        
        func quadCurvedPath() -> UIBezierPath {
            let path = UIBezierPath()
            let step = bounds.width / CGFloat(data.count - 1) / (scale)
            
            var p1 = CGPoint(x: 0, y: coordXFor(index: 0))
            path.move(to: p1)
            
            if (data.count == 2) {
                path.addLine(to: CGPoint(x: step, y: coordXFor(index: 1)))
                return path
            }
            
            var oldControlP: CGPoint?
            
            for i in 1..<data.count {
                let p2 = CGPoint(x: step * CGFloat(i), y: coordXFor(index: i))
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
        
    }
}
