//
//  SumUserLogTableViewController.swift
//  PDW
//
//  Created by Sanjin on 27/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit
import os.log

class SumUserLogTableViewController: UITableViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var userLogs = [UserLog]()
    //var lastGroup = [UserLog]()
   // var days = [[UserLog]]()
    var sectionsInTable = [String]()
    var dates = String()
    var fluidDataFinal = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       //  self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let savedUserLogs = loadUserLogs() {
            userLogs += savedUserLogs
        }
        
       /* let sum = userLogs
            .filter { return $0.date <= lastDate!}
            .flatMap { $0.fluid }                           // Map to an array of non nil times
            .flatMap { Int($0) }                           // Convert strings to ints
            .reduce(0) { $0 + $1 }
        print(sum)*/
       // var lastDate = userLogs.first?.date
       // let calendar = Calendar.current
        
        for dateObject in userLogs {
            let currentDate = dateObject.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: currentDate)
            
            let sections: NSSet = NSSet(array: sectionsInTable)
            
            // if sectionsInTable doesn't contain the dateString, then add it
            if !sections.contains(dateString) {
                sectionsInTable.append(dateString)
            }
        }

        
            /*let unitFlags : Set<Calendar.Component> = [.era, .day, .month, .year, .timeZone]
            let difference = calendar.dateComponents(unitFlags, from: lastDate!, to: currentDate)
            
            if difference.year! < 0 || difference.month! < 0 || difference.day! == 0 {
                lastDate = currentDate
                days.append(lastGroup)
                lastGroup = [dateObject]
            } else {
                lastGroup.append(dateObject)
            }
        }
        days.append(lastGroup)*/

        self.tableView.reloadData()
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     orderTable()
     }
    
    func orderTable() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        sectionsInTable.sort {
            let date1 = formatter.date(from: $0)
            let date2 = formatter.date(from: $1)
            return date1!.timeIntervalSince1970 > date2!.timeIntervalSince1970
        
        }
       // sectionsInTable.sort(by: {$0 < $1})
       // userLogs.sort(by: {$0.date < $1.date})
        tableView.reloadData()
    }
    
    /*func getSectionItems(section: Int) -> [UserLog] {
        var sectionItems = [UserLog]()
        
        // loop through the testArray to get the items for this sections's date
        for item in userLogs {
            let dateTextItem = item as UserLog
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let dateString = df.string(from: dateTextItem.date)
            
            // if the item's date equals the section's date then add it
            if dateString == (sectionsInTable[section] as NSString) as String {
                sectionItems.append(dateTextItem)
            }
        }
        
        return sectionItems
    }*/


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if sectionsInTable.isEmpty
        {
            
            return 0
        }
        return sectionsInTable.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SumUserLogTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SumUserLogTableViewCell  else {
            fatalError("The dequeued cell is not an instance of UserLogTableViewCell.")
        }
        dates = sectionsInTable[indexPath.section]
        
        
        // cell.date.text = userLog.date
        let setDate = dates
        cell.dateSum.text = setDate
        for item in userLogs {
            let dateTextItem = item as UserLog
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let dateString = df.string(from: dateTextItem.date)
            if dateString == setDate {
            // if the item's date equals the section's date then add it
            let doubleArray = userLogs
                .filter { return Calendar.current.isDate($0.date, inSameDayAs: dateTextItem.date) }
                .flatMap { $0.fluid }                           // Map to an array of non nil times
                .flatMap { Double($0) }                           // Convert strings to ints
                .reduce(0) { $0 + $1 }
                let fluids : String = String(doubleArray)
                fluidDataFinal = fluids
            }
            if dateTextItem.unit == 0 {
                cell.fluidUnitLabel.text = "L"
            }
            else {
                cell.fluidUnitLabel.text = "Oz"
            }
        }
        
        cell.fluidSum.text = fluidDataFinal
        


        
        // Configure the cell...
        
        return cell
        
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsInTable[section]
    }*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        performSegue(withIdentifier: "collectionSegue", sender: self)
    }

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
   /* override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userLogs.remove(at: indexPath.section)
            sectionsInTable.remove(at: indexPath.section)
            tableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section - 1)
            tableView.deleteSections(indexSet as IndexSet, with: UITableViewRowAnimation.automatic)
            saveUserLogs()
            tableView.endUpdates()
            // Delete the row from the data source
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/
    

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

   //  In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = self.tableView.indexPathForSelectedRow
        let indexNumber = index?.section //0,1,2,3
        //let vc = segue.destination as! UserLogTableViewController
        let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! UserLogTableViewController
        targetController.title = sectionsInTable[indexNumber!]
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
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

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b as Date) == ComparisonResult.orderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b as Date) == ComparisonResult.orderedSame
}

extension NSDate: Comparable { }
