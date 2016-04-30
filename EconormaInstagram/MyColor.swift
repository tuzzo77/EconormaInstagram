//
//  MyColor.swift
//  EconormaInstagram
//
//  Created by Alessandro Mattiuzzi MacPro on 21/04/16.
//  Copyright © 2016 Alessandro Mattiuzzi MacPro. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}