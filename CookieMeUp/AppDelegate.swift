//
//  AppDelegate.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 2/26/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let center = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(red: 249/255.0, green: 228/255.0, blue: 200/255.0, alpha: 1.0)

        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyCzqoAGBoxfFQbI1Va25dNuEIHtHNlJuBE")
        GMSPlacesClient.provideAPIKey("AIzaSyCzqoAGBoxfFQbI1Va25dNuEIHtHNlJuBE")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in. Show home screen
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "InitialSellerScreen")

            } else {
                // No User is signed in. Show user the login screen
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "initialNavigationController")

            }
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow,error in})
        checkAndSet()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func checkAndSet(){
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }else{
                print("seeting notification")
                let content = UNMutableNotificationContent()
                content.title = "Save The Date"
                content.body = "Starting January girlscout cookie locations will start to appear."
    
                // Specify date components
                var dateComponents = DateComponents()
                dateComponents.year = 2018
                dateComponents.month = 4
                dateComponents.day = 22
                dateComponents.timeZone = TimeZone(abbreviation: "PDT") // Japan Standard Time
                dateComponents.hour = 13
                dateComponents.minute = 31
                
                // Create date from components
                let userCalendar = Calendar.current // user calendar
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: "cookiesUp", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
            }
        }

    }
}

