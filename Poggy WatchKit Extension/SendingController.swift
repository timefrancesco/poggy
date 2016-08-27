//
//  SendingController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 24/08/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import WatchKit
import Foundation

class SendingController: WKInterfaceController {
    
    enum sendStatus {
        case SENDING
        case FAIL
        case SUCCESS
    }

    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var loadingAnimationImage: WKInterfaceImage!
    
    var actionToSend:PoggyAction?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let action = context as? PoggyAction {
            actionToSend = action
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let action = actionToSend {
            updateDisplay(.SENDING)
            sendSlackMessage(action)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateDisplay(status: sendStatus) {
        dispatch_async(dispatch_get_main_queue()) {
            switch (status) {
            case .SENDING:
                self.statusLabel.setText("SENDING")
                self.startAnimation()
                WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Start)
            case .FAIL:
                self.statusLabel.setText("FAILED")
                self.statusLabel.setTextColor(UIColor.redColor())
                self.loadingAnimationImage.setTintColor(UIColor.redColor())
                self.stopAnimation()
                WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Failure)
            case .SUCCESS:
                self.statusLabel.setText("SENT")
                self.stopAnimation()
                self.dismissSelf()
                WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Success)
            }
        }
    }
    
    func startAnimation() {
        let duration = 1.0
        loadingAnimationImage.setImageNamed("Activity")
        loadingAnimationImage.startAnimatingWithImagesInRange(NSRange(location: 0, length: 15), duration: duration, repeatCount: 0)
    }
    
    func stopAnimation() {
        loadingAnimationImage.stopAnimating()
    }

    func dismissSelf() {
        popController()
    }
    
    func sendSlackMessage(slackAction: PoggyAction) {
        if let htmlString = slackAction.message!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            let destination = slackAction.slackChannel != nil ? slackAction.slackChannel!.id : slackAction.slackUser!.id
            
            SlackHelper.instance.postMessage(slackAction.slackToken!, channelName: destination!, message: htmlString) { [weak self] (data) in
                if data?.ok != nil && data!.ok! {
                    self?.updateDisplay(.SUCCESS)
                } else {
                    self?.updateDisplay(.FAIL)
                }
            }
        }
    }
}
