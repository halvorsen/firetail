//
//  LineChartView.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

/// Chart that draws lines, surfaces, circles, ...
open class LineChartView: BarLineChartViewBase, LineChartDataProvider
{

    internal override func initialize()
    {
        super.initialize()
        
        renderer = LineChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
        
        //Aaron Halvorsen Edit
        
        //  globalRenderer =  renderer
        
        //Aaron Halvorsen End Edit
    }
    
    // MARK: - LineChartDataProvider
    
    //Aaron Halvorsen Edit
    
//    open var globalPath: CGMutablePath? {
//        var myRenderer: LineChartRenderer = LineChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
//        
//        print("globalPath in LINECHARTVIEW: \(myRenderer.globalPath)")
//        return myRenderer.globalPath }
    
    //Aaron Halvorsen End Edit
    
    open var lineData: LineChartData? { return _data as? LineChartData }
}
