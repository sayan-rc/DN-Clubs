//
//  ClubGrid.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/24/16.
//  Copyright © 2016 Nighthackers. All rights reserved.
//

import UIKit
import Parse
import AddressBook
import MediaPlayer
import CoreMotion
import CoreLocation
import AssetsLibrary
import CoreData


class ClubGrid: UIViewController, GPPSignInDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var signIn: GPPSignIn?
    var list = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        list = [String]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Club")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            var results = fetchedResults!.sort({ $0.valueForKey("name")!.compare($1.valueForKey("name") as! String!) == NSComparisonResult.OrderedAscending })
    
            for club: NSManagedObject in results{
                if !list.contains(club.valueForKey("name") as! String){
                    list.append(club.valueForKey("name") as! String)
                }
            }
        } catch {
            print("whoops")
        }
        list.sort()
        collectionView.reloadData()
    }
    
    
    //Handles Setup for Google Accounts Login
    @IBAction func login(sender: AnyObject) {
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = "679790092535-jkfc6c4tkm93a1vbgnqc0p2ppdbe61fo.apps.googleusercontent.com"
        signIn?.scopes = [kGTLAuthScopePlusUserinfoEmail]
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.delegate = self
        signIn?.authenticate()

    }

    
    
    //Once the account is authorized, this function gives Administrative privileges to Club Presidents according to the
    //JSON file on DropBox that holds all the club data
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        let email: String = AppDelegate.presEmail
        let endpoint = NSURL(string: "https://dl.dropboxusercontent.com/u/17375564/pClubs.json")
        let data = NSData(contentsOfURL: endpoint!)
        do{
            let json: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)! //Parses the JSON File into a dictionary for easy access to Club Names and Presidents
            let items = json["clubs"] as! NSArray
            for item in items {
                let pName: String = item["presName"] as! String
                let pClub: String = item["presClubs"] as! String
                if(pName == email){//If the Email of the User matches the Email of a Club president, the User is a president
                    list+=[pClub+" (Admin)"] //Changes the User's list of clubs names if the user is an adminsitrator/president
                    //Ex: "ClubName" -> "ClubName (Admin)"
                }
            }
        } catch {
            print("broken link")
        }
        collectionView.reloadData()


    }

    //Builds the list of clubs
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Club")
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            var results = fetchedResults!.sort({ $0.valueForKey("name")!.compare($1.valueForKey("name") as! String!) == NSComparisonResult.OrderedAscending })
            for club: NSManagedObject in results{
                list.append(club.valueForKey("name") as! String)//Adds names of clubs to the list of this user's clubs
            }
        } catch {
            print("whoops")
        }
        list.sort()
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    //This Function handles the CollectionView which is used to display the clubs in a grid
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TileCollectionViewCell", forIndexPath: indexPath) as! TileCollectionViewCell
        cell.text.text = list[indexPath.row]
        cell.letter.text = list[indexPath.row].substringToIndex(list[indexPath.row].startIndex.successor())
        let colorsArray = [
            UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0), //teal color
            UIColor(red: 222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0), //yellow color
            UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0), //red color
            UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0), //orange color
            UIColor(red: 77/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1.0), //dark color
            UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0), //purple color
            UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), //green color
        ]
        var rc = colorsArray[indexPath.row%7]
        cell.color.backgroundColor = rc //Change the Color to color RC
        cell.letter.textColor = rc
        return cell //Return the successfully built cell
    }
    
    //Sets size of the cell to be half the screen width
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width/2, collectionView.bounds.size.width/2)
    }
    
    //When the user clicks on a club, this determines if the user is shown
    //the option to send push notifications or to see club messages
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(list[indexPath.row].hasSuffix("(Admin)")){
            self.performSegueWithIdentifier("showSendPush", sender: self)
        }
        else{
            self.performSegueWithIdentifier("showClubMessages", sender: self)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSendPush" { //If the button to send push is pressed, initialize the blur background and segue
            if let destinationVC = segue.destinationViewController as? sendPush{
                let row = collectionView.indexPathsForSelectedItems()![0].row
                destinationVC.text1 = list[row]
                var imageOfUnderlyingView = self.view.convertViewToImage()
                let backView = UIImageView(frame: self.view.frame)
                backView.image = imageOfUnderlyingView
                backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
                var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
                var blurView = UIVisualEffectView(effect: lightBlur)
                blurView.frame =  backView.bounds
                backView.addSubview(blurView)
                destinationVC.view.addSubview(backView)
                destinationVC.view.sendSubviewToBack(backView)

            }
        }
        else{//If the user isn't an admin, we prepare the list of club messages with a blur background and then segue 
            if let destinationVC = segue.destinationViewController as? clubMessages{
                let row = collectionView.indexPathsForSelectedItems()![0].row
                destinationVC.text1 = list[row]
                var imageOfUnderlyingView = self.view.convertViewToImage()
                let backView = UIImageView(frame: self.view.frame)
                backView.image = imageOfUnderlyingView
                backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
                var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
                var blurView = UIVisualEffectView(effect: lightBlur)
                blurView.frame =  backView.bounds
                backView.addSubview(blurView)
                destinationVC.view.addSubview(backView)
                destinationVC.view.sendSubviewToBack(backView)
            }
        }
    }
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





