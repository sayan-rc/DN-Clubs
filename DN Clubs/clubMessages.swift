//
//  Notifications.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/30/15.
//  Copyright (c) 2015 Nighthackers. All rights reserved.
//

import UIKit
import CoreData
import Parse
import CloudKit

class clubMessages: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages = [(String, String)]()
    var tableView = UITableView()
    var text1 = ""
    @IBOutlet var barText: UINavigationItem!
    @IBOutlet var bar: UITabBarItem!
    
    @IBAction func closeOut(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func deleteData(sender: AnyObject) {
        let toDelete = text1
        // Delete it from the managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Club")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for club: NSManagedObject in results!{
                if (club.valueForKey("name") as! String == toDelete){
                    managedContext.deleteObject(club)
                    break
                }
            }
        } catch {
            print("whoops")
        }
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.removeObject(toDelete.stringByReplacingOccurrencesOfString(" ", withString: ""), forKey: "channels")
        currentInstallation.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func contains(a:[(String, String)], v:(String,String)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let currentInstallation = PFInstallation.currentInstallation()
        if  currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        let query = CKQuery(recordType: "Notification", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        publicData.performQuery(query, inZoneWithID: nil) { results, error in
            if error == nil { // There is no error
                let channels = PFInstallation.currentInstallation().channels
                if(channels != nil){
                    print(channels)
                    for notif in results! {
                        let name = notif["Club"] as! String
                        for channel in channels!{
                            if (channel as! String == name){
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateStyle = .MediumStyle
                                let date = dateFormatter.stringFromDate(notif.creationDate!)
                                let text = (notif["Message"] as! String).componentsSeparatedByString(": ")
                                let temp = (date, text[1])
                                if(!self.contains(self.messages, v: temp) && self.messages.count<20 && text[0] == self.text1){
                                    self.messages.append(temp)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.tableView.reloadData()
                                    })
                                    
                                }
                                break
                            }
                        }
                    }
                }
            }
            else {
                print(error)
            }
        }

        
        tableView.reloadData()

    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //messages+=[("Hello", "World")]
        barText.title = text1
        let currentInstallation = PFInstallation.currentInstallation()
        if currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
        tableView = UITableView()
        tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-114)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        let query = CKQuery(recordType: "Notification", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        publicData.performQuery(query, inZoneWithID: nil) { results, error in
            if error == nil { // There is no error
                let channels = PFInstallation.currentInstallation().channels
                if(channels != nil){
                    for notif in results! {
                        let name = notif["Club"] as! String
                        for channel in channels!{
                            if (channel as! String == name){
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateStyle = .MediumStyle
                                let date = dateFormatter.stringFromDate(notif.creationDate!)
                                let text = (notif["Message"] as! String).componentsSeparatedByString(": ")
                                let temp = (date, text[1])
                                if(!self.contains(self.messages, v: temp) && self.messages.count<20 && text[0] == self.text1){
                                    self.messages.append(temp)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.tableView.reloadData()
                                    })
                                }
                                break
                            }
                        }
                    }
                }
            }
            else {
                print(error)
            }
        }
        tableView.reloadData()


                // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80.0;//Choose your custom row height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell!
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        cell!.textLabel?.text = messages[indexPath.row].0
        cell!.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        cell!.detailTextLabel?.text = messages[indexPath.row].1
        cell!.detailTextLabel?.font = UIFont.systemFontOfSize(15.0)
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertView(title: messages[indexPath.row].0, message: messages[indexPath.row].1, delegate: self, cancelButtonTitle: "Ok")
        alert.cancelButtonIndex = 0
        alert.show()

    }
    
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
