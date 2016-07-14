//
//  PhoneNumber.swift
//  aaa
//
//  Created by Apple on 16/6/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class PhoneNumber : NSObject, NSCoding{
    var name:String
    var number:String
    
    struct PropertyKey {
        static let nameKey = "name"
        static let numberKey = "number"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("phoneNumbers")
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(number, forKey: PropertyKey.numberKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let number = aDecoder.decodeObjectForKey(PropertyKey.numberKey) as! String
        
        // Must call designated initializer.
        self.init(name: name, number: number)
    }
    
    init?(name:String,number:String){
        self.name=name
        self.number=number
        super.init()
    }
    
    init?(number:String){
        self.name="Unknown"
        self.number=number
        super.init()
    }
}
