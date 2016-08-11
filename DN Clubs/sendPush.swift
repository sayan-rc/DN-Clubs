//
//  sendPush.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 8/13/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit
import CloudKit

class sendPush: UIViewController {

    var text1 = "ERROR"
    
    
    @IBOutlet var topBar: UINavigationBar!
    @IBOutlet var message: UITextView!
    
    @IBAction func hideSendPush(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendNotification(_ sender: AnyObject) {
        let short = text1.substring(to: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.index(before: text1.endIndex)))))))))
        let final = short.replacingOccurrences(of: " ", with: "")
        let body = ["priority":"high", "to":"/topics/\(final)", "notification": ["title": short, "body": message.text], "content_available" : true]
        do{
            let json = try (JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted))
            let req = NSMutableURLRequest(url: URL(string:"https://fcm.googleapis.com/fcm/send")!)
            req.httpMethod = "POST"
            req.httpBody = json
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addValue("key=AIzaSyA8t5q75XVNcQ2e600PD94j5s0ibJvOLmk", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                if error != nil {
                    //Your HTTP request failed.
                    print(error?.localizedDescription)
                } else {
                    //Your HTTP request succeeded
                    print(String(data: data!, encoding: String.Encoding.utf8))
                }
                }.resume()
        } catch {
            
        }
        
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
