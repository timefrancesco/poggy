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
    
    var currentAction:PoggyAction?
    
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
            currentAction = action
            let text = action.recipientName == nil ? action.recipientNumber! : action.recipientName
            contactNameLabel.setText(text)
            sendButton.setEnabled(true)
        } else {
            contactNameLabel.setText("Not Set")
            sendButton.setEnabled(false)
        }
    }

    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        if let info = userInfo {
            if let fromGlance = info[PoggyConstants.GLANCE_HANDOFF_ID] as? Bool {
                if fromGlance {
                    onSendButtonTouchUpInside()
                }
            }
        }
    }
    
    @IBAction func onSendButtonTouchUpInside() {
        if let action = currentAction {
            let urlSafeBody = action.message!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            let phoneNumber = action.recipientNumber!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
            if let urlSafeBody = urlSafeBody, url = NSURL(string: "sms:/open?addresses=" + phoneNumber + ",&body=\(urlSafeBody)") {
                print("URLSAFEBODY: \(urlSafeBody)")
                print("URL:" + url.absoluteString)
                WKExtension.sharedExtension().openSystemURL(url)
            }
        }
    }
}
