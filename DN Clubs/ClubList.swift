//
//  Notifications.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/30/15.
//  Copyright (c) 2015 Nighthackers. All rights reserved.
//

import UIKit

class ClubList: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    var list:[(clubName: String, description: String)] = []
    var filteredList:[(clubName: String, description: String)]!
    var searchController: UISearchController!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let endpoint = NSURL(string: "https://dl.dropboxusercontent.com/u/17375564/clubs.json")
        let data = NSData(contentsOf: endpoint! as URL)
        do{
            let json: NSDictionary = try (JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
            let items = json["clubs"] as! NSArray
            for item in items {
                let name: String = item["clubName"] as! String
                let desc: String = item["description"] as! String
                list+=[(clubName: name, description: desc)]
            }
        } catch {
            print("broken link")
        }
        list.sort { (a: (clubName1: String, description1: String), b: (clubName2: String, description2: String)) -> Bool in
            a.clubName1 == b.clubName2 ? a.description1 < b.description2 : a.clubName1 < b.clubName2
        }
        tableView.dataSource = self
        filteredList = list
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Do any additional setup after loading the view.
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Club", for: indexPath as IndexPath) as UITableViewCell
        cell.textLabel?.text = filteredList[indexPath.row].clubName
        cell.detailTextLabel?.text = filteredList[indexPath.row].description
        return cell
    }
    
    func updateSearchResults(for: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased()
        if (searchText!.isEmpty){
            filteredList = list
        }
        else{
            filteredList = list.filter({ (dataString: (clubName: String, description: String)) -> Bool in
                return dataString.clubName.lowercased().range(of: searchText!) != nil
            })
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddClub" {
            if let destinationVC = segue.destination as? addClub{
                let row = self.tableView.indexPathForSelectedRow?.row
                let imageOfUnderlyingView = self.view.convertViewToImage()
                let backView = UIImageView(frame: self.view.frame)
                backView.image = imageOfUnderlyingView
                backView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
                let blurView = UIVisualEffectView(effect: lightBlur)
                blurView.frame =  backView.bounds
                backView.addSubview(blurView)
                destinationVC.view.addSubview(backView)
                destinationVC.view.sendSubview(toBack: backView)
                destinationVC.text1 = filteredList[row!].clubName
                destinationVC.text2 = filteredList[row!].description
            }
        }
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
