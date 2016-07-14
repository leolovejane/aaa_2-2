//
//  ViewController.swift
//  aaa
//
//  Created by Apple on 16/6/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class PhoneNumberViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate,CNContactPickerDelegate{

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Number: UITextField!
    var phoneNumber = PhoneNumber?()
    var m=true
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Number.delegate = self
        if let phoneNumber = phoneNumber {
            navigationItem.title = phoneNumber.name
            Name.text   = phoneNumber.name
            Number.text = phoneNumber.number
        }
        checkValidMealName()
        let authStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        if authStatus == CNAuthorizationStatus.Denied || authStatus == CNAuthorizationStatus.NotDetermined{
            ContactsStore.sharedStore.requestAccessForEntityType(CNEntityType.Contacts,
                                                                 completionHandler: { (result, error) -> Void in
                                                                    if result == false{
                                                                        self.performSelectorOnMainThread(#selector(PhoneNumberViewController.showAlertWhenAuthFail), withObject: nil, waitUntilDone: false)
                                                                    }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //@IBAction func touch(sender: UIButton) {
        
       // showContactsList()
  //  }
    @IBAction func tt(sender: UIButton) {
        showContactsList()
    }
    
    @IBAction func tt2(sender: UIButton) {
        m=false
        showContactsList()
       
    }
    func showAlertWhenAuthFail(){
        let alert = UIAlertController(title: "警告", message: "请在设置中允许通讯录访问，否则App无法正常使用", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel , handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func showContactsList(){
        let contactsVC = CNContactPickerViewController()
        contactsVC.delegate = self;
        presentViewController(contactsVC, animated:true, completion: nil)
    }
     func contactPicker(picker:CNContactPickerViewController,didSelectContact contact:CNContact ) {
       if let phoneNumber =  contact.phoneNumbers.first?.value as? CNPhoneNumber{
            self.Name.text = contact.givenName
            self.Number.text = phoneNumber.stringValue
           
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = Name.text ?? ""
            let number = Number.text ?? ""
            if (name.isEmpty){
                phoneNumber = PhoneNumber(number: number)
            }
            else {
                phoneNumber = PhoneNumber(name: name, number: number)
            }
            if m==false{
                showContactsList()
            }        }
        
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let number = Number.text ?? ""
        saveButton.enabled = !number.isEmpty
    }
    
}

