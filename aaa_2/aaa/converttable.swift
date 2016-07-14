//
//  converttable.swift
//  aaa
//
//  Created by mamba on 16/7/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import AddressBook
import AddressBookUI
class converttale:UITableViewController{
  var phoneNumberss = [PhoneNumber]()

override func viewDidLoad() {
    super.viewDidLoad()
    
       // following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    navigationItem.leftBarButtonItem = editButtonItem()
    
   // let share=CNContactStore()
    
   //let num1=PhoneNumber(name:share[0],number: )!
    //phoneNumbers += [num1]
    
    
        super.viewDidLoad()
    var testSwiftContacts:Array = getSysContacts()
    if testSwiftContacts.isEmpty {
        print("no contact")
    }
    for contact in testSwiftContacts {
       // let num=PhoneNumber(name:contact["FirstName"]!,number:contact["LaseName"]!)
    //    phoneNumbers.append(num!)
        print(contact["FirstName"]!+" "+contact["LastName"]!)
       let phoneNumber1=PhoneNumber(name: contact["FirstName"]!, number: contact["LastName"]!)!
        phoneNumberss += [phoneNumber1]
    }
        //定义一个错误标记对象，判断是否成功

    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return phoneNumberss.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "converttedViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! converttedViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let phoneNumber = phoneNumberss[indexPath.row]
        
        cell.Name.text = phoneNumber.name
        cell.Number.text = phoneNumber.number
        
        // Configure the cell...
        
        return cell
    }/*
    @IBAction func unwindToPhoneNumberList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? PhoneNumberViewController, phoneNumber = sourceViewController.phoneNumber {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                phoneNumbers[selectedIndexPath.row] = phoneNumber
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                let newIndexPath = NSIndexPath(forRow: phoneNumbers.count,  inSection: 0)
                phoneNumbers.append(phoneNumber)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            savePhoneNumbers()
        }
    }*/
    
    
    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       // Return false if you do not want the specified item to be editable.
       // return true
//}
    
    
    
    // Override to support editing the table view.
    //override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, //forRowAtIndexPath indexPath: NSIndexPath) {
      //  if editingStyle == .Delete {
            // Delete the row from the data source
        //    phoneNumberss.removeAtIndex(indexPath.row)
        //    savePhoneNumbers()
      //      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      //  } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     //   }
   // }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let PhoneNumberDetailViewController = segue.destinationViewController as! PhoneNumberViewController
            
            // Get the cell that generated this segue.
            if let selectedPhoneNumberCell = sender as? PhoneNumberTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedPhoneNumberCell)!
                let selectedPhoneNumber = phoneNumbers[indexPath.row]
                PhoneNumberDetailViewController.phoneNumber = selectedPhoneNumber
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new number.")
        }
        
    }*/
    
  //  func savePhoneNumbers() {
   //     let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(phoneNumberss, toFile: PhoneNumber.ArchiveURL.path!)
     //   if !isSuccessfulSave {
       //     print("Failed to save phoneNumber...")
      // }
 //   }
    
    func loadPhoneNumbers() -> [PhoneNumber]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(PhoneNumber.ArchiveURL.path!) as? [PhoneNumber]
    }
    func getSysContacts() -> [[String:String]] {
        var error:Unmanaged<CFError>?
        var addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        
        if sysAddressBookStatus == .Denied || sysAddressBookStatus == .NotDetermined {
            // Need to ask for authorization
            var authorizedSingal:dispatch_semaphore_t = dispatch_semaphore_create(0)
            var askAuthorization:ABAddressBookRequestAccessCompletionHandler = { success, error in
                if success {
                    ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
                    dispatch_semaphore_signal(authorizedSingal)
                }
            }
            ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
            dispatch_semaphore_wait(authorizedSingal, DISPATCH_TIME_FOREVER)
        }
        
        return analyzeSysContacts( ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray )
    }
    
    func analyzeSysContacts(sysContacts:NSArray) -> [[String:String]] {
        var allContacts:Array = [[String:String]]()
        for contact in sysContacts {
            var currentContact:Dictionary = [String:String]()
            // 姓
            currentContact["FirstName"] = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
            // 名
            currentContact["LastName"] = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
            // 昵称
            currentContact["Nikename"] = ABRecordCopyValue(contact, kABPersonNicknameProperty)?.takeRetainedValue() as! String? ?? ""
            // 公司（组织）
            currentContact["Organization"] = ABRecordCopyValue(contact, kABPersonOrganizationProperty)?.takeRetainedValue() as! String? ?? ""
            // 职位
            currentContact["JobTitle"] = ABRecordCopyValue(contact, kABPersonJobTitleProperty)?.takeRetainedValue() as! String? ?? ""
            // 部门
            currentContact["Department"] = ABRecordCopyValue(contact, kABPersonDepartmentProperty)?.takeRetainedValue() as! String? ?? ""
            //备注
            currentContact["Note"] = ABRecordCopyValue(contact, kABPersonNoteProperty)?.takeRetainedValue() as! String? ?? ""
            allContacts.append(currentContact)
        }
        return allContacts
    }
}