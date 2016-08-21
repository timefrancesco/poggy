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
    var actionIndex:Int? //used for update
    
    dynamic var actionDescription:String?
    dynamic var message:String?
    dynamic var slackToken:String?
    dynamic var slackChannel:String?
    dynamic var slackTeam:String?
    
    required init(coder decoder: NSCoder) {
        
        self.actionDescription = decoder.decodeObjectForKey("actionDescription") as? String
        self.message = decoder.decodeObjectForKey("message") as? String
        self.actionIndex = decoder.decodeObjectForKey("actionIndex") as? Int
        self.actionType = decoder.decodeObjectForKey("actionType") as? Int
        self.slackToken = decoder.decodeObjectForKey("slackToken") as? String
        self.slackChannel = decoder.decodeObjectForKey("slackChannel") as? String
        self.slackTeam = decoder.decodeObjectForKey("slackTeam") as? String
    }
    
    init(actionType: Int? = nil, description: String? = nil, message: String? = nil, isActive:Bool? = nil, actionIndex:Int? = nil, slackToken:String? = nil, slackChannel:String? = nil, slackTeam:String? = nil ) {
        self.actionDescription = description
        self.message = message
        self.actionIndex = actionIndex
        self.actionType = actionType
        self.slackToken = slackToken
        self.slackChannel = slackChannel
        self.slackTeam = slackTeam
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let actionDescription = actionDescription { coder.encodeObject(actionDescription, forKey: "actionDescription") }
        if let message = message { coder.encodeObject(message, forKey: "message") }
        if let actionIndex = actionIndex { coder.encodeObject(actionIndex, forKey: "actionIndex") }
        if let actionType = actionType { coder.encodeObject(actionType, forKey: "actionType") }
        if let slackChannel = slackChannel { coder.encodeObject(slackChannel, forKey: "slackChannel") }
        if let slackToken = slackToken { coder.encodeObject(slackToken, forKey: "slackToken") }
        if let slackTeam = slackTeam { coder.encodeObject(slackTeam, forKey: "slackTeam") }
    }
}
