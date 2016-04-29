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
    
    func updateData(action:PoggyAction) {
        if let description = action.actionDescription {
            descriptionLabel.text = description
        }
    }
    
    override func prepareForReuse() {
        descriptionLabel.text = ""
    }
}