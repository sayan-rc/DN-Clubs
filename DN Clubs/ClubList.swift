//
//  Notifications.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/30/15.
//  Copyright (c) 2015 Nighthackers. All rights reserved.
//

import UIKit

class ClubList: UIViewController, UITableViewDataSource {
    var list:[(clubName: String, description: String)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        var endpoint = NSURL(string: "https://dl.dropboxusercontent.com/u/17375564/clubs.json")
        var data = NSData(contentsOfURL: endpoint!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let items = json["clubs"] as? NSArray {
                for item in items {
                    var name: String = item["clubName"] as! String
                    var desc: String = item["description"] as! String
                    list+=[(clubName: name, description: desc)]
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Club", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = list[indexPath.row].clubName
        cell.detailTextLabel?.text = list[indexPath.row].description
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
