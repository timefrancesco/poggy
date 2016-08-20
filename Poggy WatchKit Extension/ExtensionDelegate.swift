//
//  ExtensionDelegate.swift
//  Poggy WatchKit Extension
//
//  Created by Francesco Pretelli on 24/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    override init() {
        super.init()
       
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        NSKeyedUnarchiver.setClass(PoggyAction.self, forClassName: PoggyConstants.DATA_SERIALIZATION_ID)
        if let data = NSKeyedUnarchiver.unarchiveObjectWithData(applicationContext[PoggyConstants.ACTIONS_DICT_ID] as! NSData) as? [PoggyAction] {
            ActionsHelper.instance.setActions(data)
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(PoggyConstants.NEW_DATA_NOTIFICATION, object: nil)
        }
    }

}
