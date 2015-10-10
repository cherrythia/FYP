//  checkbox2.swift
//  FYP Table
//  Created by Chia Wei Zheng Terry on 22/2/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.

import UIKit

var isCheckedGlobal : Bool = false

class CheckBox2: UIButton {
    
    let checkedImage = UIImage(named: "checked")
    let unCheckedImage = UIImage(named: "unchecked")
   
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        setImage(unCheckedImage, forState: .Normal)
    }
    
    func buttonClicked(sender:UIButton) {
        
        print(isCheckedGlobal, terminator: "")
        
        if (isCheckedGlobal == true) {
            self.setImage(checkedImage, forState: .Normal)
        }
        else{
            self.setImage(unCheckedImage, forState: .Normal)
        }
    }
}