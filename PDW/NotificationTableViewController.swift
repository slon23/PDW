//
//  NotificationTableViewController.swift
//  PDW
//
//  Created by Sanjin on 27/12/2016.
//  Copyright © 2016 Sanjin. All rights reserved.
//

import UIKit
import os.log
import UserNotifications


class NotificationTableViewController: UITableViewController, UNUserNotificationCenterDelegate, cellModelChanged {

    var notifications = [Notification]()
    
    
    //MARK: Properties
    
     

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
      
        //UNUserNotificationCenter.current().delegate = self
        //tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cellIdentifier")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        if let savedNotifications = loadNotifications() {
            notifications += savedNotifications
        }
        
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
         orderTable()
    }
    
    func orderTable() {
        notifications.sort(by: {$0.time < $1.time})
        tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source




    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NotificationTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NotificationTableViewCell

        let notification = notifications[indexPath.row]
        
        cell.timeLabel.text = notification.time
        
        cell.notificationSwitch.tag = indexPath.row
        
        //cell.notificationSwitch.isOn = notification.switchOn!
        
        cell.delegate = self
        
        cell.notificationSwitch.setOn(notification.switchOn, animated: false)
        
        
        

        return cell
        
        
    
    }
    

   
    func cellModelSwitchTapped(cell: NotificationTableViewCell, newValue: Bool) {
        let notification = notifications[(tableView.indexPath(for: cell)?.row)!]
        notification.switchOn = newValue
        saveNotifications()
    }

    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
            let notification = notifications[indexPath.row]
            cell.timeLabel.text = notification.time
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [cell.timeLabel.text!])
            print("Notification canceled")
            // Delete the row from the data source
            notifications.remove(at: indexPath.row)
            saveNotifications()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
      // super.prepare(for: segue, sender: sender)

        
       /* switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new notification.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let notificationDetailViewController = segue.destination as? NotificationViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedNotificationCell = sender as? NotificationTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedNotificationCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedNotification = notifications[indexPath.row]
            notificationDetailViewController.notification = selectedNotification
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")

        }
            
          */
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   // }
 

 

    

    @IBAction func unwindToNotificationList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NotificationViewController, let notification = sourceViewController.notification {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing notification.
                notifications[selectedIndexPath.row] = notification
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new notif. item.
                let newIndexPath = NSIndexPath(row: notifications.count, section: 0)
                notifications.append(notification)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            }
            
            // Save the notifications.
            saveNotifications()
        }
    }
    private func saveNotifications() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(notifications, toFile: Notification.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Notifications successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save notifications...", log: OSLog.default, type: .error)
        }
    }
    private func loadNotifications() -> [Notification]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Notification.ArchiveURL.path) as? [Notification]
    }

    }
