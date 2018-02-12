//
//  Notification.swift
//  PDW
//
//  Created by Sanjin on 28/12/2016.
//  Copyright © 2016 Sanjin. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Notification: NSObject, NSCoding {
    
    //MARK: Properties
    
    var time: String!
    var switchOn: Bool!

    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("notifications")
    
    //MARK: Types
    
    struct PropertyKey {
        static let time = "time"
        static let switchOn = "switchOn"
        

    }
    
    //MARK: Initialization
    
    init?(time: String, switchOn: Bool) {
        // Initialization should fail if there is no name.
    
     
        if time.isEmpty {
            return nil
        }
        // Initialize stored properties.
        self.time = time
        self.switchOn = switchOn

        
    }
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: PropertyKey.time)

        aCoder.encode(switchOn, forKey: PropertyKey.switchOn)

    
        

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? String else {
            os_log("Unable to decode the name for a Notification object.", log: OSLog.default, type: .debug)
            return nil
        }

        let switchOn = aDecoder.decodeObject(forKey: PropertyKey.switchOn) as! Bool
 
        // Must call designated initializer.

        self.init(time: time, switchOn: switchOn)
        
    }
}
