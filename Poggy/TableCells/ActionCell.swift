//
//  ActionCell.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import UIKit

class ActionCell:UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var currentActionImage: UIImageView!
    
    func updateData(action:PoggyAction) {
        if let description = action.actionDescription {
            descriptionLabel.text = description
        }
        if action.actionType == PoggyConstants.actionType.SMS.rawValue {
            if let smsAction = action as? SmsAction {
                if let recipientName = smsAction.recipientName {
                    recipientLabel.text = recipientName
                } else {
                    recipientLabel.text = smsAction.recipientNumber
                }
            }
        }        
        
        if let active = action.isActive {
            currentActionImage.hidden = !active
        }
    }
    
    override func prepareForReuse() {
        descriptionLabel.text = ""
        recipientLabel.text = ""
        currentActionImage.hidden = true
    }
}