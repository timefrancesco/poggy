//
//  PoggyConstants.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation


class PoggyConstants {
    
    enum actionType {
        case SMS
        case SLACK
    }
    
    static let ACTIONS_STORE_KEY = "PoggyActions"
    static let ACTIONS_DICT_ID = "ActionsArray"
    static let DATA_SERIALIZATION_ID = "PoggyAction"
    static let NEW_DATA_NOTIFICATION = "NewDataRetrieved"
    static let GLANCE_HANDOFF_URL = "io.timelabs.poggy.glance"
    static let GLANCE_HANDOFF_ID = "FromGlance"
}