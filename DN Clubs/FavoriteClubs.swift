//
//  FavoriteClubs.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/30/15.
//  Copyright (c) 2015 Nighthackers. All rights reserved.
//

import UIKit

//G+

import AddressBook
import MediaPlayer
import CoreMotion
import CoreLocation
import AssetsLibrary


class FavoriteClubs: UIViewController, GPPSignInDelegate, UITableViewDataSource {
    var signIn: GPPSignIn?
    var list:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
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
            print("hello")
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
                    list+=[pClub]
                }
            }
        } catch {
            print("broken link")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list.count)
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = list[indexPath.row]
        print("2")
        return cell
       
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
