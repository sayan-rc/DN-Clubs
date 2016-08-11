//
//  ClubGrid.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/24/16.
//  Copyright © 2016 Nighthackers. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import AssetsLibrary
import CoreData
import FirebaseInstanceID
import FirebaseMessaging
import Firebase


class ClubGrid: UIViewController, GPPSignInDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var signIn: GPPSignIn?
    var list = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        list = [String]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Club")
        do {
            var results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            for club: NSManagedObject in results!{
                if !list.contains(club.value(forKey: "name") as! String){
                    list.append(club.value(forKey: "name") as! String)
                }
            }
        } catch {
            print("whoops")
        }
        list.sort()
        collectionView.reloadData()
    }
    
    func finished(withAuth auth: GTMOAuth2Authentication!, error: Error!) {
        let email: String = auth.userEmail
        let endpoint = NSURL(string: "https://dl.dropboxusercontent.com/u/17375564/pClubs.json")
        let data = NSData(contentsOf: endpoint! as URL)
        do{
            let json: NSDictionary = try (JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
            let items = json["clubs"] as! NSArray
            for item in items {
                let pName: String = item.object(forKey: "presName") as! String
                let pClub: String = item.object(forKey: "presClubs") as! String
                if(pName == email){
                    list+=[pClub+" (Admin)"]
                }
            }
        } catch {
            print("broken link")
        }
        collectionView.reloadData()
    }
    
    
    

    @IBAction func googleLogin(_ sender: AnyObject) {
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = "679790092535-jkfc6c4tkm93a1vbgnqc0p2ppdbe61fo.apps.googleusercontent.com"
        signIn?.scopes = [kGTLAuthScopePlusUserinfoEmail]
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.delegate = self
        signIn?.authenticate()
    }
 

    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Club")
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            for club: NSManagedObject in results!{
                list.append(club.value(forKey: "name") as! String)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath as IndexPath) as! TileCollectionViewCell
        cell.text.text = list[indexPath.row]
        cell.letter.text = list[indexPath.row].substring(to: list[indexPath.row].index(after: list[indexPath.row].startIndex))
        let colorsArray = [
            UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0), //teal color
            UIColor(red: 222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0), //yellow color
            UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0), //red color
            UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0), //orange color
            UIColor(red: 77/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1.0), //dark color
            UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0), //purple color
            UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), //green color
        ]
        let rc = colorsArray[indexPath.row%7]
        cell.color.backgroundColor = rc
        cell.letter.textColor = rc
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(list[indexPath.row].hasSuffix("(Admin)")){
            self.performSegue(withIdentifier: "showSendPush", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "showClubMessages", sender: self)
        }

    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.width/2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSendPush" {
            if let destinationVC = segue.destination as? sendPush{
                let row = collectionView.indexPathsForSelectedItems![0].row
                destinationVC.text1 = list[row]
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
            }
        }
        else{
            if let destinationVC = segue.destination as? clubMessages{
                let row = collectionView.indexPathsForSelectedItems![0].row
                destinationVC.text1 = list[row]
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





