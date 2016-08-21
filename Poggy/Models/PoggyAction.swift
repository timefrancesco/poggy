//
//  PoggyAction.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import ObjectMapper

class PoggyAction: Mappable {
    var actionType:Int?
    var actionIndex:Int? //used for update
    
    dynamic var actionDescription:String?
    dynamic var message:String?
    dynamic var slackToken:String?
    dynamic var slackChannel:String?
    dynamic var slackTeam:String?
    
    
    required convenience init?(_ map: Map) { self.init() }
    
    // MARK: Mappable
    func mapping(map: Map) {
        actionDescription <- map["actionDescription"]
        slackToken <- map["slackToken"]
        slackChannel <- map["slackChannel"]
        slackTeam <- map["slackTeam"]
        message <- map["message"]
        
        actionType <- map["actionType"]
        actionIndex <- map["actionIndex"]
    }
}
