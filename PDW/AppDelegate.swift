//
//  AppDelegate.swift
//  PDW
//
//  Created by Sanjin on 24/11/2016.
//  Copyright © 2016 Sanjin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import os.log
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userLog: UserLog?
    var userLogs = [UserLog]()
    var fluid: String = ""
    var fluidUnit: String = ""
    var tag: Int = 0
    
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2895958730740159~3415237626")
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if !granted {
                print("Notification access denied.")
            }
            
            // Enable or disable features based on authorization.
        }

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let glassSize = "0.1"
            defaults.set(glassSize, forKey: "glassVolumeData")
            print("glass set")
            defaults.set(0, forKey: "selectedUnit")
            print("0.3333")
            //let fluid = "Please set data in settings"
            //UserDefaults.standard.set(fluid, forKey: "loadSavedData")
            //UserDefaults.standard.set(fluid, forKey: "loadSavedGlass")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Notification canceled")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "FirstDataViewController") as! UINavigationController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }
        /*func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Update the app interface directly.
            
            // Play a sound.
            completionHandler(UNNotificationPresentationOptions.alert)
        }*/
        
        UNUserNotificationCenter.current().delegate = self
        
       /* func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                completionHandler()
        }*/

        
       /* func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            print("will present")
            completionHandler([.alert, .badge, .sound])
         
        }*/
        
        application.applicationIconBadgeNumber = 0;
        
            // Override point for customization after application launch.
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
        application.applicationIconBadgeNumber = 0;
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
         application.applicationIconBadgeNumber = 0;
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "actionCategory" {
            if response.actionIdentifier == "thankyou" {
              /*  let fluid = "4"
                let note = DateFormatter()
                note.dateFormat = "dd/MM/yyyy"
                let inputDate = NSDate()
                let date = note.string(from: inputDate as Date)
                let unit = 0
                userLog = UserLog(fluid: fluid, date: date, inputDate: inputDate as Date, unit: unit)*/
                if let savedUserLogs = loadUserLogs() {
                    userLogs = savedUserLogs
                }
                
                unwindToUserLoglList()
                print("thank you identifier - swiped to unlock or dimiss")
                // Invalidate the old timer and create a new one. . .
            }
            else if response.actionIdentifier == "dismiss" {
                // Invalidate the timer. . .
            }

    }
        completionHandler()
}
    private func unwindToUserLoglList() {
        
        let fluid = defaults.object(forKey: "glassVolumeData") as! String
        print(fluid)
        let note = DateFormatter()
        note.dateFormat = "dd/MM/yyyy"
        let inputDate = NSDate()
        let date = NSDate()
        let unit = defaults.integer(forKey: "selectedUnit")
        userLog = UserLog(fluid: fluid, date: date as Date, inputDate: inputDate as Date, unit: unit)
        //_ = IndexPath(row: userLogs.count, section: 0)
        userLogs.append(userLog!)
        saveUserLogs()
        print("Data saved")
        }
    

    private func saveUserLogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userLogs, toFile: UserLog.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("UserLogs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save userLogs...", log: OSLog.default, type: .error)
        }
    }

    private func loadUserLogs() -> [UserLog]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserLog.ArchiveURL.path) as? [UserLog]
    }
    }
