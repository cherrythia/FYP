//
//  bar_InstructionView.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 3/3/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit

class Bar_Instruction_View: UIViewController {
    
    let barSeriesImage = UIImage (named: "bar_series.jpg")
    
    @IBOutlet weak var barSeries: UIImageView!
    @IBOutlet weak var barInstructions: UILabel!
    @IBAction func barCalculate(sender: AnyObject) { }
        
         override func viewDidLoad() {
            
            barSeries.image = barSeriesImage
            
    }
}