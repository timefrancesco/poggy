//
//  ViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 24/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import UIKit
import WatchConnectivity
import ObjectMapper

class ActionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate  {

    @IBOutlet weak var noActionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewActionButton: UIButton!
    var actions = [PoggyAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        readActions()
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        } else {
            NSLog("WCSession not supported")
        }
        
        getSlackKeys()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.newActionHasBeenAdded(_:)), name: PoggyConstants.NEW_ACTION_CREATED, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Poggy"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addNewActionButton.layer.cornerRadius = addNewActionButton.frame.width / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewActionSegue" {
            if let destination = segue.destinationViewController as? SlackActionViewController {
                if let action = sender as? PoggyAction {
                    destination.updateFromActionsViewController(action)
                }
            }
        }
    }
    
    func getSlackKeys() {
        SlackHelper.instance.setSlackConsumerKey(BuddyBuildSDK.valueForDeviceKey(PoggyConstants.SLACK_CONSUMER_KEY))
        SlackHelper.instance.setSlackConsumerSecret(BuddyBuildSDK.valueForDeviceKey(PoggyConstants.SLACK_CONSUMER_SECRET))
        
        NSLog("Got SlackKeys")
        
       /* print(SlackHelper.instance.getSlackConsumerKey())
        print(SlackHelper.instance.getSlackConsumerSecret())*/
        
     /*   let a = BuddyBuildSDK.valueForDeviceKey(PoggyConstants.SLACK_CONSUMER_KEY)
        print(BuddyBuildSDK.valueForDeviceKey(PoggyConstants.SLACK_CONSUMER_KEY))*/
    }
    
    //MARK: WCSessionDelegate functions
    
    func sessionDidBecomeInactive(session: WCSession) {
    
    }
    
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    func sessionDidDeactivate(session: WCSession) {
    
    }
    
    //MARK: Actions functions
    
    func readActions() {
        if let readActions = ActionsHelper.instance.getActions() {
            actions = readActions
            tableView.reloadData()
        }
        
        if actions.count > 0 {
            noActionsLabel.hidden = true
        } else {
            noActionsLabel.hidden = false
        }
    }
    
    func saveActions() {
        ActionsHelper.instance.setActions(actions)
        updateActions()
    }
    
    func syncActionsWithWatch(){
        do {
            var actionsDict = [String : AnyObject]()
            let actions = ActionsHelper.instance.getActions()
            if let actionData = Mapper().toJSONString(actions!, prettyPrint: true) {
                actionsDict[PoggyConstants.ACTIONS_DICT_ID] =  actionData
                try WCSession.defaultSession().updateApplicationContext(actionsDict)
            }
        } catch {
            NSLog("Error Syncing actions with watch: \(error)")
        }
    }
    
    func newActionHasBeenAdded(notification: NSNotification) {
        updateActions()
    }
    
    func updateActions() {
        readActions()
        tableView.reloadData()
        syncActionsWithWatch()
    }
    
    //MARK: TableView Delegate Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell", forIndexPath: indexPath) as! ActionCell
        cell.updateData(actions[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: NSLocalizedString("Delete", comment: "")) { (action, indexPath) in
            self.actions.removeAtIndex(indexPath.row)
            self.saveActions()
        }
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let action = self.actions[indexPath.row]
        action.actionIndex = indexPath.row
        self.performSegueWithIdentifier("NewActionSegue", sender: action)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

