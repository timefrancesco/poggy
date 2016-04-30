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

class SingleActionViewController:UIViewController, CNContactPickerDelegate, PoggyToolbarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var loadContactsBtn: UIButton!
    
    var newActionDelegate:NewActionDelegate?
    var contactName:String?
    var contactImage:NSData?
    let poggyToolbar = PoggyToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = (NSLocalizedString("Add", comment: ""))
        
        //Set up keyboard toolbar
        poggyToolbar.poggyDelegate = self
        descriptionTextField.inputAccessoryView = poggyToolbar
        numberTextField.inputAccessoryView = poggyToolbar
        messageTextField.inputAccessoryView = poggyToolbar
        
        poggyToolbar.setButtonTitle(NSLocalizedString("NEXT", comment: ""))
        poggyToolbar.sizeToFit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        descriptionTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setStyle()
    }
    
    func setStyle() {
        descriptionTextField.backgroundColor = UIColor.clearColor()
        numberTextField.backgroundColor = UIColor.clearColor()
        
        //bottom line under textFields
        let descriptionBottomLine = UIView(frame: CGRectMake(descriptionTextField.frame.origin.x, descriptionTextField.frame.origin.y + descriptionTextField.frame.height, descriptionTextField.frame.size.width, 0.5))
        descriptionBottomLine.backgroundColor = PoggyConstants.POGGY_BLUE
        descriptionBottomLine.opaque = true
        
        let numberBottomLine = UIView(frame: CGRectMake(numberTextField.frame.origin.x, numberTextField.frame.origin.y + numberTextField.frame.height, numberTextField.frame.size.width, 0.5))
        numberBottomLine.backgroundColor = PoggyConstants.POGGY_BLUE
        numberBottomLine.opaque = true
        
        view.addSubview(descriptionBottomLine)
        view.addSubview(numberBottomLine)
        
        //changing placeholder color
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        numberTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
    }
    
    func clearFields() {
        messageTextField.text = ""
        descriptionTextField.text = ""
        numberTextField.text = ""
        contactImage = nil
        contactName = nil
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
            //DISPLAY ERROR
            return
        }
        
        if let actionDelegate = newActionDelegate {
            actionDelegate.addAction(createActionFromFields())
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
    
    //MARK: Toolbar delegate
    func onPoggyToolbarButtonTouchUpInside() {
        if descriptionTextField.isFirstResponder() {
            poggyToolbar.setButtonTitle(NSLocalizedString("NEXT", comment: ""))
            numberTextField.becomeFirstResponder()
        } else if numberTextField.isFirstResponder() {
            poggyToolbar.setButtonTitle(NSLocalizedString("ADD", comment: ""))
            messageTextField.becomeFirstResponder()
        } else if messageTextField.isFirstResponder() {
            poggyToolbar.setButtonTitle(NSLocalizedString("ADD", comment: ""))
            messageTextField.resignFirstResponder()
            addNewAction()
        }
    }
}