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
    @IBAction func barCalculate(_ sender: AnyObject) { }
        
    override func viewDidLoad() {
        barSeries.image = barSeriesImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barInstructions.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations: { 
            self.barInstructions.alpha = 1.0
        }, completion: nil)
    }
}
