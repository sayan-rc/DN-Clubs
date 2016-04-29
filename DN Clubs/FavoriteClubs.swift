//
//  FavoriteClubs.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/30/15.
//  Copyright (c) 2015 Nighthackers. All rights reserved.
//

import UIKit
import Parse

//G+

import AddressBook
import MediaPlayer
import CoreMotion
import CoreLocation
import AssetsLibrary

import CoreData

class FavoriteClubs: UIViewController, GPPSignInDelegate, UITableViewDataSource, UITableViewDelegate {
    var signIn: GPPSignIn?
    var list = [String]()
    var tableView = UITableView()
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Club")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for club: NSManagedObject in results!{
                if !list.contains(club.valueForKey("name") as! String){
                    list.append(club.valueForKey("name") as! String)
                }
            }
        } catch {
            print("whoops")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Club")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for club: NSManagedObject in results!{
                    list.append(club.valueForKey("name") as! String)
            }
        } catch {
            print("whoops")
        }
        tableView = UITableView()
        tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.addSubview(tableView)
        //Alert Message... Club President?
        let alert = UIAlertView(title: "Login", message: "Are you a club president?", delegate: self, cancelButtonTitle: "No")
        alert.title = "Login"
        alert.message = "Are you a club president?"
        //alert.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
        alert.cancelButtonIndex = 0
        alert.addButtonWithTitle("Yes")
        alert.show()

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            //blank table
            print("")
        default:
            signIn = GPPSignIn.sharedInstance()
            signIn?.shouldFetchGooglePlusUser = true
            signIn?.clientID = "679790092535-jkfc6c4tkm93a1vbgnqc0p2ppdbe61fo.apps.googleusercontent.com"
            signIn?.scopes = [kGTLAuthScopePlusUserinfoEmail]
            signIn?.shouldFetchGoogleUserEmail = true
            signIn?.delegate = self
            signIn?.authenticate()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        let email: String = auth.userEmail
        let endpoint = NSURL(string: "https://dl.dropboxusercontent.com/u/17375564/pClubs.json")
        let data = NSData(contentsOfURL: endpoint!)
        do{
            let json: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
            let items = json["clubs"] as! NSArray
            for item in items {
                let pName: String = item["presName"] as! String
                let pClub: String = item["presClubs"] as! String
                if(pName == email){
                   list+=[pClub+" (Admin)"]
                }
            }
        } catch {
            print("broken link")
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    // TO ADD
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(list[indexPath.row].hasSuffix("(Admin)")){
            self.performSegueWithIdentifier("showSendPush", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSendPush" {
            if let destinationVC = segue.destinationViewController as? sendPush{
                let row = self.tableView.indexPathForSelectedRow?.row
                destinationVC.text1 = list[row!]
            }
        }
    }

    

    
    
    
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(list[indexPath.row].hasSuffix("(Admin)")) {
            return false
        }
        else{
            return true
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the club object the user is trying to delete
            let toDelete = list[indexPath.row]
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
            // Refresh the table view to indicate that it's deleted
            for i in 0..<list.count {
                if list[i] == toDelete{
                    list.removeAtIndex(i)
                    break
                }
            }
            
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.removeObject(toDelete.stringByReplacingOccurrencesOfString(" ", withString: ""), forKey: "channels")
            currentInstallation.saveInBackground()
            self.tableView.reloadData()
            
            // Tell the table view to animate out that row
            //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    func didDisconnectWithError(error: NSError?){
        
    }
    

    //
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
