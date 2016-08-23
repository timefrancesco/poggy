//
//  SlackActionViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 9/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import UIKit
import Eureka

class SlackActionViewController:FormViewController, PoggySlackDelegate, PoggyToolbarDelegate {
    
    private var actionToEdit:PoggyAction?
    private var currentSlackAction = PoggyAction()
    private let poggyToolbar = PoggyToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = NSLocalizedString("Slack Action", comment: "")
    }
    
    func setupTableView() {
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = PoggyConstants.POGGY_BLACK
        }
        
        PushRow<String>.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = PoggyConstants.POGGY_BLACK
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = PoggyConstants.POGGY_BLACK
            cell.textField.textColor = UIColor.whiteColor()
        }
        
        form
            +++ Section("") { section in
            }
            
            <<< TextRow("Description") { row in
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
                row.presentationMode = .SegueName(segueName: "ChannelSelectionSegue", completionCallback: nil)
            }.cellUpdate({ [weak self] (cell, row) in
                if let channel = self?.currentSlackAction.slackChannel {
                    cell.detailTextLabel?.text = channel.name
                } else if let user = self?.currentSlackAction.slackUser {
                    cell.detailTextLabel?.text = user.username
                }
               
                if self?.currentSlackAction.slackTeam == nil {
                    row.disabled = true
                } else {
                    row.disabled = false
                }
                
                //row.isDisabled = self?.currentSlackAction.slackTeam == nil ? true : false
                print (row.disabled)
            })
            <<< TextRow("Message") { row in
                row.title = NSLocalizedString("Message", comment: "")
            }.cellUpdate({ (cell, row) in
                cell.textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Message To Send", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
                cell.textField.text = self.currentSlackAction.message
            }).cellSetup({ (cell, row) in
                self.poggyToolbar.poggyDelegate = self
                self.poggyToolbar.setButtonTitle(NSLocalizedString("ADD", comment: ""))
                cell.textField.inputAccessoryView = self.poggyToolbar
                self.poggyToolbar.sizeToFit()
            })
        
        super.tableView?.backgroundColor = PoggyConstants.POGGY_BLACK
        super.tableView?.separatorColor = PoggyConstants.POGGY_BLUE
        super.tableView?.tintColor = PoggyConstants.POGGY_BLUE
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TeamSelectionSegue" {
            if let destination = segue.destinationViewController as? SlackTeamSelectionViewController {
               destination.delegate = self
            }
        } else if segue.identifier == "ChannelSelectionSegue" {
            if let destination = segue.destinationViewController as? SlackChannelSelectionViewController {
                destination.teamToken = currentSlackAction.slackToken
                destination.delegate = self
            }
        }
    }
    
    func updateFromActionsViewController(action:PoggyAction) {
        actionToEdit = action
    }
    
    func addNewAction() {
        let descRow = form.rowByTag("Description") as? TextRow
        currentSlackAction.actionDescription = descRow?.cell.textField.text
        
        let messageRow = form.rowByTag("Message") as? TextRow
        currentSlackAction.message = messageRow?.cell.textField.text
        
        if !actionIsReady() {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Fields cannot be empty", comment: ""), preferredStyle: .Alert)
            let actionCancel = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.Cancel) { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(actionCancel)
            presentViewController(alert, animated: false, completion: nil)
            return
        }
        
        currentSlackAction.actionIndex = actionToEdit?.actionIndex
        let update = actionToEdit == nil ? false : true
        ActionsHelper.instance.addAction(currentSlackAction, update:update)
        NSNotificationCenter.defaultCenter().postNotificationName(PoggyConstants.NEW_ACTION_CREATED, object: nil)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func actionIsReady() -> Bool {
        if (currentSlackAction.slackChannel != nil || currentSlackAction.slackUser != nil )  && currentSlackAction.slackTeam != nil && currentSlackAction.message != nil && currentSlackAction.actionDescription != nil {
            return true
        }
        return false
    }
    
    //MARK: - delegate functions
    
    func slackTeamSelected(teamName: String, teamToken: String) {
        currentSlackAction.slackTeam = teamName
        currentSlackAction.slackToken = teamToken
    }
    
    func slackChannelSelected(channel: SlackChannel) {
        currentSlackAction.slackChannel = channel
    }
    
    func slackUserSelected(user: SlackUser) {
        currentSlackAction.slackUser = user
    }
    
    //Toolbar delegate
    
    func onPoggyToolbarButtonTouchUpInside() {
        addNewAction()
    }
}

//MARK: - Slack protocol

protocol PoggySlackDelegate {
    func slackTeamSelected(teamName: String, teamToken: String)
    func slackChannelSelected(channel: SlackChannel)
    func slackUserSelected(user:SlackUser)
}

//MARK: - Team Selection Class

class SlackTeamSelectionViewController: FormViewController {
    
    var slackTeams:[String: String]?
    var delegate:PoggySlackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select Team", comment: "")
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
            cell.backgroundColor =  PoggyConstants.POGGY_BLACK
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
        
        
        
        form +++ ButtonRow() { row in
                row.title = NSLocalizedString("Add Slack Team", comment: "")
                row.onCellSelection({ (cell, row) in
                    self.doOAuthSlack()
                }).cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor =  PoggyConstants.POGGY_BLACK
                    cell.backgroundColor = PoggyConstants.POGGY_BLUE
                })
        }
        
        super.tableView?.backgroundColor =  PoggyConstants.POGGY_BLACK
        super.tableView?.separatorColor = PoggyConstants.POGGY_BLUE
        super.tableView?.tintColor = PoggyConstants.POGGY_BLUE
    }
    
    func doOAuthSlack(){
        SlackHelper.instance.authenticate(self) { [weak self] (slackDetails) in
            if let slack = slackDetails {
                print (slack.teamName)
               // print (slack.token)
                
                self?.form.removeAll()
                self?.slackTeams = SlackHelper.instance.getAuthCredentials()
                self?.setupTableView()
            }
        }
    }
}

