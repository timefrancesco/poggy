//
//  ViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 24/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import UIKit
import WatchConnectivity

protocol NewActionDelegate {
    func addAction(action:PoggyAction)
}

class ActionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewActionDelegate, WCSessionDelegate  {

    @IBOutlet weak var tableView: UITableView!
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func readActions() {
        if let readActions = ActionsHelper.instance.getActions() {
            actions = readActions
            tableView.reloadData()
        }
    }
    
    func saveActions() {
        ActionsHelper.instance.setActions(actions)
    }
    
    func clearActiveAction(){
        let activeActions = actions.filter {$0.isActive!}
        for action in activeActions {
            action.isActive = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewActionSegue" {
            if let destination = segue.destinationViewController as? SingleActionViewController {
                destination.newActionDelegate = self                
            }
        }
    }
    
    func syncActionsWithWatch(){
        do {
            var actionsDict = [String : AnyObject]()
            actionsDict[PoggyConstants.ACTIONS_DICT_ID] = NSKeyedArchiver.archivedDataWithRootObject(actions)
            try WCSession.defaultSession().updateApplicationContext(actionsDict)
        } catch {
            print("ERROR")
        }
    }
    
    //MARK: NewAction Delegate Functions
    
    func addAction(action:PoggyAction) {
        clearActiveAction()
        actions.append(action)
        saveActions()
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        clearActiveAction()
        actions[indexPath.row].isActive = true
        saveActions()
        tableView.reloadData()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        syncActionsWithWatch()
    }
}

