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
            let text = action.recipientName == nil ? action.recipientNumber! : action.recipientName
            contactNameLabel.setText(text)
            sendButton.setEnabled(true)
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
    
    @IBAction func onSendButtonTouchUpInside() {
        if let action = ActionsHelper.instance.getActiveAction() {
            let urlSafeBody = action.message!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            let phoneNumber = action.recipientNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
            if let urlSafeBody = urlSafeBody, url = NSURL(string: "sms:/open?addresses=" + phoneNumber + ",&body=\(urlSafeBody)") {
                WKExtension.sharedExtension().openSystemURL(url)
            }
        }
    }
}
