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


class FavoriteClubs: UIViewController, GPPSignInDelegate {
    var signIn: GPPSignIn?
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
            println("hello")
        default:
            signIn = GPPSignIn.sharedInstance()
            signIn?.shouldFetchGooglePlusUser = true
            signIn?.clientID = "679790092535-jkfc6c4tkm93a1vbgnqc0p2ppdbe61fo.apps.googleusercontent.com"
            signIn?.scopes = [kGTLAuthScopePlusLogin]
            signIn?.delegate = self
            signIn?.authenticate()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
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
