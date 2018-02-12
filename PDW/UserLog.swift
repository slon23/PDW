//
//  UserLog.swift
//  PDW
//
//  Created by Sanjin on 06/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit

class UserLog: NSObject, NSCoding {
    

    //MARK: Properties
    var fluid: String
    var date: Date
    var inputDate: Date
    var unit: Int
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userLogs")
    
    //MARK: Types
    
    struct PropertyKey {
        static let fluid = "fluid"
        static let date = "date"
        static let inputDate = "inputDate"
        static let unit = "unit"
    }
    
    //MARK: Initialization
    
    init?(fluid: String, date: Date, inputDate: Date, unit: Int) {
        
        // Initialize stored properties.
        self.fluid = fluid
        self.date = date
        self.inputDate = inputDate
        self.unit = unit
        super.init()
        
        if fluid.isEmpty || unit < 0 {
            return nil
        }

    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fluid, forKey: PropertyKey.fluid)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(inputDate, forKey: PropertyKey.inputDate)
        aCoder.encode(unit, forKey: PropertyKey.unit)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        let fluid = aDecoder.decodeObject(forKey: PropertyKey.fluid) as! String
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as! Date
        let inputDate = aDecoder.decodeObject(forKey: PropertyKey.inputDate) as! Date
        let unit = aDecoder.decodeInteger(forKey: PropertyKey.unit)
        self.init(fluid: fluid, date: date, inputDate: inputDate, unit: unit)
    }
}
