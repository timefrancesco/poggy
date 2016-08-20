//
//  SlackHelper.swift
//  Poggy
//
//  Created by Francesco Pretelli on 10/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
#if os (iOS)
import OAuthSwift
#endif

class SlackHelper {
    
    enum channelType:String {
        case PUBLIC = "channels"
        case PRIVATE = "groups"
    }
    
    let OAUTH_ENDPOINT = "https://slack.com/oauth/authorize"
    let OUTH_TOKEN_ENDPOINT = "https://slack.com/api/oauth.access"
    let POGGY_OAUTH_CALLBACK_URL = "poggy://oauth-callback/slack"
    let PUBLIC_CHANNELS_ENDPOINT = "https://slack.com/api/channels.list?token="
    let PRIVATE_CHANNELS_ENDPOINT = "https://slack.com/api/groups.list?token="
    let USER_LIST_ENDPOINT = "https://slack.com/api/im.list?token="
    let POST_MESSAGE_ENDPOINT = "https://slack.com/api/chat.postMessage?token="
    
    static let instance = SlackHelper() // singleton
    private init() { } // This prevents others from using the default '()' initializer for this class.
    
#if os (iOS) //no need to authenticate from watch
    func authenticate(viewController:UIViewController, callback: (slackDetails: SlackAuthResponse?) -> Void)  {
        let oauthswift = OAuth2Swift(
            consumerKey:    "41121903398.41135431681",
            consumerSecret: "3481b8cc6da070f9957e1da380906ef5",
            authorizeUrl:   OAUTH_ENDPOINT,
            accessTokenUrl: OUTH_TOKEN_ENDPOINT,
            responseType:   "code"
        )
    
    oauthswift.authorize_url_handler = SafariURLHandler(viewController: viewController, oauthSwift:oauthswift )
        let state: String = generateStateWithLength(20) as String
        
        oauthswift.authorizeWithCallbackURL( NSURL(string: POGGY_OAUTH_CALLBACK_URL)!, scope: "channels:read groups:read im:read chat:write:user", state: state, success: {
            credential, response, parameters in
            
                if let teamName = parameters["team_name"] as? String{
                    if let token = parameters["access_token"] as? String {
                        self.saveAuthCredentials(teamName, token: token)
                        callback(slackDetails: SlackAuthResponse(teamName: teamName, token: token))
                    }
                }
            }, failure: { error in
                NSLog(error.localizedDescription)
        })
    }
#endif
    
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
    
    //MARK: - API Calls
    
    func getChannels(teamToken: String, type:channelType, callback: (data: [SlackChannel]?) -> Void) {
        let endpoint = type == .PUBLIC ? PUBLIC_CHANNELS_ENDPOINT + teamToken : PRIVATE_CHANNELS_ENDPOINT + teamToken
        
        sendRequestArray(endpoint, method: Method.GET, keyPath: type.rawValue) { (result: [SlackChannel]?) in
            callback(data: result)
        }
    }
    
    func getUsers(teamToken: String, callback: (data: [SlackUser]?) -> Void) {
        let endpoint = USER_LIST_ENDPOINT + teamToken
        
        sendRequestArray(endpoint, method: Method.GET, keyPath: "ims") { (result: [SlackUser]?) in
            callback(data: result)
        }
    }
    
    func postMessage(teamToken: String, channelName: String, message: String, callback: (data: SlackMessageResponse?) -> Void) {
        let endpoint = "\(POST_MESSAGE_ENDPOINT)\(teamToken)&channel=\(channelName)&text=\(message)&pretty=1"
        
        sendRequestObject(endpoint, method: Method.POST) { (result: SlackMessageResponse?) in
            callback(data: result)
        }
    }
    
    private func sendRequestObject<T: Mappable>(endpoint: String, method: Alamofire.Method, headers: [String: String]? = nil, parameters: [String: AnyObject]? = nil, keyPath: String = "", encoding: ParameterEncoding? = .JSON, callback: (result: T?) -> Void) {
        NSLog("API Calling sendRequestObject: " + endpoint)
        
        Alamofire.request(method, endpoint, headers: headers, parameters: parameters, encoding: encoding!).responseObject(keyPath: keyPath) { (response: Response<T, NSError>) in
            guard response.result.error == nil
                else {
                    NSLog("error in API object request" + " -> " + String(response.result.error!))
                    callback(result: nil)
                    return
            }
            callback(result: response.result.value!)
        }
    }
    
    private func sendRequestArray<T: Mappable>(endpoint: String, method: Alamofire.Method, headers: [String: String]? = nil, parameters: [String: AnyObject]? = nil, keyPath: String = "", encoding: ParameterEncoding? = .JSON,  callback: (result: [T]?) -> Void) {
        
        Alamofire.request(method, endpoint, headers: headers).responseArray(keyPath: keyPath) { (response: Response < [T], NSError >) in
            guard response.result.error == nil
                else {
                    NSLog("error in API array request" + " -> " + String(response.result.error!))
                    callback(result: nil)
                    return
            }
            callback(result: response.result.value!)
        }
    }
}
