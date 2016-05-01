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
    func addAction(action:PoggyAction, update:Bool)
}

class ActionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewActionDelegate, WCSessionDelegate  {

    @IBOutlet weak var noActionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewActionButton: UIButton!
    var actions = [PoggyAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Poggy"
        
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addNewActionButton.layer.cornerRadius = addNewActionButton.frame.width / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
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
        readActions()
        tableView.reloadData()
        syncActionsWithWatch()
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
                
                if let action = sender as? PoggyAction {
                    destination.updateFromActionsViewController(action)
                }
            }
        }
    }
    
    func syncActionsWithWatch(){
        do {
            var actionsDict = [String : AnyObject]()
            actionsDict[PoggyConstants.ACTIONS_DICT_ID] = NSKeyedArchiver.archivedDataWithRootObject(actions)
            try WCSession.defaultSession().updateApplicationContext(actionsDict)
        } catch {
            NSLog("Error Syncing actions with watch: \(error)")
        }
    }
    
    //MARK: NewAction Delegate Functions
    
    func addAction(action:PoggyAction, update:Bool) {
        clearActiveAction()
    
        if !update {
            actions.append(action)
        } else if let index = action.actionIndex {
            actions[index] = action
        }
        saveActions()
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
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            self.actions.removeAtIndex(indexPath.row)
            if self.actions.count > 0 {
                let active = self.actions.filter { $0.isActive! }.first
                if active == nil {
                    self.actions[0].isActive = true
                }
            }
            self.saveActions()
        }
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            let action = self.actions[indexPath.row]
            action.actionIndex = indexPath.row
            self.performSegueWithIdentifier("NewActionSegue", sender: action)
        }
        
        edit.backgroundColor = PoggyConstants.POGGY_BLUE
        return [delete, edit]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        clearActiveAction()
        actions[indexPath.row].isActive = true
        saveActions()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

