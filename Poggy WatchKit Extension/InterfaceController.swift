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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
        
        updateActions()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.updateActions), name: PoggyConstants.NEW_DATA_NOTIFICATION, object: nil)
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
        let action = actions[rowIndex]
        sendSlackMessage(action)
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
