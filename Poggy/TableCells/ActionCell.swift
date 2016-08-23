//
//  ActionCell.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

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
            if let teamIcon = channel.teamIcon {
                currentActionImage.sd_setImageWithURL(NSURL(string: (teamIcon)),placeholderImage:  UIImage(named:"Slack-Icon"),  options: [SDWebImageOptions.RetryFailed ])
            }
            
        } else if let user = action.slackUser {
            recipientLabel.text = user.username
            if let userIcon = user.profileImage {
                currentActionImage.sd_setImageWithURL(NSURL(string: (userIcon)),placeholderImage:  UIImage(named:"Alien-Icon"),  options: [SDWebImageOptions.RetryFailed ])
            }
        }
        
        if let team = action.slackTeam {
            recipientLabel.text = recipientLabel.text! + " - " + team
        }
    }
    
    override func prepareForReuse() {
        descriptionLabel.text = ""
        recipientLabel.text = ""
    }
}
