//
//  sendPush.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 8/13/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit
import Parse

class sendPush: UIViewController {

    var text1 = "ERROR"
    
    @IBOutlet var topBar: UINavigationBar!
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var message: UITextView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topBar.topItem?.title = text1
        message.layer.borderColor = UIColor.lightGrayColor().CGColor
        message.layer.borderWidth = 1
        message.layer.cornerRadius = 5.0
    }
    
    
    @IBAction func send(sender: AnyObject) {
        let short = text1.substringToIndex(text1.endIndex.predecessor().predecessor().predecessor().predecessor().predecessor().predecessor().predecessor().predecessor())
        let final = short.stringByReplacingOccurrencesOfString(" ", withString: "")
        let push = PFPush()
        let data = [
            "alert" : short+": "+message.text,
            "badge" : "Increment",
            "content-available" : 1,
        ]
        push.setData(data as [NSObject : AnyObject])
        push.setChannel(final)
        push.sendPushInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
