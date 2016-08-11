//
//  blur.swift
//  DN Clubs
//
//  Created by Gokul Swamy on 4/24/16.
//  Copyright © 2016 Nighthackers. All rights reserved.
//

import Foundation

extension UIView {
    func convertViewToImage() -> UIImage{
        UIGraphicsBeginImageContext(self.bounds.size);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image!;
    }
}
