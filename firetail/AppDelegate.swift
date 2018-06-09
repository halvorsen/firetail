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
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
     
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            Set1.token = refreshedToken
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(_:)),name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: "fireTailLaunchedBefore") {
            if let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            }
        } else {
            Set1.logoutFirebase()
            UserDefaults.standard.set(true, forKey: "fireTailLaunchedBefore")
            if let viewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            }
        }
        
        let casheManager = CacheManager()
        let _ = casheManager.loadData()
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
//        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            Set1.token = refreshedToken
            
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let refreshedToken = InstanceID.instanceID().token() {
    
            Set1.token = refreshedToken
        }
        Set1.cachedInThisSession.removeAll()
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
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            Set1.token = refreshedToken
        }
        
        connectToFcm()
    }
    
    @objc func connectToFcm() {
     
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        
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

