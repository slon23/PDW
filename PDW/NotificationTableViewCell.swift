//
//  NotificationTableViewCell.swift
//  PDW
//
//  Created by Sanjin on 20/12/2016.
//  Copyright © 2016 Sanjin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


protocol cellModelChanged: class {
    func cellModelSwitchTapped(cell: NotificationTableViewCell, newValue: Bool)
}

class NotificationTableViewCell: UITableViewCell, UNUserNotificationCenterDelegate {
    

    
    

    
    //MARK: Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //let defaults = UserDefaults.standard
    
    
    weak var delegate: cellModelChanged?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

       //UNUserNotificationCenter.current().delegate = self

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        //notificationSwitch.setOn(false, animated: false)

    }
 

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.cellModelSwitchTapped(cell: self, newValue: notificationSwitch.isOn)
        if sender.isOn{sendNotification2()
            print("ON")
             }
        else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timeLabel.text!])
            print("Notification at \(String(describing: timeLabel.text)) canceled")
            print("OFF")
    }
    }
    

    // MARK: - Configuration
    
    

    func checkNotificationExists() -> Bool {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print(request)
                if (request.identifier == self.timeLabel.text!){
                    self.notificationSwitch.setOn(true, animated: false)
                }
                
            }
            NSLog("A switch didn't change nothing")
            
            
            
        }
        return false
    }

    

        // Notification schedule
        func sendNotification2() {
            let content = UNMutableNotificationContent()
            content.title = "Water reminder"
            content.subtitle = ""
            content.body = "Please drink glass of water"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            
            let repeatAction = UNNotificationAction(identifier:"thank you",
                                                    title:"Thank you, your body is grateful!",options:[])
            let dismissAction = UNNotificationAction(identifier:
                "dismiss", title: "Dismiss", options: [.destructive])
            
            let category = UNNotificationCategory(identifier: "actionCategory",
                                                  actions: [repeatAction, dismissAction],
                                                  intentIdentifiers: [], options: [])
            
            content.categoryIdentifier = "actionCategory"
            
            UNUserNotificationCenter.current().setNotificationCategories(
                [category])
            
            let time = timeLabel.text
            
            let components = time?.characters.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }
            
            let hour = components?[0]
            let minute = components?[1]
            
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
            let request = UNNotificationRequest(identifier: requestIdentifier!,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    
                                                    if (error != nil) {print("error")}
                                                    else {print("Notification scheduled")}
                                                    // Handle error
            })
            
        }
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            switch response.actionIdentifier {
            case "thank you":
                
                break
                
            default:
                break
            }
            completionHandler()
        }
    /*func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }*/
   
}
