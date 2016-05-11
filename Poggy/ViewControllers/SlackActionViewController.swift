//
//  SlackActionViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 9/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import UIKit
import Eureka

class SlackActionViewController:FormViewController, PoggySlackDelegate {
    
    var currentSlackAction = SlackAction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupTableView() {
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = UIColor.blackColor()
        }
        
        PushRow<String>.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = UIColor.blackColor()
            cell.textField.textColor = UIColor.whiteColor()
        }
        
        form
            +++ Section("") { section in
            }
            
            <<< TextRow() { row in
                row.title = NSLocalizedString("Description", comment: "")
            }.cellUpdate({ (cell, row) in
                cell.textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Enter Description", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
                cell.textField.text = self.currentSlackAction.actionDescription
            })
            
            <<< PushRow<String>() { row in
                row.title = NSLocalizedString("Slack Team", comment: "")
                row.presentationMode = .SegueName(segueName: "TeamSelectionSegue", completionCallback: nil)
            }.cellUpdate({ (cell, row) in
                cell.detailTextLabel?.text = self.currentSlackAction.slackTeam
            })
            
            <<< PushRow<String>() { row in
                row.title = NSLocalizedString("Channel", comment: "")
                row.presentationMode = .SegueName(segueName: "NewSlackActionSegue", completionCallback: nil)
            }.cellUpdate({ (cell, row) in
                cell.detailTextLabel?.text = self.currentSlackAction.slackChannel
            })
            <<< TextRow() { row in
                row.title = NSLocalizedString("Message", comment: "")
            }.cellUpdate({ (cell, row) in
                cell.textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Message To Send", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
                cell.textField.text = self.currentSlackAction.message
            })
        
        super.tableView?.backgroundColor = UIColor.blackColor()
        super.tableView?.separatorColor = PoggyConstants.POGGY_BLUE
        super.tableView?.tintColor = PoggyConstants.POGGY_BLUE
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TeamSelectionSegue" {
            if let destination = segue.destinationViewController as? SlackTeamSelectionViewController {
               destination.delegate = self
            }
        }
    }
    
    //MARK: - delegate functions
    
    func slackTeamSelected(teamName: String, teamToken: String) {
        currentSlackAction.slackTeam = teamName
        currentSlackAction.slackToken = teamToken
       // super.tableView?.reloadData()
    }
}

//MARK: - Slack protocol

protocol PoggySlackDelegate {
    func slackTeamSelected(teamName: String, teamToken: String)
}

//MARK: - Team Selection Class

class SlackTeamSelectionViewController: FormViewController {
    
    var slackTeams:[String: String]?
    var delegate:PoggySlackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        form.removeAll()
        slackTeams = SlackHelper.instance.getAuthCredentials()
        setupTableView()
    }
    
    func setupTableView() {
        
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = UIColor.blackColor()
        }
        
        form +++ Section("") { section in
        
        }
        
        if let availableTeams = slackTeams {
            for team in availableTeams {
               form.last! <<< ButtonRow() { row in
                    row.title = team.0
                    row.onCellSelection({ (cell, row) in
                        print(team.1)
                        if self.delegate != nil {
                            self.delegate?.slackTeamSelected(team.0, teamToken: team.1)
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                }
            }
        }
        
        form +++= ButtonRow() { row in
                row.title = NSLocalizedString("Add Slack Team", comment: "")
                row.onCellSelection({ (cell, row) in
                    self.doOAuthSlack()
                })
        }
        
        super.tableView?.backgroundColor = UIColor.blackColor()
        super.tableView?.separatorColor = PoggyConstants.POGGY_BLUE
        super.tableView?.tintColor = PoggyConstants.POGGY_BLUE
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

//MARK: - Channel Selection Clas

class SlackChannelSelectionViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



