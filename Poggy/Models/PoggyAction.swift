//
//  PoggyAction.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation

class PoggyAction: NSObject, NSCoding {
    dynamic var actionDescription:String?
    dynamic var message:String?
    dynamic var recipientNumber:String?
    dynamic var recipientName:String?
    dynamic var recipientImage:NSData?
    var isActive:Bool? //if it's the one selected to be triggered
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        
        self.actionDescription = decoder.decodeObjectForKey("actionDescription") as? String
        self.message = decoder.decodeObjectForKey("message") as? String
        self.recipientNumber = decoder.decodeObjectForKey("recipientNumber") as? String
        self.recipientName = decoder.decodeObjectForKey("recipientName") as? String
        self.recipientImage = decoder.decodeObjectForKey("recipientImage") as? NSData
        self.isActive = decoder.decodeObjectForKey("isActive") as? Bool
    }
    
    convenience init(description: String, message: String, recipientNumber: String, recipientName: String, isActive:Bool ) {
        self.init()
        
        self.actionDescription = description
        self.message = message
        self.recipientNumber = recipientNumber
        self.recipientName = recipientName
        self.isActive = isActive
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let name = actionDescription { coder.encodeObject(name, forKey: "actionDescription") }
        if let message = message { coder.encodeObject(message, forKey: "message") }
        if let recipientNumber = recipientNumber { coder.encodeObject(recipientNumber, forKey: "recipientNumber") }
        if let recipientName = recipientName { coder.encodeObject(recipientName, forKey: "recipientName") }
        if let recipientImage = recipientImage { coder.encodeObject(recipientImage, forKey: "recipientImage") }
        if let isActive = isActive { coder.encodeObject(isActive, forKey: "isActive") }
    }
}