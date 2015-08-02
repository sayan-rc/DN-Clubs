//
//  addClub.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 6/18/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit
import CoreData

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
            var error: NSError?
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        }
        
        
        
        
      
        
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
