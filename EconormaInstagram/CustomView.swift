//
//  CustomView.swift
//  EconormaInstagram
//
//  Created by Alessandro Mattiuzzi MacPro on 22/04/16.
//  Copyright © 2016 Alessandro Mattiuzzi MacPro. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {
 
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    
    class func loadNib() -> CustomView {
        return NSBundle.mainBundle().loadNibNamed("CustomView", owner:  self, options: nil)[0] as! CustomView
    }
    
    
}