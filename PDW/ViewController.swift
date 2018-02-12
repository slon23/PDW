//
//  ViewController.swift
//  PDW
//
//  Created by Sanjin on 24/11/2016.
//  Copyright © 2016 Sanjin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import os.log
import GoogleMobileAds
import Charts

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UNUserNotificationCenterDelegate, ChartViewDelegate {
    @IBOutlet weak var glasscalc: UILabel!
    @IBOutlet weak var advicelabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var glassLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var userLogs = [UserLog]()
    var dataController: DataViewController?
    var evens = [Double]()
    let switchKeyConstant = "switchKeyName"

    var isGrantedNotificationAccess:Bool = false
    
    let defaults = UserDefaults.standard
    
    var fluidData: String = ""
    
    var glassesData: String = ""
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if !granted {
                    self.displayNotificationsDisabled()
                    //self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                for request in requests {
                    print(request)
                }
            }
            
           if let savedUserLogs = loadUserLogs() {
                userLogs += savedUserLogs
            }
            
            pieChartView.delegate = self
            pieChartView.drawHoleEnabled = false
            pieChartView.chartDescription?.text = "% completed"

            
            // Quote change
            let quoteArray = ["Water rules !!!", "Thousands have lived without love, not one without water! ~ W.H. Auden", "Water is the driving force of all nature. ~Leonardo Da Vinci", "When you feel thirsty, you are already dehydrated.", "Drinking water is essential to a healthy lifestyle. ~ Stepen Curry", "Drinking water is like washing out your insides. The water will cleanse the system, fill you up, decrease your caloric load and improve the function of all your tissues. ~ Kevin R. Stone", "I believe that water is the only drink for a wise man. ~ Henry David Thoreau", "If there is magic on this planet, it is contained in water. ~ Loran Eisley", "A Drop Saved Today Keeps Disaster Away.", "Dont Waste It, Just Taste It!", "When the well's dry, we know the worth of water. ~ Benjamin Franklin", "Water is the lifeblood of our bodies, our economy, our nation and our well-being. ~ Stephen Johnson"]
            self.advicelabel.text = quoteArray[Int(arc4random_uniform(UInt32(quoteArray.count)))]
            
            
      //      hourswitch.setOn(checkNotificationExists(), animated: true)
            
            bannerView.adUnitID = "ca-app-pub-2895958730740159/6229103220"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
            for _ in userLogs {
                let currentDate = NSDate()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yy"
                        let doubleArray = userLogs
                        .filter { return Calendar.current.isDate($0.date, inSameDayAs: currentDate as Date) }
                        .flatMap { $0.fluid }                           // Map to an array of non nil times
                        .flatMap { Double($0) }                           // Convert strings to ints
                        .reduce(0) { $0 + $1 }
                    evens = [doubleArray]
                
                }
                let daily = 1.86
                let doubleEvens = evens.reduce(0, +)
                print(doubleEvens)
                let difference = (daily - doubleEvens)
            print(difference)
                evens.append(difference)
             print(evens)
            
            let months = ["Today", "tomorrow"]
            

            
            setChart(dataPoints: months, values: evens)
            
            
    //MARK: Delegates
           //UNUserNotificationCenter.current().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fluidData.isEmpty == true {
            return loadDefaults()

        }
        else {
        glasscalc.text = "\(fluidData)"
        glassLabel.text = "\(glassesData)"
        self.defaults.set(self.glasscalc.text, forKey: "loadSavedData")
        self.defaults.set(self.glassLabel.text, forKey: "loadSavedGlass")
        }
    }
    
    func displayNotificationsDisabled() {
        let alertController = UIAlertController(
            title: "Notifications disabled for PlsDrinkWater App",
            message: "In order to use this application, turn on notification permissions and reload application. Please enable Notifications in Settings -> Notifications -> PlsDrinkWater",
            preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(
            title: "Okay",
            style: UIAlertActionStyle.default,
            handler: nil))
        
        present(alertController, animated: false, completion: nil)
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? UserLogViewController, let userLog = sourceViewController.userLog {
            
            userLogs.append(userLog)
            saveUserLogs()
            
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "% completed")
        let pieChartData = PieChartData(dataSets: [pieChartDataSet])
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = [UIColor.white, UIColor(red: 0/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1)]
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.usePercentValuesEnabled = true
        pieChartView.highlightPerTapEnabled = false
        pieChartDataSet.valueColors = [UIColor(red: 0/255.0, green: 64/255.0, blue: 128/255.0, alpha: 1)]
        pieChartDataSet.valueFont = UIFont(name: "Avenir Heavy", size: (12.0))!
        pieChartView.legend.enabled = false
        //pieChartView.sizeToFit()
        
    }
    


   /* func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }*/
    
   /* func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollview.setContentOffset(CGPoint(x:0, y:250), animated: true)}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollview.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }*/


   // public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
  //  return 1
  //  }
    
   // public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
   // return time.count
   // }
    
  //  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
  //      return time[row]
  //  }
    
    
   /* @IBAction func Hour(_ sender: UISwitch) {
        if sender.isOn {sendNotification()
            }
        else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Notification canceled")
        
    }
        }*/
    
    // Notification schedule
  /*  func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Water reminder"
        content.subtitle = ""
        content.body = "Please drink glass of water"
        content.badge = 1
        
        let repeatAction = UNNotificationAction(identifier:"repeat",
                                                title:"Repeat",options:[])
        let dismissAction = UNNotificationAction(identifier:
            "dismiss", title: "Dismiss", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "actionCategory",
                                              actions: [repeatAction, dismissAction],
                                              intentIdentifiers: [], options: [])
        
        content.categoryIdentifier = "actionCategory"
        
        UNUserNotificationCenter.current().setNotificationCategories(
            [category])
    
        let hour = timePicker.calendar.component(.hour, from: timePicker.date)
        let minute = timePicker.calendar.component(.minute, from: timePicker.date)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

    
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: true)
        
        let requestIdentifier = "Demo Notification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                
                                                if (error != nil) {print("error")}
                                                else {print("Notification scheduled")}
        // Handle error
        })
        
                }*/
   /* func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "repeat":
            self.sendNotification()
        default:
            break
        }
        completionHandler()
    }*/


 /*  func checkNotificationExists() -> Bool {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print(request)
                //if (request.identifier == "Demo Notification"){
                   // self.hourswitch.setOn(request.identifier == "Demo Notification", animated: true)
                   // self.timePickerLabel.text = "ON"}
                
                }
           
    
            
     
}
       return false
    } */
  /*  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }*/
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
    func loadDefaults() {
        let defaults = UserDefaults.standard
        glasscalc.text = defaults.object(forKey: "loadSavedData") as? String
        glassLabel.text = defaults.object(forKey: "loadSavedGlass") as? String
    }
}
