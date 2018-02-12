//
//  ChartViewController.swift
//  PDW
//
//  Created by Sanjin on 07/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit
import Charts
import os.log

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: BarChartView!
    
    let defaults = UserDefaults.standard
    dynamic var count: Int = Int(0)
    weak var axisFormatDelegate: IAxisValueFormatter?
    var userLogs = [UserLog]()
    var date = Date()
    var fluid: String = ""
    var fluidData: [String] = []
    var fluidDatas: [String]!
    var dateData: [String] = []
    var convDate: [Date] = []
    var datas: [String]!
    var newDate: String = ""
    var convertedArray: [Date] = []
    var fluidUnit: Int = 0
    var sectionsInTable = [String]()
    var fluidDataFinal = String()
    var evens = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaults()
        axisFormatDelegate = self
        if fluidUnit == 0 {
            chartView.chartDescription?.text = "Liters"
        }
        else {
            chartView.chartDescription?.text = "Ounces(US)"
        }
        
        
        if let savedMeals = loadMeals() {
            userLogs += savedMeals
            userLogs.sort(by: {$0.date < $1.date})
        }
        
        if userLogs.isEmpty { chartView.noDataText = "You need to provide data for the chart."
        }
            
        else {
            
           // let dataArray = NSKeyedUnarchiver.unarchiveObject(withFile: UserLog.ArchiveURL.path) as! [UserLog]
            
          //  let data = NSKeyedArchiver.archivedData(withRootObject: dataArray)
           // let data1 = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSArray
          //  let data2 = data1.sorted(by: {($0 as AnyObject).date < ($1 as AnyObject).date})
            
            /*func getData() {
                for e in 0..<data2.count {
                    let date = (data2[e] as AnyObject).date
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM" // Set the way the date should be displayed
                    let newDate = formatter.string(from: date!)
                    dateData.append(newDate)
                    datas = dateData
                    let fluid = (data2[e] as AnyObject).fluid
                    fluidData.append(fluid!)
                    fluidDatas = fluidData
                }
            }*/
            //getData()
            chartView.delegate = self;
            chartView.drawValueAboveBarEnabled = true
            //chartView.maxVisibleCount = 7
            //  chartView.xAxis.labelCount = 7
            // chartView.xAxis.axisMaximum = 8
            
            /* chartView.drawBarShadowEnabled = false
             chartView.pinchZoomEnabled = false
             chartView.drawGridBackgroundEnabled = true
             chartView.drawBordersEnabled = false */

            for dateObject in userLogs {
                let currentDate = dateObject.date
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yy"
                let dateString = formatter.string(from: currentDate)
                let sections: NSSet = NSSet(array: sectionsInTable)
                // if sectionsInTable doesn't contain the dateString, then add it
                if !sections.contains(dateString) {
                    sectionsInTable.append(dateString)
                   /* sectionsInTable.sort {
                        let date1 = formatter.date(from: $0)
                        let date2 = formatter.date(from: $1)
                        return date1!.timeIntervalSince1970 > date2!.timeIntervalSince1970
                        
                    }*/
                    let doubleArray = userLogs
                        .sorted (by: {$0.date < $1.date})
                        .filter { return Calendar.current.isDate($0.date, inSameDayAs: dateObject.date) }
                        .flatMap { $0.fluid }                           // Map to an array of non nil times
                        .flatMap { Double($0) }                           // Convert strings to ints
                        .reduce(0) { $0 + $1 }
                    evens.append(doubleArray)

                /*    let doubleArray = userLogs
                        .filter { return Calendar.current.isDate($0.date, inSameDayAs: dateObject.date) }
                        .flatMap { $0.fluid }                           // Map to an array of non nil times
                        .flatMap { Double($0) }                           // Convert strings to ints
                        .reduce(0) { $0 + $1 }
                    evens.append(doubleArray) */
                }
            }
          //  let doubleArray = fluidDatas.flatMap{ Double($0) }
          //  setChart(dataPoints: datas, values: doubleArray)
          setChart(dataPoints: sectionsInTable, values: evens)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        chartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Water intake")
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartView.data = chartData
        
        let xaxis = chartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        // chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        xaxis.drawAxisLineEnabled = false
        xaxis.drawGridLinesEnabled = false
        chartView.xAxis.granularityEnabled = true
        xaxis.granularity = 1
        let min = chartView.chartXMax
        chartView.setVisibleXRangeMaximum(7)
        chartView.moveViewToX(min)
        chartDataSet.colors = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        //let c : Double = Double(fluidTarget)!
        //let ll = ChartLimitLine(limit: c, label: "Daily Target")
        //chartView.rightAxis.addLimitLine(ll)
        
        
        
        //  chartView.xAxis.labelCount = 7;
        //  chartView.xAxis.granularityEnabled = true
        //   chartView.xAxis.granularity = 1
        
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
    
    private func loadMeals() -> [UserLog]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserLog.ArchiveURL.path) as? [UserLog]
    }
    private func loadDefaults() {
        let defaults = UserDefaults.standard
        let fluidUnitData = defaults.integer(forKey: "selectedUnit")
        fluidUnit = fluidUnitData
    }
    
    
}

extension ChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sectionsInTable[Int(value)]
    }
    
}
