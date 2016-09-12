//
//  InterfaceController.swift
//  Poggy WatchKit Extension
//
//  Created by Francesco Pretelli on 24/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var noMsgLabel: WKInterfaceLabel!
    @IBOutlet var actionsTable: WKInterfaceTable!
    var actions = [PoggyAction]()

    override func willActivate() {
        super.willActivate()
        
        updateActions()        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateActions), name: PoggyConstants.NEW_DATA_NOTIFICATION, object: nil)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateActions() {
       reloadTableSource()
    }

    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
    }
    
    func reloadTableSource() {
        if let pActions = ActionsHelper.instance.getActions() {
            actions = pActions
            actionsTable.setNumberOfRows(actions.count, withRowType: "ActionRow")
            
            for index in 0..<actionsTable.numberOfRows {
                if let controller = actionsTable.rowControllerAtIndex(index) as? ActionRowController {
                    controller.action = actions[index]
                }
            }
        }
        
        noMsgLabel.setHidden(actions.count > 0)
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let selectedAction = actions[rowIndex]
        pushControllerWithName("LoadingController", context: selectedAction)
    }
    
    func sendSlackMessage(slackAction: PoggyAction) {
        if let htmlString = slackAction.message!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            let destination = slackAction.slackChannel != nil ? slackAction.slackChannel!.id : slackAction.slackUser!.id
            
            SlackHelper.instance.postMessage(slackAction.slackToken!, channelName: destination!, message: htmlString) { (data) in
                print(data)
            }
        }
    }    
}
