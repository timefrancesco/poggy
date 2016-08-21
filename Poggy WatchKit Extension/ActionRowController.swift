//
//  ActionRowController.swift
//  Poggy
//
//  Created by Francesco on 21/08/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import WatchKit

class ActionRowController: NSObject {
    

    @IBOutlet var actionDescriptionLabel: WKInterfaceLabel!
    @IBOutlet var slackTeamLabel: WKInterfaceLabel!
    @IBOutlet var slackChannelLabel: WKInterfaceLabel!
    
    
    var action: PoggyAction? {
        didSet {
            if let action = action {
                actionDescriptionLabel.setText(action.actionDescription)
                slackTeamLabel.setText(action.slackTeam)
                slackChannelLabel.setText(action.slackChannel)
            }
        }
    }
}
