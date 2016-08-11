//
//  sendPush.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 8/13/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit
import Parse
import CloudKit

class sendPush: UIViewController {

    var text1 = "ERROR"
    
    @IBAction func sendMessage(sender: AnyObject) {
        let short = text1.substring(to: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.endIndex)))))))))
        let final = short.replacingOccurrences(of: " ", with: "")
        let push = PFPush()
        let data = [
            "alert" : short+": "+message.text,
            "badge" : "Increment",
            "content-available" : 1,
            "sound" : "default",
            ]
        push.setData(data as [NSObject : AnyObject])
        push.setChannel(final)
        push.sendInBackground()
        
        let container = CKContainer.default()
        let publicData = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Notification")
        record.setValue(final, forKey: "Club")
        record.setValue(short+": "+message.text, forKey: "Message")
        publicData.save(record, completionHandler: { record, error in
            if error != nil {
                print(error)
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var topBar: UINavigationBar!
    @IBAction func goBack(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var message: UITextView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topBar.topItem?.title = text1
        message.layer.borderWidth = 0
        message.layer.cornerRadius = 5.0
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
