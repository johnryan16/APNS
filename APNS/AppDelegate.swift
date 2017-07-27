//
//  AppDelegate.swift
//  APNS
//
//  Created by John Ryan on 7/23/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
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
        
        let token = Messaging.messaging().fcmToken
        print("Current FCM-Token is \(token ?? "")")
       
        return true
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
                    UIApplication.shared.registerForRemoteNotifications()
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
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    //----------------------------------------------------------------------------------------------------------------
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint("didRegister notificationSettings")
        if (UNNotificationAction.options) {
    
        }
    }
    
    

    
    
} //    LAST brace of class AppDelegate
    
    



   
    
    
  


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        print("%@", userInfo)
    }
}












