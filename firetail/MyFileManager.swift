//
//  FileManager.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/2/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import Foundation

internal struct MyFileManager {
    
    static func writeAlertOrderFile(filename: String, input: [String: Int]) -> Error? {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(filename + ".json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: input, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
            return error
        }
        return nil
    }
    
    static func readAlertOrderFile(named filename: String) -> [String: Int]? {
        
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(filename + ".json")
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Int] else { return nil}
            print(dictionary)
            return dictionary
        } catch {
            print(error)
        }
        return nil
    }
    
}
