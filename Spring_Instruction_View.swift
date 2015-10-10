//
//  spring_Instruction_View.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 3/3/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit

class Spring_Instruction_View: UIViewController {

    let springSeries = UIImage (named: "spring_Series.jpg")
    
    @IBOutlet weak var springSeriesImage: UIImageView!
    @IBOutlet weak var springInstructions: UILabel!
    @IBAction func calculateSpring(sender: AnyObject) {}
    
    override func viewDidLoad() {
        springSeriesImage.image = springSeries
    }
    
    // MARK: Fade-in Animation Method
    override func viewWillAppear(animated: Bool) {
        springInstructions.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(2.0, delay: 0.2, options: .CurveEaseOut, animations: {
            self.springInstructions.alpha = 1
            }, completion: nil)
    }
}
