//
//  Slack.swift
//  Poggy
//
//  Created by Francesco Pretelli on 11/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import ObjectMapper

class SlackAuthResponse {
    dynamic var teamName:String?
    dynamic var token:String?
    
    convenience init(teamName: String, token: String) {
        self.init()
        
        self.teamName = teamName
        self.token = token
    }
}

class SlackTeamResponse: Mappable {
    
    dynamic var ok: Bool = false
    var teamInfo: SlackTeam?
    
    required convenience init?(_ map: Map) { self.init() }
    
    // MARK: Mappable
    func mapping(map: Map) {
        ok <- map["ok"]
        teamInfo <- map["team"]
    }
}

class SlackTeam: Mappable {
    
    dynamic var id: String?
    dynamic var name: String?
    dynamic var domain: String?
    dynamic var icon: String?
    var image_default: Bool?
    
    required convenience init?(_ map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        domain <- map["domain"]
        icon <- map["icon.image_132"]
        image_default <- map["icon.image_default"]
    }
}


class SlackChannelsResponse: Mappable {
    
    dynamic var ok: Bool = false
    var channels: [SlackChannel]?
    
    required convenience init?(_ map: Map) { self.init() }
    
    // MARK: Mappable
    func mapping(map: Map) {
        ok <- map["ok"]
        channels <- map["channels"]
    }
}

class SlackChannel: Mappable {
    
    var is_channel: Bool?
    dynamic var purpose: String?
    dynamic var id: String?
    dynamic var members: [String]?
    dynamic var creator: String?
    var is_general: Bool?
    var is_archived: Bool?
    dynamic var topic: String?
    var num_members: Int?
    var is_member: Bool?
    var created: Int?
    dynamic var name: String?
    dynamic var teamIcon: String? //not part of Slack Apis
    
    required convenience init?(_ map: Map) { self.init() }
    
    // MARK: Mappable
    func mapping(map: Map) {
        is_channel <- map["is_channel"]
        purpose <- map["purpose.value"]
        id <- map["id"]
        members <- map["members"]
        creator <- map["creator"]
        is_general <- map["is_general"]
        is_archived <- map["is_archived"]
        topic <- map["topic.value"]
        num_members <- map["num_members"]
        is_member <- map["is_member"]
        created <- map["created"]
        name <- map["name"]
        teamIcon <- map["teamIcon"] //not part of Slack Apis   
    }
}

class SlackUser: Mappable {
    
    dynamic var id: String?
    dynamic var username: String?
    var deleted: Bool?
    dynamic var profileImage:String?
    
    required convenience init?(_ map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["name"]
        profileImage <- map["profile.image_192"]
        deleted <- map["deleted"]
    }
}

class SlackMessageResponse: Mappable {
 
    var ok: Bool?
    dynamic var channel: String?
    dynamic var messageText: String?
    dynamic var messageUserName: String?
    dynamic var messageType: String?
    dynamic var messageSubType: String?
 
    required convenience init?(_ map: Map) { self.init() }
    
    func mapping(map: Map) {
        ok <- map["ok"]
        channel <- map["channel"]
        messageText <- map["message.text"]
        messageUserName <- map["message.username"]
        messageType <- map["message.type"]
        messageSubType <- map["message.subtype"]
    }
}
