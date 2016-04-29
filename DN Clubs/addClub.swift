//
//  addClub.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 6/18/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit
import CoreData
import Parse

class addClub: UIViewController {
    @IBOutlet var topBar: UINavigationBar!
    @IBOutlet var clubDescription: UITextView!
    @IBOutlet var barTitle: UINavigationItem!
    var text1 = "Club Name"
    var text2 = "Hello"
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        barTitle.title = text1
        clubDescription.text = text2
        self.topBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.topBar.shadowImage = UIImage()
        self.topBar.translucent = true
        self.topBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]

    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func add(sender: AnyObject) {
        //print("Add Club!")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Club")
        var alreadyAdded = false
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for club: NSManagedObject in results!{
                if club.valueForKey("name") as? String == text1{
                    alreadyAdded = true
                }
            }
        } catch {
            print("whoops")
        }
        if !alreadyAdded{
            let entity =  NSEntityDescription.entityForName("Club", inManagedObjectContext: managedContext)
            let club = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            club.setValue(text1, forKey: "name")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.addUniqueObject(text1.stringByReplacingOccurrencesOfString(" ", withString: ""), forKey: "channels")
            currentInstallation.saveInBackground()
            let subscribedChannels = PFInstallation.currentInstallation().channels
        }
        

        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
