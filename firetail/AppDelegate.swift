//
//  AppDelegate.swift
//  firetail
//
//  Created by Aaron Halvorsen on 2/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let _ = Alerts.shared // ititialize shared alert class the retrieves alerts from file storage
        UserInfo.dashboardMode = UserDefaults.standard.bool(forKey: "isCryptoDashboard") ? .crypto : .stocks
        Fabric.with([Crashlytics.self])
        
        FirebaseApp.configure()
        
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
            }
            let _ = AppStore.shared
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(_:)),name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let user = Auth.auth().currentUser
        if UserDefaults.standard.bool(forKey: "fireTailLaunchedBefore") && user != nil {
            
            self.window?.rootViewController = DashboardViewController.shared
            self.window?.makeKeyAndVisible()
            
        } else if user == nil {
            UserDefaults.standard.set(true, forKey: "fireTailLaunchedBefore")
            
            self.window?.rootViewController = SignupViewController()
            self.window?.makeKeyAndVisible()
            
        } else if UserInfo.alerts.count == 0 {
            UserDefaults.standard.set(true, forKey: "fireTailLaunchedBefore")
            
                self.window?.rootViewController = AddStockTickerViewController()
                self.window?.makeKeyAndVisible()
            
        } else {
            UserDefaults.standard.set(true, forKey: "fireTailLaunchedBefore")
            
                self.window?.rootViewController = DashboardViewController.shared
                self.window?.makeKeyAndVisible()
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
            }
        }
        UserInfo.cachedInThisSession.removeAll()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let appLoadingData = AppLoadingData()
  
         DispatchQueue.global(qos: .background).async {
        appLoadingData.fetchAllStocks()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
   
    }

    @objc private func tokenRefreshNotification(_ notification: Notification) {
        InstanceID.instanceID().instanceID { (_result, error) in
            if let result = _result {
                UserInfo.token = result.token
            }
        }
     
        connectToFcm()
    }
    
    @objc func connectToFcm() {
       
        Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    
    public func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      
        // Note: *with swizzling disabled you must let Messaging know about the message
        // Messaging.messaging().appDidReceiveMessage(userInfo)`
        
        if let messageId = userInfo["gcm.message_id"] {
            print("Message Id: \(messageId)")
        }
        
        // Print full message.
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
        // Note: *with swizzling disabled you must let Messaging know about the message
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message id
        if let messageId = userInfo["gcm.message_id"] {
            print("Message Id: \(messageId)")
        }
        
        // Print full message.
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

}

