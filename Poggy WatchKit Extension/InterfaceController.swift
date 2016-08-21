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

    @IBOutlet var contactNameLabel: WKInterfaceLabel!
    @IBOutlet var sendButton: WKInterfaceButton!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    
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
       
    }

    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        if let info = userInfo {
            if let fromGlance = info[PoggyConstants.GLANCE_HANDOFF_ID] as? Bool {
                if fromGlance {
                    updateUserActivity(PoggyConstants.GLANCE_HANDOFF_URL, userInfo: [PoggyConstants.GLANCE_HANDOFF_ID:false], webpageURL: nil)
                    onSendButtonTouchUpInside()
                }
            }
        }
    }
    
    func sendSlackMessage(slackAction: PoggyAction) {
        SlackHelper.instance.postMessage(slackAction.slackToken!, channelName: slackAction.slackChannel!, message: slackAction.message!) { (data) in
            print(data)
        }
    }
    
    @IBAction func onSendButtonTouchUpInside() {
    
    }
}
