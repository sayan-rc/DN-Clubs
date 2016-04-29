//
//  TileCollectionViewCell.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/24/16.
//  Copyright © 2016 Nighthackers. All rights reserved.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var letter: UILabel!
    @IBOutlet var circle: UIView!
    @IBOutlet var color: UIView!
    @IBOutlet var text: UILabel!
    @IBOutlet var back: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        back.layer.cornerRadius = 5
        back.layer.shadowColor = UIColor.blackColor().CGColor
        back.layer.shadowOpacity = 0.5
        back.layer.shadowOffset = CGSizeZero
        back.layer.shadowRadius = 1
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = color.frame
        rectShape.position = color.center
        rectShape.path = UIBezierPath(roundedRect: color.bounds, byRoundingCorners: [.TopRight, .TopLeft], cornerRadii: CGSize(width: 5, height: 5)).CGPath
        color.layer.mask = rectShape
        
        circle.layoutIfNeeded()
        circle.layer.masksToBounds = false
        circle.layer.cornerRadius = circle.layer.frame.width / 2.0
        circle.clipsToBounds = true

    }
    

    
    
}
