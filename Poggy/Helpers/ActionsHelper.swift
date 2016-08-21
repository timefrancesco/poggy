//
//  ActionsHelper.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import ObjectMapper

//not worth using a DB for now, actions are saved as object in userdefaults.
class ActionsHelper {
    
    static let instance = ActionsHelper() // singleton
    private init() { } // This prevents others from using the default '()' initializer for this class.

    func getActions() -> [PoggyAction]? {
        if let actionData = NSUserDefaults.standardUserDefaults().stringForKey(PoggyConstants.ACTIONS_STORE_KEY) {
            let actions = Mapper<PoggyAction>().mapArray(actionData)
            return actions
        }
        return nil
    }
    
    func setActions(actions:[PoggyAction]) {
        if let actionData = Mapper().toJSONString(actions, prettyPrint: true) {
            setActions(actionData)
        }
    }
    
    func setActions(actions:String) {
        NSUserDefaults.standardUserDefaults().setValue(actions, forKey: PoggyConstants.ACTIONS_STORE_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func addAction(action:PoggyAction, update:Bool) {
        let savedActions = getActions()
        
        if var actions = savedActions { //clear previously active actions, the last added actions is always the active one
            if !update {
                actions.append(action)
            }else if let index = action.actionIndex {
                actions[index] = action
            }
            
            setActions(actions)
        } else {
            var actions = [PoggyAction]()
            actions.append(action)
            setActions(actions)
        }
    }
}
