//
//  addClub.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 6/18/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit
import CoreData
import FirebaseInstanceID
import FirebaseMessaging
import Firebase

class addClub: UIViewController {
    @IBOutlet var topBar: UINavigationBar!
    @IBOutlet var clubDescription: UITextView!
    @IBOutlet var barTitle: UINavigationItem!
    var text1 = "Club Name"
    var text2 = "Hello"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barTitle.title = text1
        clubDescription.text = text2
        self.topBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.topBar.shadowImage = UIImage()
        self.topBar.isTranslucent = true
        self.topBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
    }

    @IBAction func addClubForUser(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Club")
        var alreadyAdded = false
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let results = fetchedResults
            for club: NSManagedObject in results!{
                if club.value(forKey: "name") as? String == text1{
                    alreadyAdded = true
                }
            }
        } catch {
            print("whoops")
        }
        if !alreadyAdded{
            let entity =  NSEntityDescription.entity(forEntityName: "Club", in: managedContext)
            let club = NSManagedObject(entity: entity!, insertInto:managedContext)
            club.setValue(text1, forKey: "name")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\(text1.replacingOccurrences(of: " ", with: ""))")
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func hideAddClub(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
