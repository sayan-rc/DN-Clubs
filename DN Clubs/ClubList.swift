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

        // Do any additional setup after loading the view.
        //hui
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
