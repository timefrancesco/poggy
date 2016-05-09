//
//  GlanceController.swift
//  Poggy WatchKit Extension
//
//  Created by Francesco Pretelli on 24/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var contactNameLabel: WKInterfaceLabel!
    @IBOutlet var contactAvatarImage: WKInterfaceImage!
   
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
        
        updateCurrentAction()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.updateCurrentAction), name: PoggyConstants.NEW_DATA_NOTIFICATION, object: nil)
        
        updateUserActivity(PoggyConstants.GLANCE_HANDOFF_URL, userInfo: [PoggyConstants.GLANCE_HANDOFF_ID:true], webpageURL: nil)
    }
    
    func updateCurrentAction(){
        if let action = ActionsHelper.instance.getActiveAction() {
            
            if action.actionType == PoggyConstants.actionType.SMS.rawValue {
                if let smsAction = action as? SmsAction {
                    let text = smsAction.recipientName == nil ? smsAction.recipientNumber! : smsAction.recipientName
                    contactNameLabel.setText(text)
                    if let imageData = smsAction.recipientImage {
                        contactAvatarImage.setImage(UIImage(data: imageData))
                    } else {
                        contactAvatarImage.setImage(UIImage(named:"UserWatch"))
                    }
                }
            } else if action.actionType == PoggyConstants.actionType.SLACK.rawValue {
                if let slackAction = action as? SlackAction {
                    contactNameLabel.setText(slackAction.slackChannel)
                    contactAvatarImage.setImage(UIImage(named:"UserWatch"))
                }
            }
            descriptionLabel.setText(action.actionDescription)
            
        } else {
            contactNameLabel.setText(NSLocalizedString("Not Set", comment: ""))
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
}
