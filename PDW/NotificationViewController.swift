//
//  NotificationViewController.swift
//  PDW
//
//  Created by Sanjin on 15/12/2016.
//  Copyright © 2016 Sanjin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import os.log


class NotificationViewController: UIViewController, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var timePicker: UIDatePicker!

    let defaults = UserDefaults.standard
    var notification: Notification?
    var fluidData: String = ""
    var userLog: UserLog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // UNUserNotificationCenter.current().delegate = self
      //  loadDefaults()
        
        /*UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
            
            if granted {print("Notification access granted")
            }else{print(error?.localizedDescription as Any)
            }
        })*/
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
     @IBAction func cancel(_ sender: UIBarButtonItem) {
            self.dismiss(animated: true, completion: nil)
            
        
    }
        
    

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
            let note = DateFormatter()
            
            note.dateFormat = "HH:mm"
            
            let time = note.string(from: timePicker.date)
        
            let switchOn = true

            sendNotification1()
        
           
        
        
                        // Set the notification to be passed to NotificationTableViewController after the unwind segue.

        notification = Notification(time: time, switchOn: switchOn)
        

        }
    
    

    // MARK: Action
    
    func sendNotification1() {
        let content = UNMutableNotificationContent()
        content.title = "Water reminder"
        content.subtitle = ""
        content.body = "Please drink glass of water"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let thankyouAction = UNNotificationAction(identifier: "thankyou", title: "Thank you, your body is grateful!", options: [])
        let dismissAction = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "actionCategory",
                                              actions: [thankyouAction, dismissAction],
                                              intentIdentifiers: [], options: [])
        
        content.categoryIdentifier = "actionCategory"
        
        UNUserNotificationCenter.current().setNotificationCategories(
            [category])
        
        let note = DateFormatter()
        
        note.dateFormat = "HH:mm"
        
        let time = note.string(from: timePicker.date)
        
        let components = time.characters.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }
        
        let hour = components[0]
        let minute = components[1]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        
        if let path = Bundle.main.path(forResource: "Glas_water", ofType: "jpg") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "Glas_water", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        let requestIdentifier = time
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                
                                                if (error != nil) {print("error")}
                                                else {print("Notification scheduled")}
                                                // Handle error
        })
        
    }
   /* func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
       if response.notification.request.content.categoryIdentifier == "actionCategory" {
        if response.actionIdentifier == "thankyou" {
            let fluid = ""
            let note = DateFormatter()
            note.dateFormat = "dd/MM/yyyy"
            let inputDate = NSDate()
            let date = note.string(from: inputDate as Date)
            let unit = 0
            userLog = UserLog(fluid: fluid, date: date, inputDate: inputDate as Date, unit: unit)
            print("Default identifier - swiped to unlock or dimiss")
            // Invalidate the old timer and create a new one. . .
        }
        else if response.actionIdentifier == "dismiss" {
            // Invalidate the timer. . .
        }
        }
        
       /* switch response.actionIdentifier {
        case "thank you":
            saveData()
        print("Default identifier - swiped to unlock or dimiss")
        case "dismiss":
        break
        default:
        break
        }
        completionHandler()*/
    }*/
    
    /*private func saveTime(){
        let date = NSDate()
        let calender = NSCalendar.current
        let components = calender.component(.hour, from: date as Date)
        let hour = components
        self.defaults.set(hour, forKey: "defaultHour")
        print(hour)
        //   let weightSave : Double = Double(weightData)!
        // healthManager.saveWeight(weightRecorded: weightSave, date: NSDate())
        // Do any additional setup after loading the view, typically from a nib.
    }*/


   /* func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }*/
    
    /*func loadDefaults() {
       let fluidData = defaults.object(forKey: "glassVolume") as? String
        
    }*/
}
