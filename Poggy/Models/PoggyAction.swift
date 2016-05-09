//
//  PoggyAction.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation

class PoggyAction: NSObject, NSCoding {
    var actionType:Int?
    dynamic var actionDescription:String?
    dynamic var message:String?
    var isActive:Bool? //if it's the one selected to be triggered
    var actionIndex:Int? //used for update
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        
        self.actionDescription = decoder.decodeObjectForKey("actionDescription") as? String
        self.message = decoder.decodeObjectForKey("message") as? String
        self.isActive = decoder.decodeObjectForKey("isActive") as? Bool
        self.actionIndex = decoder.decodeObjectForKey("actionIndex") as? Int
        self.actionType = decoder.decodeObjectForKey("actionType") as? Int
    }
    
    convenience init(actionType: Int, description: String, message: String, isActive:Bool, actionIndex:Int ) {
        self.init()
        
        self.actionDescription = description
        self.message = message
        self.isActive = isActive
        self.actionIndex = actionIndex
        self.actionType = actionType
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let actionDescription = actionDescription { coder.encodeObject(actionDescription, forKey: "actionDescription") }
        if let message = message { coder.encodeObject(message, forKey: "message") }
        if let isActive = isActive { coder.encodeObject(isActive, forKey: "isActive") }
        if let actionIndex = actionIndex { coder.encodeObject(actionIndex, forKey: "actionIndex") }
        if let actionType = actionType { coder.encodeObject(actionType, forKey: "actionType") }
    }
}

class SmsAction:PoggyAction {
    dynamic var recipientNumber:String?
    dynamic var recipientName:String?
    dynamic var recipientImage:NSData?
    
    required convenience init(coder decoder: NSCoder) {
        self.init(coder: decoder)
        
        self.recipientNumber = decoder.decodeObjectForKey("recipientNumber") as? String
        self.recipientName = decoder.decodeObjectForKey("recipientName") as? String
        self.recipientImage = decoder.decodeObjectForKey("recipientImage") as? NSData
    }
    
    convenience init(description: String, message: String, recipientNumber: String, recipientName: String, recipientImage: NSData?, isActive:Bool, actionIndex:Int ) {
        self.init(actionType: PoggyConstants.actionType.SMS.rawValue, description: description, message: message, isActive: isActive, actionIndex: actionIndex)

        self.recipientNumber = recipientNumber
        self.recipientName = recipientName
        self.recipientImage = recipientImage
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        super.encodeWithCoder(coder)
        
        if let recipientNumber = recipientNumber { coder.encodeObject(recipientNumber, forKey: "recipientNumber") }
        if let recipientName = recipientName { coder.encodeObject(recipientName, forKey: "recipientName") }
        if let recipientImage = recipientImage { coder.encodeObject(recipientImage, forKey: "recipientImage") }    }
}

class SlackAction:PoggyAction {
    dynamic var slackToken:String?
    dynamic var slackChannel:String?
    dynamic var slackTeam:String?
    
    required convenience init(coder decoder: NSCoder) {
        self.init(coder: decoder)
        
        self.slackToken = decoder.decodeObjectForKey("slackToken") as? String
        self.slackChannel = decoder.decodeObjectForKey("slackChannel") as? String
        self.slackTeam = decoder.decodeObjectForKey("slackTeam") as? String
    }
    
    convenience init(actionType: Int, description: String, message: String, isActive:Bool, actionIndex:Int, slackToken:String, slackChannel:String, slackTeam:String ) {
        self.init(actionType: PoggyConstants.actionType.SLACK.rawValue, description: description, message: message, isActive: isActive, actionIndex: actionIndex)
      
        self.slackToken = slackToken
        self.slackChannel = slackChannel
        self.slackTeam = slackTeam
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        super.encodeWithCoder(coder)
        
        if let slackChannel = slackChannel { coder.encodeObject(slackChannel, forKey: "slackChannel") }
        if let slackToken = slackToken { coder.encodeObject(slackToken, forKey: "slackToken") }
        if let slackTeam = slackTeam { coder.encodeObject(slackTeam, forKey: "slackTeam") }
    }
}