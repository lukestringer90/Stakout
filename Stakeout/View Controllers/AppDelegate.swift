//
//  AppDelegate.swift
//  Stakeout
//
//  Created by Luke Stringer on 30/03/2018.
//  Copyright © 2018 Luke Stringer. All rights reserved.
//

import UIKit
import TwitterKit
import Keys
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		TWTRTwitter.sharedInstance().start(withConsumerKey: StakeoutKeys().twitterConsumerKey,
									   consumerSecret: StakeoutKeys().twitterConsumerSecret)
		
		MSAppCenter.start(StakeoutKeys().appCenterAppSecret, withServices: [MSAnalytics.self, MSCrashes.self])
		
        // Only need notification if we are using location background updates
        if Constants.enableBackgroundLocationUpdates {
            registerForPushNotifications()
        }
		
		return true
	}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		let token = tokenParts.joined()
		print("Device Token: \(token)")
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register: \(error)")
	}
	
	func registerForPushNotifications() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
			[weak self] granted, error in
			
			print("Permission granted: \(granted)")
			guard granted else { return }
			self?.getNotificationSettings()
		}
	}
	
	func getNotificationSettings() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			print("Notification settings: \(settings)")
			guard settings.authorizationStatus == .authorized else { return }
			DispatchQueue.main.async {
				UIApplication.shared.registerForRemoteNotifications()
			}
		}
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		print(userInfo)
		completionHandler(.newData)
		
		NotificationSender.sendNotification(title: "Local Notification", subtitle: "This has come from server ")
		

	}
}

