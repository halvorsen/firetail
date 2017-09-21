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

// fabric build phase run script that was removed:
//"${PODS_ROOT}/Fabric/run" a9cc3c114b202ec31390e423f8db307328800a9f 8999b85b5b17d0926cf3c5c45657aee0032aa33c613d4bf7779c97b9eaefdeca

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

        // Override point for customization after application launch.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(_:)),name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        
        if UserDefaults.standard.bool(forKey: "fireTailLaunchedBefore") {
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
        } else {
            Set1.logoutFirebase()
            UserDefaults.standard.set(true, forKey: "fireTailLaunchedBefore")
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        
        //load and print cached items
        let casheManager = CacheManager()
        casheManager.loadData()
        

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
            print("InstanceID token: \(refreshedToken)")
            Set1.token = refreshedToken
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
      //  Messaging.messaging().disconnect()
       // print("Disconnected from FCM.")
       // try! Auth.auth().signOut()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       // try! Auth.auth().signOut()
        
        
        
        
        
        connectToFcm()
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
     //   self.saveContext()
    }

    // MARK: - Core Data stack

    
    @objc private func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            Set1.token = refreshedToken
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
      //  Messaging.messaging().disconnect()
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        
//        connect { (error) in
//            if error != nil {
//                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
//            } else {
//                print("Connected to FCM.")
//            }
//        }
    }
    
    public func application(received remoteMessage: MessagingRemoteMessage) {
        print("Minnesota")
        print(remoteMessage.appData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Will not be called until you open your application from the remote notification (returns to foreground)
        
        // Note: *with swizzling disabled you must let Messaging know about the message
        // Messaging.messaging().appDidReceiveMessage(userInfo)`
        
        // Print message ID.
        if let messageId = userInfo["gcm.message_id"] {
            print("Message Id: \(messageId)")
        }
        
        // Print full message.
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Will not be called until you open your application from the remote notification (returns to foreground)
        
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
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // Print message ID.
//        let gcmMessageIDKey = "blah"
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // Print message ID.
//        let gcmMessageIDKey = "blah"
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//        
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
}

