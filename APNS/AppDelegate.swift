//
//  AppDelegate.swift
//  APNS
//
//  Created by John Ryan on 7/23/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didRefreshRegistrationToken:\(fcmToken)")
    }
    
    @available(iOS 10.0, *)
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didReceive Remote Message:\(remoteMessage.appData)")
        
        guard let datas =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: datas, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       /* FirebaseApp.configure()
        Messaging.messaging().shouldEstablishDirectChannel = true
        
            
            if #available(iOS 10.0, *) {
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in})
                
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                }
       application.registerForRemoteNotifications()
      */
        debugPrint("### 1 AppDelegate didFinishLaunchingWithOptions")
        self.initializeFCM(application)
        let toke = InstanceID.instanceID().token()
        
        debugPrint("GCM TOKEN (dev's) = \(String(describing: toke))")
        
        let token = Messaging.messaging().fcmToken
        print("Current FCM-Token (mine) is \(token ?? "")")
       
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //FIRMessaging.messaging().disconnect()
        
        debugPrint("###> 1.2 AppDelegate DidEnterBackground")
        //        self.doServiceTry()
    }
  
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        debugPrint("###> 1.3 AppDelegate didBecomeActive")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    func initializeFCM(_ application: UIApplication) {
        print("InitializeFCM")
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (accepted, error) in
                if !accepted {
                    print("Notification Access Denied")
                }
                else {
                    print("Notification Access Accepted")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
            }
        }
        else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
        }
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    //----------------------------------------------------------------------------------------------------------------
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle on Background
        debugPrint("*** didReceive response Notification ")
        debugPrint("*** response: \(response)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle in App Foreground
        debugPrint("*** willPresent notification")
        debugPrint("*** notification: \(notification)")
    }
 
  
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: DATA")
        let tokens = String(format: "%@", deviceToken as CVarArg)
        debugPrint("*** deviceToken: \(tokens)")
        Messaging.messaging().apnsToken = deviceToken
        debugPrint("Firebase Token:",InstanceID.instanceID().token() as Any)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo["gcm.message_id"] {
            debugPrint("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("###> 1.3 AppDelegate applicationWillResignActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("###> 1.3 AppDelegate applicationWillTerminate")
    }
    
//----------------------------------------MESSAGING--END---------------------------------------------
    
    
    
    
    
} //    LAST brace of class AppDelegate










