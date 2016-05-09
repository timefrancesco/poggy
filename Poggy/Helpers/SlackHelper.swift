//
//  SlackHelper.swift
//  Poggy
//
//  Created by Francesco Pretelli on 10/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import OAuthSwift

class SlackResponse {
    dynamic var teamName:String?
    dynamic var token:String?
    
    convenience init(teamName: String, token: String) {
        self.init()
        
        self.teamName = teamName
        self.token = token
    }
}

class SlackHelper {
    
    static let instance = SlackHelper() // singleton
    private init() { } // This prevents others from using the default '()' initializer for this class.

    func authenticate(viewController:UIViewController, callback: (slackDetails: SlackResponse?) -> Void)  {
        let oauthswift = OAuth2Swift(
            consumerKey:    "key",
            consumerSecret: "secret",
            authorizeUrl:   "https://slack.com/oauth/authorize",
            accessTokenUrl: "https://slack.com/api/oauth.access",
            responseType:   "code"
        )
        oauthswift.authorize_url_handler = SafariURLHandler(viewController: viewController)
        let state: String = generateStateWithLength(20) as String
        
        oauthswift.authorizeWithCallbackURL( NSURL(string: "poggy://oauth-callback/slack")!, scope: "channels:read chat:write:user", state: state, success: {
            credential, response, parameters in
            
                if let teamName = parameters["team_name"] {
                    if let token = parameters["access_token"] {
                        self.saveAuthCredentials(teamName, token: token)
                        callback(slackDetails: SlackResponse(teamName: teamName, token: token))
                    }
                }
            }, failure: { error in
                NSLog(error.localizedDescription)
        })
    }
    
    private func saveAuthCredentials(teamName:String, token:String) {
        var newCredentials = [String: String]()
        
        if let savedCredentials = getAuthCredentials() {
            newCredentials = savedCredentials
        }
        
        newCredentials[teamName] = token
        NSUserDefaults.standardUserDefaults().setValue(newCredentials, forKey: PoggyConstants.SLACK_TEAMS_STORE_KEY)
    }
    
    func getAuthCredentials() -> [String: String]? {
        return NSUserDefaults.standardUserDefaults().valueForKey(PoggyConstants.SLACK_TEAMS_STORE_KEY) as? [String: String]
    }    
}