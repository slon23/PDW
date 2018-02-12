//
//  HealthManager.swift
//  PDW
//
//  Created by Sanjin on 21/01/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//
/*
import Foundation
import UIKit
import os.log
//import HealthKit

class HealthManager {

    /*let healthKitStore: HKHealthStore = HKHealthStore()

    func authorizeHealthKit(completion: ((_ success: Bool, _ error: NSError?) -> Void)!) {
        
        // State the health data type(s) we want to read from HealthKit.
        let healthDataToWrite = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!)
        
        // State the health data type(s) we want to write from HealthKit.
       // let healthDataToWrite = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!)
        
        // Just in case OneHourWalker makes its way to an iPad...
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: healthDataToWrite, read: healthDataToWrite) { (success, error) -> Void in
            if( completion != nil ) {
                completion?(success, error as NSError!)
            }
        }
    }
    
    func getWeight(sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        
        // Predicate for the height query
        let distantPastWeight = NSDate.distantPast as NSDate
        let currentDate = NSDate()
        let lastWeightPredicate = HKQuery.predicateForSamples(withStart: distantPastWeight as Date, end: currentDate as Date, options: [])
        
        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Query HealthKit for the last Height entry.
        let weightQuery = HKSampleQuery(sampleType: sampleType, predicate: lastWeightPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                completion?(nil, queryError as NSError?)
                return
            }
            
            // Set the first HKQuantitySample in results as the most recent height.
            let lastWeight = results!.first
            
            if completion != nil {
                completion(lastWeight, nil)
            }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(weightQuery)
    }
    
    func saveWeight(weightRecorded: Double, date: NSDate) {
        
        // Set the quantity type to the running/walking distance.
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        // Set the unit of measurement to miles.
        let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weightRecorded)
        
        // Set the official Quantity Sample.
        let distance = HKQuantitySample(type: weightType!, quantity: weightQuantity, start: date as Date, end: date as Date)
        
        // Save the distance quantity sample to the HealthKit Store.
        healthKitStore.save(distance, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error!)
            } else {
                print("The weight has been recorded! Better go check!")
            }
        })
    }*/
}

*/
