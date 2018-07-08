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
        guard let path = graph?.createPath() else { return CGMutablePath() }
        return path
    }
    
    class GraphView {
    
        var data: [CGFloat] = [1,1,1,1,1]
  
        static let graphSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 0.73*UIScreen.main.bounds.width)
        var range: CGFloat = 1
        var min: CGFloat = 1
        
        init?(graphData: [Double]) {
            guard !graphData.isEmpty else { return nil }
            range = CGFloat(graphData.max()! - graphData.min()!)
            min = CGFloat(graphData.min()!)
            data = graphData.map { CGFloat($0) }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func createPath() -> CGMutablePath {
            
            let path = quadCurvedPath()
            path.addLine(to: CGPoint(x: GraphView.graphSize.width, y: GraphView.graphSize.width))
            path.addLine(to: CGPoint(x: 0, y: GraphView.graphSize.width))
            path.close()
            let mutablePath = CGMutablePath()
            mutablePath.addPath(path.cgPath)
            return mutablePath
            
        }
        
        
        func coordXFor(index: Int) -> CGFloat {
            print("-----")
            print(GraphView.graphSize.height)
            print(GraphView.graphSize.height - GraphView.graphSize.height * (data[index] - min) / range)
            return GraphView.graphSize.height - GraphView.graphSize.height * (data[index] - min) / range
        }
        
        func quadCurvedPath() -> UIBezierPath {
            let path = UIBezierPath()
            let step = GraphView.graphSize.width / CGFloat(data.count - 1)
            
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
