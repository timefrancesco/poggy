//
//  PoggyConstants.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import UIKit

class PoggyConstants {
    
    enum actionType:Int {
        case SMS = 0
        case SLACK = 1
    }
    
    static let ACTIONS_STORE_KEY = "PoggyActions"
    static let ACTIONS_DICT_ID = "ActionsArray"
    static let DATA_SERIALIZATION_ID = "PoggyAction"
    static let NEW_DATA_NOTIFICATION = "NewDataRetrieved"
    static let GLANCE_HANDOFF_URL = "io.timelabs.poggy.glance"
    static let GLANCE_HANDOFF_ID = "FromGlance"
    static let SLACK_TEAMS_STORE_KEY = "SlackTeams"
    static let SLACK_CONSUMER_KEY = "SlackConsumerKey"
    static let SLACK_CONSUMER_SECRET = "SlackConsumerSecret"
    static let NEW_ACTION_CREATED = "NewPoggyAction"
    
    static let POGGY_BLUE = UIColor(rgb: 0x009EF4)
    static let POGGY_BLACK = UIColor(rgb: 0x1E1E1E)
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
