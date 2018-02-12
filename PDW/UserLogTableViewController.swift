//
//  UserLogTableViewController.swift
//  PDW
//
//  Created by Sanjin on 06/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit
import os.log

class UserLogTableViewController: UITableViewController {
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    var userLogs = [UserLog]()
    var userLog : UserLog?
    let defaults = UserDefaults.standard
    var dates = String()
    var dateData: [String] = []
    var datas = [String]()
    var sections = Dictionary<String, Array<UserLog>>()
    var sortedSections = [String]()
    var sectionNumber: Int = 0
    var sectionsInTable = [String]()
    var sectionTitles = [String]()
    var convDate: [Date] = []
    var unitLabel: Int = 0
    var path: Int = 0
    var found: Int?
    var arrayCount: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem


        
        if let savedUserLogs = loadUserLogs() {
            userLogs += savedUserLogs
            
            }
       
        for dateObject in userLogs {
            let identity = navigationItem.title
            let currentDate = dateObject.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: currentDate)
            if identity == dateString {
                sectionsInTable.append(dateString)
            }
        }
        

    }
    

   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderTable()
    }
    
  func orderTable() {
        userLogs.sort(by: {$0.date > $1.date})
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
        return sectionsInTable.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserLogTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserLogTableViewCell  else {
            fatalError("The dequeued cell is not an instance of UserLogTableViewCell.")
        }
        
        let identity = navigationItem.title
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Set the way the date should be displayed
        let setDate = identity
        cell.date.text = setDate
        for item in userLogs {
            let identity = navigationItem.title
            let currentDate = item.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: currentDate)
            if identity == dateString {
                let doubleArray = userLogs
                    .filter { return Calendar.current.isDate($0.date, inSameDayAs: item.date) }
                // if the item's date equals the section's date then add it
                let userLog = doubleArray[indexPath.row]
                arrayCount = doubleArray.count
                cell.inputDate.text = formatter.string(from: userLog.inputDate)
                cell.fluid.text = userLog.fluid
            if userLog.unit == 0 {
                cell.unit.text = "L"
            }
            else {
                cell.unit.text = "Oz"
            }
            }
            
        }
        
          // <= will hold the index if it was found, or else will be nil
        for i in 0..<userLogs.count {
            let identity = navigationItem.title
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let dateString = df.string(from: userLogs[i].date)
            
            if identity == dateString {
                found = i
            }
        }

        //let tableSection = sections[sortedSections[indexPath.section]]
       /* let userLog = userLogs[indexPath.row]
        //let userLog = userLogs[indexPath.row]
        
        cell.fluid.text = userLog.fluid
       // cell.date.text = userLog.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Set the way the date should be displayed
        let inputDate = userLog.inputDate
        cell.inputDate.text = formatter.string(from: inputDate as Date)
        let setDate = userLog.date
        cell.date.text = formatter.string(from: setDate as Date)
        if userLog.unit == 0 {
            cell.unit.text = "L"
        }
        else {
            cell.unit.text = "Oz"
        }
        */
        
        // Configure the cell...

        return cell
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section]
    }*/
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                path = (found! - arrayCount!) + (indexPath.row + 1)
                


                userLogs.remove(at: path)

                sectionsInTable.remove(at: indexPath.row)
                saveUserLogs()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)

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
     
     /*@IBAction func unwindToUserLoglList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? UserLogViewController, let userLog = sourceViewController.userLog {
           /* for item in userLogs {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy" // Set the way the date should be displayed
                let date = formatter.string(from: item.date)
                if self.sections.index(forKey: date) == nil {
                    self.sections[date] = [UserLog(fluid: item.fluid, date: item.date, inputDate: item.inputDate, unit: item.unit)!]
                }
                else {
                    self.sections[date]!.append(UserLog(fluid: item.fluid, date: item.date, inputDate: item.inputDate, unit: item.unit)!)
                }
            }*/
            //let sec = sections.count
            let newIndexPath = IndexPath(row: sectionsInTable.count, section: 0)
            userLogs.append(userLog)
            saveUserLogs()
            //self.tableView.reloadData()
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        }
     }*/
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SumUserLogTableViewController") as! SumUserLogTableViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
extension UITableView {
    func indexPathsForRowsInSection(_ section: Int) -> [NSIndexPath] {
        return (0..<self.numberOfRows(inSection: section)).map { NSIndexPath(row: $0, section: section) }
    }
}
