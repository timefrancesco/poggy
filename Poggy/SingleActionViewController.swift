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

class SingleActionViewController:UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var loadContactsBtn: UIButton!
    
    var newActionDelegate:NewActionDelegate?
    var contactName:String?
    var contactImage:NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
}