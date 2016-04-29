//
//  ActionsHelper.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation

//not worth using a DB for now, actions are saved as object in userdefaults.
class ActionsHelper {
    
    static let instance = ActionsHelper() // singleton
    private init() { } // This prevents others from using the default '()' initializer for this class.

    func getActions() -> [PoggyAction]? {
        if let actionData = NSUserDefaults.standardUserDefaults().dataForKey(PoggyConstants.ACTIONS_STORE_KEY) {
            NSKeyedUnarchiver.setClass(PoggyAction.self, forClassName: PoggyConstants.DATA_SERIALIZATION_ID)
            return NSKeyedUnarchiver.unarchiveObjectWithData(actionData) as? [PoggyAction]
        }
        return nil
    }
    
    func setActions(actions:[PoggyAction]) {
        NSKeyedArchiver.setClassName(PoggyConstants.DATA_SERIALIZATION_ID, forClass: PoggyAction.self)
        let actionData = NSKeyedArchiver.archivedDataWithRootObject(actions)
        NSUserDefaults.standardUserDefaults().setValue(actionData, forKey: PoggyConstants.ACTIONS_STORE_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getActiveAction() -> PoggyAction? {
        if let actions = getActions() {
            return actions.filter{ $0.isActive!}.first
        }
        return nil
    }
}