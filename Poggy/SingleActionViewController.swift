//
//  SingleActionViewController.swift
//  Poggy
//
//  Created by Francesco Pretelli on 26/04/16.
//  Copyright © 2016 Francesco Pretelli. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class SingleActionViewController:UIViewController, CNContactPickerDelegate, PoggyToolbarDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var loadContactsBtn: UIButton!
    
    var newActionDelegate:NewActionDelegate?
    private var contactName:String?
    private var contactImage:NSData?
    private let poggyToolbar = PoggyToolbar()
    private var actionToEdit:PoggyAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Add", comment: "")
        
        descriptionTextField.backgroundColor = UIColor.clearColor()
        numberTextField.backgroundColor = UIColor.clearColor()
        
        //Set up keyboard toolbar
        poggyToolbar.poggyDelegate = self
        descriptionTextField.inputAccessoryView = poggyToolbar
        numberTextField.inputAccessoryView = poggyToolbar
        messageTextField.inputAccessoryView = poggyToolbar
        poggyToolbar.setButtonTitle(NSLocalizedString("NEXT", comment: ""))
        poggyToolbar.sizeToFit()
        
        messageTextField.delegate = self
        
        //adding placeholder to textview
        messageTextField.text = NSLocalizedString("Message to send", comment: "")
        messageTextField.textColor = UIColor.darkGrayColor()
        
        //changing placeholder color
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Description", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
        numberTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Phone Number", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let action = actionToEdit {
            messageTextField.text = action.message
            contactName = action.recipientName
            contactImage = action.recipientImage
            numberTextField.text = action.recipientNumber
            descriptionTextField.text = action.actionDescription
        }
        
        descriptionTextField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLines() //TODO: Use NSLayoutConstraints and move to ViewDidLoad
    }
    
    func setLines() {
        //bottom line under textFields
        let descriptionBottomLine = UIView(frame: CGRectMake(descriptionTextField.frame.origin.x, descriptionTextField.frame.origin.y + descriptionTextField.frame.height, descriptionTextField.frame.size.width, 0.5))
        descriptionBottomLine.backgroundColor = PoggyConstants.POGGY_BLUE
        descriptionBottomLine.opaque = true
        
        let numberBottomLine = UIView(frame: CGRectMake(numberTextField.frame.origin.x, numberTextField.frame.origin.y + numberTextField.frame.height, numberTextField.frame.size.width, 0.5))
        numberBottomLine.backgroundColor = PoggyConstants.POGGY_BLUE
        numberBottomLine.opaque = true
        
        view.addSubview(descriptionBottomLine)
        view.addSubview(numberBottomLine)
    }
    
    func updateFromActionsViewController(action:PoggyAction) {
        actionToEdit = action
    }
    
    func clearFields() {
        messageTextField.text = ""
        descriptionTextField.text = ""
        numberTextField.text = ""
        contactImage = nil
        contactName = nil
        actionToEdit = nil
    }
    
    func textFieldsFilled() -> Bool {
        if messageTextField.text != "" && numberTextField.text != "" && descriptionTextField.text != "" {
            return true
        }
        return false
    }
    
    func createActionFromFields() -> PoggyAction {
        let newAction = PoggyAction()
        newAction.actionDescription = descriptionTextField.text
        newAction.message = messageTextField.text
        newAction.recipientNumber = numberTextField.text
        newAction.recipientName = contactName
        newAction.recipientImage = contactImage
        newAction.isActive = true
        
        if let index = actionToEdit?.actionIndex {
            newAction.actionIndex = index
        }
        
        return newAction
    }
    
    @IBAction func onloadContactsBtnTouchUpInside(sender: AnyObject) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    @IBAction func onAddButtonTouchUpInside(sender: AnyObject) {
            }
    
    func addNewAction() {
        if !textFieldsFilled() {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Fields cannot be empty", comment: ""), preferredStyle: .Alert)
            let actionCancel = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.Cancel) { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(actionCancel)
            presentViewController(alert, animated: false, completion: nil)
            return
        }
        
        if let actionDelegate = newActionDelegate {
            let update = actionToEdit == nil ? false : true
            actionDelegate.addAction(createActionFromFields(), update:update)
            clearFields()
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as! CNPhoneNumber
        
        numberTextField.text = phoneNumber.stringValue
        contactName = contact.givenName
        if contact.imageDataAvailable {
            contactImage = contact.thumbnailImageData
        }
    }
    
    //MARK: Textview delegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        poggyToolbar.setButtonTitle(NSLocalizedString("ADD", comment: ""))
        
        if messageTextField.text == NSLocalizedString("Message to send", comment: "") {
            messageTextField.text = ""
            messageTextField.textColor = PoggyConstants.POGGY_BLUE
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        poggyToolbar.setButtonTitle(NSLocalizedString("NEXT", comment: ""))
        if messageTextField.text == "" {
            messageTextField.text = NSLocalizedString("Message to send", comment: "")
            messageTextField.textColor = UIColor.darkGrayColor()
        }
    }
    
    //MARK: Toolbar delegate
    
    func onPoggyToolbarButtonTouchUpInside() {
        if descriptionTextField.isFirstResponder() {
            numberTextField.becomeFirstResponder()
        } else if numberTextField.isFirstResponder() {
            messageTextField.becomeFirstResponder()
        } else if messageTextField.isFirstResponder() {
            messageTextField.resignFirstResponder()
            addNewAction()
        }
    }
}