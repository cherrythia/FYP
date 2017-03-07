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
        self.addTarget(self, action: #selector(CheckBox2.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        setImage(unCheckedImage, for: UIControlState())
    }
    
    func buttonClicked(_ sender:UIButton) {
        
        print(isCheckedGlobal)
        
        if (isCheckedGlobal == true) {
            self.setImage(checkedImage, for: UIControlState())
        }
        else{
            self.setImage(unCheckedImage, for: UIControlState())
        }
    }
}
