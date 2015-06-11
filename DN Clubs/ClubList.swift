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
        let endpoint = NSURL(string: "https://dl.dropboxusercontent.com/u/17375564/clubs.json")
        let data = NSData(contentsOfURL: endpoint!)
        do{
            let json: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
            let items = json["clubs"] as! NSArray
            for item in items {
                let name: String = item["clubName"] as! String
                let desc: String = item["description"] as! String
                list+=[(clubName: name, description: desc)]
            }
        } catch {
            print("broken link")
        }

        
        // Do any additional setup after loading the view.
        //
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("a")
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Club", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = list[indexPath.row].clubName
        cell.detailTextLabel?.text = list[indexPath.row].description
        //print("b")
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
