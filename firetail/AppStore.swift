//
//  AppStore.swift
//  firetail
//
//  Created by Aaron Halvorsen on 9/29/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import StoreKit
import ReachabilitySwift
import Firebase

final class AppStore {
    static let shared: AppStore = AppStore()
    init() {
        if Reachability()!.isReachable {
        isUpdateAvailable()
        getCurrentTimestampIntervalSince1970()
        } else {
            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
                if Reachability()!.isReachable {
                    self.isUpdateAvailable()
                    self.getCurrentTimestampIntervalSince1970()
                    timer.invalidate()
                }
            }
        }
    }
    func askedToUpdateRecently() -> Bool {
        if let date = UserDefaults.standard.object(forKey: "rootUpdateAsk") as? Date {
            let now = Date().timeIntervalSince1970
            let deltaTime = now - date.timeIntervalSince1970
            if deltaTime > 259200 { //3days
                UserDefaults.standard.set(Date(), forKey: "rootUpdateAsk")
                return false
            }
        } else {
            UserDefaults.standard.set(Date(), forKey: "rootUpdateAsk")
        }
        return true
    }
    
    var currentTimeStamp: TimeInterval?
    var isVersionCurrent = true

    private func isUpdateAvailable() {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { return }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                //TODO: Compare against purchase ID, to not confuse with previous IAP
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else { return }
                self.isVersionCurrent = version == currentVersion
            } catch {
                // do nothing
            }
        }
        task.resume()
    }
    
    func checkIfSubscribedToProduct(completion: @escaping (_ isSubscriber: Bool?, _ expireDate: Date?) -> Void) {
        var latestExpireTimestamp: TimeInterval = 0
        _ = receiptGet { dictionary in
            if dictionary.isEmpty { completion(nil, nil) }
                        print("--------------- Dictionary: ---------------") // ##DEBUG.
                        print(dictionary) // ##DEBUG.
                        print("--------------- End of dictionary: ---------------") // ##DEBUG.

            dictionary.forEach { (key, value) in
                // check receipts and set is subscriber values and set the values on Firebase and User Info, check these on opening app each time.
                if key == "latest_receipt_info" {
                    guard let array = value as? [Any] else { completion(nil, nil); return }
                    var newExpireTimestamp: TimeInterval = 0
                    let deprecatedReceiptsArray = array.filter { entry in
                        if let dictionary = entry as? [String: Any],
                            let product = dictionary["product_id"] as? String {
                           return product == "firetail.iap.premium"
                        }
                        return false
                    }
                    if deprecatedReceiptsArray.count > 0 {
                        Firebase.persistDeprecatedSubscriber(true)
                        UserInfo.premium = true
                    }
                    
                    
                    let vultureRecepitsArray = array.filter { entry in
                        if let dictionary = entry as? [String: Any],
                            let product = dictionary["product_id"] as? String {
                            return product == "vulture2103532"
                        }
                        return false
                    }
                    for entry in vultureRecepitsArray {
                        guard let dictionary = entry as? [String: Any] else { completion(nil, nil); return }
                        
                        for (key, value) in dictionary {
                            if key == "expires_date_ms" {
                                if let timestampString = value as? NSString {
                                    let timestamp = timestampString.integerValue
                                    newExpireTimestamp = TimeInterval(timestamp)
                                }
                            }
                        }
                        if newExpireTimestamp > latestExpireTimestamp {
                            latestExpireTimestamp = newExpireTimestamp
                        }
                    }
                    guard let currentTimestamp: TimeInterval = self.currentTimeStamp else {
                        return
                    }
                    let expirationDate = Date.init(timeIntervalSince1970: latestExpireTimestamp)
                   // let secondsInADay: TimeInterval = 86400
                    if currentTimestamp < latestExpireTimestamp /*+ secondsInADay*/ {
                       // Send notification to allow premium access
                        Firebase.persistSubscriber(true)
                        UserInfo.vultureSubscriber = true
                        completion(true, expirationDate)
                    }
                    else {
                        UserInfo.vultureSubscriber = false
                        Firebase.persistSubscriber(false)
                        completion(false, expirationDate)
                    }
                }
            }
        }
    }
    
    private func getCurrentTimestampIntervalSince1970() {

        let ref = Database.database().reference().child("timestamp")
        
        // Tell the server to set the current timestamp at this location.
        ref.setValue(ServerValue.timestamp())
        
        // Read the value at the given location. It will now have the time.
        ref.observe(.value, with: {
            snap in
            if let t = snap.value as? TimeInterval {
                // Cast the value to an TimeInterval
                // and divide by 1000 to get seconds.
                print(t/1000)
                self.currentTimeStamp = t/1000
            }
        })
        
    }

    private func receiptGet(callback: @escaping (_ dictionary: [String: Any]) -> Void) {
        func errorCallback() { callback([:]) }  // callback with empty dictionary
        let appSpecificSharedSecret = "ee0ba17d135c462da505e3002831ee82"
        if let receiptPath = Bundle.main.appStoreReceiptURL?.path,
            FileManager.default.fileExists(atPath: receiptPath) {
            var receiptData: NSData?
            do {
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch {
                print("ERROR: " + error.localizedDescription)
            }
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            let requestDictionary = ["receipt-data": base64encodedReceipt!, "password": appSpecificSharedSecret]
            guard JSONSerialization.isValidJSONObject(requestDictionary) else { errorCallback();  return }
            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
                let validationURLString = "https://buy.itunes.apple.com/verifyReceipt"  // try production validation first, if fails do sandbox
                guard let validationURL = URL(string: validationURLString) else { errorCallback(); return }
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                var request = URLRequest(url: validationURL)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                DispatchQueue(label: "itunesConnect").async {
                    let task = session.uploadTask(with: request, from: requestData) { (data, _, error) in
                        if let data = data, error == nil {
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                                    let status = jsonResponse["status"] as? Int64 {
                                    switch status {
                                    case 0: // receipt verified in Production
                                        callback(jsonResponse)
                                    case 21007: // Means that our receipt is from sandbox environment, need to validate it there instead
                                        
                                        let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
                                        guard let validationURL = URL(string: validationURLString) else { errorCallback(); return }
                                        
                                        let session = URLSession(configuration: URLSessionConfiguration.default)
                                        var request = URLRequest(url: validationURL)
                                        request.httpMethod = "POST"
                                        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                                        
                                        let task = session.uploadTask(with: request, from: requestData) { (data, _, error) in
                                            if let data = data, error == nil {
                                                do {
                                                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                                                        let status = jsonResponse["status"] as? Int64 {
                                                        switch status {
                                                        case 0: // receipt verified in Production
                                                            callback(jsonResponse)
                                                        default: print("sandbox jsonResponse status: \(status)")
                                                        }
                                                    }
                                                } catch let error as NSError {
                                                    errorCallback()
                                                    print("json serialization failed with error: \(error)")
                                                }
                                            }
                                            else {
                                                errorCallback()
                                                print("the upload task returned an error: \(String(describing: error))")
                                            }
                                        }
                                        task.resume()  //  task for sandbox
                                    default: print("production jsonResponse status: \(status)")
                                    }
                                }
                                else {
                                    errorCallback()
                                }
                            } catch let error as NSError {
                                errorCallback()
                                print("json serialization failed with error: \(error)")
                            }
                        }
                        else {
                            errorCallback()
                            print("the upload task returned an error: \(String(describing: error))")
                        }
                    }
                    task.resume() // task for production
                }
            } catch let error as NSError {
                errorCallback()
                print("json serialization failed with error: \(error)")
            }
        }
        else {
            errorCallback()
        }
    }
}
