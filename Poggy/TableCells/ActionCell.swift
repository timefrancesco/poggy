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
        
        if let channel = action.slackChannel {
            recipientLabel.text = channel.name
        } else if let user = action.slackUser {
            recipientLabel.text = user.username
        }
    }
    
    override func prepareForReuse() {
        descriptionLabel.text = ""
        recipientLabel.text = ""
        currentActionImage.hidden = true
    }
}
