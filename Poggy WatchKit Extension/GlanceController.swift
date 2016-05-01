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
            let text = action.recipientName == nil ? action.recipientNumber! : action.recipientName
            contactNameLabel.setText(text)
            descriptionLabel.setText(action.actionDescription)
            
            if let imageData = action.recipientImage {
                contactAvatarImage.setImage(UIImage(data: imageData))
            } else {
                contactAvatarImage.setImage(UIImage(named:"UserWatch"))
            }
        } else {
            contactNameLabel.setText(NSLocalizedString("Not Set", comment: ""))
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
}
