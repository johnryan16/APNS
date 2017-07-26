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
        print("New Token is /(fcmToken)")
    }
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
            FirebaseApp.configure()
            
            if #available(iOS 10.0, *) {
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in})
                
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                }
       application.registerForRemoteNotifications()
        
        
        let token = Messaging.messaging().fcmToken
        print("Current FCM-Token is \(token ?? "")")
        
        
        return true
}
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        print("%@", userInfo)
    }
}












