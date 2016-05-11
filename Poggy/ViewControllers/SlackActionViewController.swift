//
//  SlackActionViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 9/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import UIKit
import Eureka

class SlackActionViewController:FormViewController, SlackTeamSelectedDelegate {
    
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
            })
            
            <<< PushRow<String>() { row in
                row.title = NSLocalizedString("Slack Team", comment: "")
                row.presentationMode = .SegueName(segueName: "TeamSelectionSegue", completionCallback: nil)
            }.cellUpdate({ (cell, row) in
                row.value = self.currentSlackAction.slackTeam
            })
            
            <<< PushRow<String>() { row in
                row.title = NSLocalizedString("Channel", comment: "")
                row.presentationMode = .SegueName(segueName: "NewSlackActionSegue", completionCallback: nil)
            }.cellUpdate({ (cell, row) in
                row.value = self.currentSlackAction.slackChannel
            })
            <<< TextRow() { row in
                row.title = NSLocalizedString("Message", comment: "")
            }.cellUpdate({ (cell, row) in
                cell.textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Message To Send", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
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
    
    //MARK: - Team selection delegate
    
    func slackTeamSelected(teamName: String, teamToken: String) {
        currentSlackAction.slackTeam = teamName
        currentSlackAction.slackToken = teamToken
        super.tableView?.reloadData()
    }
}

protocol SlackTeamSelectedDelegate {
    func slackTeamSelected(teamName: String, teamToken: String)
}

class SlackTeamSelectionViewController:FormViewController {
    
    var slackTeams:[String: String]?
    var delegate:SlackTeamSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slackTeams = SlackHelper.instance.getAuthCredentials()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
    }
    
    func setupTableView() {
        
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = UIColor.blackColor()
        }
        
        form
            +++ Section("") { section in
        }
        
        form.removeAll()
        
        if let availableTeams = slackTeams {
            for team in availableTeams {
               form.last! <<< ButtonRow() { row in
                    row.title = team.0
                    row.onCellSelection({ (cell, row) in
                        print(team.1)
                        if self.delegate != nil {
                            self.delegate?.slackTeamSelected(team.0, teamToken: team.1)
                        }
                    })
                }
            }
        }
        
        form.last!  <<< ButtonRow() { row in
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