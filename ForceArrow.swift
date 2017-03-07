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
        
        self.addTarget(self, action: #selector(ForceArrow.arrowbuttonClicked(_:)), for: UIControlEvents.touchUpInside)
        
        if(ArrowGlobal == false)
        {
         setImage(rightArrowImage, for: UIControlState())
        }
        else
        {
            setImage(leftArrowImage, for: UIControlState())
        }
        
//        ArrowGlobal = false
    }
    
    func arrowbuttonClicked(_ sender: UIButton) {
        
        print(ArrowGlobal)
        
        if(ArrowGlobal == true) {
            self.setImage(leftArrowImage, for: UIControlState())
        }
        else{
            self.setImage(rightArrowImage, for: UIControlState())
        }
    }
}
