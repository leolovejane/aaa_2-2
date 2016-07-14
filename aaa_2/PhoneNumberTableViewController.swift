//
//  PhoneNumberTableViewController.swift
//  aaa
//
//  Created by Apple on 16/6/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class PhoneNumberTableViewController: UITableViewController {

    var phoneNumbers = [PhoneNumber]()
    func loadSample(){
        let phoneNumber1=PhoneNumber(name: "aaa", number: "13313313131")!
        let phoneNumber2=PhoneNumber(number: "18181818888")!
        phoneNumbers += [phoneNumber1,phoneNumber2]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedPhoneNumbers = loadPhoneNumbers() {
            phoneNumbers += savedPhoneNumbers
        }
        else {
            loadSample()
        }
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
        return phoneNumbers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PhoneNumberTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PhoneNumberTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let phoneNumber = phoneNumbers[indexPath.row]
        
        cell.Name.text = phoneNumber.name
        cell.Number.text = phoneNumber.number

        // Configure the cell...

        return cell
    }
    
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
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            phoneNumbers.removeAtIndex(indexPath.row)
            savePhoneNumbers()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        
    }
    
    func savePhoneNumbers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(phoneNumbers, toFile: PhoneNumber.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save phoneNumber...")
        }
    }
    
    func loadPhoneNumbers() -> [PhoneNumber]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(PhoneNumber.ArchiveURL.path!) as? [PhoneNumber]
    }

}
