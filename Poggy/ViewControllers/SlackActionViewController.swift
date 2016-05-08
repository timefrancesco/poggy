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
    
    func doOAuthSlack(/*serviceParameters: [String:String]*/){
        let oauthswift = OAuth2Swift(
            consumerKey:    "key",
            consumerSecret: "secret",
            authorizeUrl:   "https://slack.com/oauth/authorize",
            accessTokenUrl: "https://slack.com/api/oauth.access",
            responseType:   "code"
        )
        oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "poggy://oauth-callback/slack")!, scope: "channels:read chat:write:user", state: state, success: {
            credential, response, parameters in
            //self.showTokenAlert(serviceParameters["name"], credential: credential)
            print (state)
            print (parameters["name"])
            print (credential)
            }, failure: { error in
                print(error.localizedDescription, terminator: "")
        })
    }
}