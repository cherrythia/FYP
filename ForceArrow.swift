//
//  ForceArrow.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 7/3/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit

var ArrowGlobal : Bool = false

class ForceArrow: UIButton {

    let rightArrowImage = UIImage(named: "ForceRight")
    let leftArrowImage = UIImage(named: "ForceLeft")
    
    override func awakeFromNib() {
        
        self.addTarget(self, action: "arrowbuttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if(ArrowGlobal == false)
        {
         setImage(rightArrowImage, forState: .Normal)
        }
        else
        {
            setImage(leftArrowImage, forState: .Normal)
        }
        
//        ArrowGlobal = false
    }
    
    func arrowbuttonClicked(sender: UIButton) {
        
        println(ArrowGlobal)
        
        if(ArrowGlobal == true) {
            self.setImage(leftArrowImage, forState: .Normal)
        }
        else{
            self.setImage(rightArrowImage, forState: .Normal)
        }
    }
}
