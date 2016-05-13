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
        
        updateCurrentAction()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.updateCurrentAction), name: PoggyConstants.NEW_DATA_NOTIFICATION, object: nil)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateCurrentAction() {
        if let action = ActionsHelper.instance.getActiveAction() {
            
            if action.actionType == PoggyConstants.actionType.SMS.rawValue {
                if let smsAction = action as? SmsAction {
                    let text = smsAction.recipientName == nil ? smsAction.recipientNumber! : smsAction.recipientName
                    contactNameLabel.setText(text)
                    sendButton.setEnabled(true)
                }
            } else if  action.actionType == PoggyConstants.actionType.SLACK.rawValue {
                if let slackAction = action as? SlackAction {
                    contactNameLabel.setText(slackAction.slackChannel)
                    sendButton.setEnabled(true)
                }
            }
            descriptionLabel.setText(action.actionDescription)
            
        } else {
            contactNameLabel.setText(NSLocalizedString("Not Set", comment: ""))
            sendButton.setEnabled(false)
        }
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
    
    func sendSlackMessage(slackAction: SlackAction) {
        SlackHelper.instance.postMessage(slackAction.slackToken!, channelName: slackAction.slackChannel!, message: slackAction.message!) { (data) in
            print(data)
        }
    }
    
    func sendSms(smsAction:SmsAction) {
        let urlSafeBody = smsAction.message!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let phoneNumber = smsAction.recipientNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        if let urlSafeBody = urlSafeBody, url = NSURL(string: "sms:/open?address=" + phoneNumber + ",&body=\(urlSafeBody)") {
            WKExtension.sharedExtension().openSystemURL(url)
        }
    }
    
    @IBAction func onSendButtonTouchUpInside() {
        if let action = ActionsHelper.instance.getActiveAction() {
            if action.actionType == PoggyConstants.actionType.SMS.rawValue {
                if let smsAction = action as? SmsAction {
                    sendSms(smsAction)
                }
            } else if action.actionType == PoggyConstants.actionType.SLACK.rawValue {
                if let slackAction = action as? SlackAction {
                    sendSlackMessage(slackAction)
                }
            }
        }
    }
}
