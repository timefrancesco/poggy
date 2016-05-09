//
//  SlackActionViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 9/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class SlackActionViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onAddSlackAuthTouchUpInside(sender: AnyObject) {
        doOAuthSlack()
        
        
    }
    
    func doOAuthSlack(){
        SlackHelper.instance.authenticate(self) { (slackDetails) in
            if let slack = slackDetails {
                print (slack.teamName)
                print (slack.token)
            }
        }
    }
}