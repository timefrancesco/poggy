//
//  AddNewActionViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 9/05/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//


import UIKit
import Eureka

class AddNewActionViewController:FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("New Action", comment: "")
        setupTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Poggy"
    }
    
    func setupTableView() {
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = PoggyConstants.POGGY_BLUE
            cell.backgroundColor = UIColor.blackColor()
        }
        form
            +++ Section("") { section in
            }
            
            <<< ButtonRow() { row in
                row.title = NSLocalizedString("SMS / iMessage", comment: "")
                row.presentationMode = .SegueName(segueName: "NewSmsActionSegue", completionCallback: nil)
            }
            
            <<< ButtonRow() { row in
                row.title = NSLocalizedString("Slack", comment: "")
                row.presentationMode = .SegueName(segueName: "NewSlackActionSegue", completionCallback: nil)
            }
        
        super.tableView?.backgroundColor = UIColor.blackColor()
        super.tableView?.separatorColor = PoggyConstants.POGGY_BLUE
        super.tableView?.tintColor = PoggyConstants.POGGY_BLUE
    }
}