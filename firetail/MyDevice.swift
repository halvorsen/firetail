//
//  Device.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/23/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//
import ReachabilitySwift
final class MyDevice {
    
    static func isConnectedToNetwork() -> Bool {
        return Reachability()!.isReachable
    }
}
