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

class Notifications: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages = [(String, String)]()
    var tableView = UITableView()
    @IBOutlet var bar: UITabBarItem!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let currentInstallation = PFInstallation.currentInstallation()
        if currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Notif")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for notif: NSManagedObject in results!{
                var added = false
                for pair in messages{
                    if pair.0 == notif.valueForKey("club") as! String && pair.1 == notif.valueForKey("text") as! String{
                        added = true
                    }
                }
                if !added{
                    messages.append((notif.valueForKey("club") as! String, notif.valueForKey("text") as! String))
                }
            }
        } catch {
            print("whoops")
        }
        tableView.reloadData()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentInstallation = PFInstallation.currentInstallation()
        if currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
        tableView = UITableView()
        tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Notif")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for notif: NSManagedObject in results!{
                var added = false
                for pair in messages{
                    if pair.0 == notif.valueForKey("club") as! String && pair.1 == notif.valueForKey("text") as! String{
                        added = true
                    }
                }
                if !added{
                    messages.append((notif.valueForKey("club") as! String, notif.valueForKey("text") as! String))
                }
            }
        } catch {
            print("whoops")
        }
        tableView.reloadData()


                // Do any additional setup after loading the view.
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
        cell!.detailTextLabel?.text = messages[indexPath.row].1
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertView(title: messages[indexPath.row].0, message: messages[indexPath.row].1, delegate: self, cancelButtonTitle: "Ok")
        alert.cancelButtonIndex = 0
        alert.show()

    }
    
    @IBAction func deleteNotifs(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Notif")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for notif: NSManagedObject in results!{
                managedContext.deleteObject(notif)
            }
        } catch {
            print("whoops")
        }
        messages = []
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the club object the user is trying to delete
            let toDelete = messages[indexPath.row]
            // Delete it from the managedObjectContext
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName:"Notif")
            do {
                let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                let results = fetchedResults
                for notif: NSManagedObject in results!{
                    if toDelete.0 == notif.valueForKey("club") as! String && toDelete.1 == notif.valueForKey("text") as! String{
                        managedContext.deleteObject(notif)
                        break;
                    }
                }
            } catch {
                print("whoops")
            }
            // Refresh the table view to indicate that it's deleted
            for i in 0..<messages.count {
                if messages[i].0 == toDelete.0 && messages[i].1 == toDelete.1{
                    messages.removeAtIndex(i)
                    break
                }
            }
            self.tableView.reloadData()
            // Tell the table view to animate out that row
            //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
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
