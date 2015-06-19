//
//  addClub.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 6/18/15.
//  Copyright © 2015 Nighthackers. All rights reserved.
//

import UIKit

class addClub: UIViewController {
    @IBOutlet var topBar: UINavigationBar!
    @IBOutlet var clubDescription: UITextView!
    @IBOutlet var barTitle: UINavigationItem!
    var text1 = "Club Name"
    var text2 = "Hello"
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        barTitle.title = text1
        clubDescription.text = text2
    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func add(sender: AnyObject) {
        print("Add Club!")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