//MARK: - Channel Selection Class

class SlackChannelSelectionViewController: FormViewController {
    var teamToken:String?
    var delegate:PoggySlackDelegate?
    
    private var publicChannels:[SlackChannel]?
    private var privateChannels:[SlackChannel]?
    private var users:[SlackUser]?
    private var teamIcon:String?
    private let apiDispatchGroup = dispatch_group_create();
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select Channel", comment: "")
        getPublicChannels()
        getPrivateChannels()
        getUsers()
        getTeamInfo()
        
        super.tableView?.hidden = true
        activityIndicatorView.startAnimating()
        
        dispatch_group_notify(apiDispatchGroup, dispatch_get_main_queue(), {
            self.setupTableView()
            super.tableView?.hidden = false
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true
        })
    }
    
    func setupTableView() {
        
        let publicSection = NSLocalizedString("Public", comment: "")
        let privateSection = NSLocalizedString("Private", comment: "")
        let usersSection = NSLocalizedString("Users", comment: "")
        
        form
            +++ Section("") { section in
            
            }
            
        <<< SegmentedRow<String>("channels"){
                $0.options = [publicSection, privateSection, usersSection]
                $0.value = publicSection
        }.cellSetup({ (cell, row) in
            cell.backgroundColor =  PoggyConstants.POGGY_BLACK
            cell.tintColor = PoggyConstants.POGGY_BLUE
        })
        
        +++ Section() { section in
            section.tag = publicSection
            let hiddenCondition = "$channels != '\(publicSection)'"
            section.hidden = Condition(stringLiteral: hiddenCondition)
            
            if let pubChannels = publicChannels {
                for channel in pubChannels {
                    section.append(ButtonRow() { row in
                        let channelName = "#" + channel.name!
                        row.title =  channelName
                        row.onCellSelection({ [weak self] (cell, row) in
                            if self?.delegate != nil {
                                channel.teamIcon = self?.teamIcon
                                self?.delegate?.slackChannelSelected(channel)
                                self?.navigationController?.popViewControllerAnimated(true)
                            }
                        })
                    })
                }
            }
        }
        
        form +++ Section() { section in
            section.tag = privateSection
            let hiddenCondition = "$channels != '\(privateSection)'"
            section.hidden = Condition(stringLiteral: hiddenCondition)
       
            if let privateChannels = privateChannels {
                for channel in privateChannels {
                    section.append( ButtonRow() { row in
                        row.title =  channel.name
                        row.onCellSelection({ [weak self] (cell, row) in
                            if self?.delegate != nil {
                                self?.delegate?.slackChannelSelected(channel)
                                self?.navigationController?.popViewControllerAnimated(true)
                            }
                        })
                    })
                }
            }
        }
        
        form +++ Section() { section in
            section.tag = usersSection
            let hiddenCondition = "$channels != '\(usersSection)'"
            section.hidden = Condition(stringLiteral: hiddenCondition)
    
            if let users = users {
                for user in users {
                    section.append(ButtonRow() { row in
                        row.title =  user.username
                        row.onCellSelection({ [weak self] (cell, row) in
                            if self?.delegate != nil {
                                self?.delegate?.slackUserSelected(user)
                                self?.navigationController?.popViewControllerAnimated(true)
                            }
                        })
                    })
                }
            }
        }
        
        super.tableView?.backgroundColor =  PoggyConstants.POGGY_BLACK
        super.tableView?.separatorColor = PoggyConstants.POGGY_BLUE
        super.tableView?.tintColor = PoggyConstants.POGGY_BLUE
    }
    
    //MARK: Api Calls
    
    func getPublicChannels() {
        if let token = teamToken {
            dispatch_group_enter(apiDispatchGroup)
            SlackHelper.instance.getChannels(token, type: .PUBLIC, callback: { [weak self] (data) in
                self?.publicChannels = data
                if let dispatchGroup = self?.apiDispatchGroup {
                    dispatch_group_leave(dispatchGroup)
                }
            })
        }
    }
    
    func getPrivateChannels() {
        if let token = teamToken {
            dispatch_group_enter(apiDispatchGroup)
            SlackHelper.instance.getChannels(token, type: .PRIVATE, callback: { [weak self] (data) in
                self?.privateChannels = data
                if let dispatchGroup = self?.apiDispatchGroup {
                    dispatch_group_leave(dispatchGroup)
                }
            })
        }
    }
    
    func getUsers() {
        if let token = teamToken {
            dispatch_group_enter(apiDispatchGroup)
            SlackHelper.instance.getUsers(token, callback: { [weak self] (data) in
                self?.users = data
                if let dispatchGroup = self?.apiDispatchGroup {
                    dispatch_group_leave(dispatchGroup)
                }
            })
        }
    }
    
    func getTeamInfo() {
        if let token = teamToken {
            dispatch_group_enter(apiDispatchGroup)
            SlackHelper.instance.getTeamInfo(token) { [weak self] (data) in
                self?.teamIcon = data?.icon
                if let dispatchGroup = self?.apiDispatchGroup {
                    dispatch_group_leave(dispatchGroup)
                }
            }
        }
    }
}
