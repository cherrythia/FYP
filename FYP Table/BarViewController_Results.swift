//
//  TableViewController2.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 7/2/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit

class BarViewController_Results: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var forceBarWall2 = [Float]()
    var length2 = [Float]()
    var youngMod2 = [Float]()
    var diamter2 = [Float]()
    var forceB1 : Float = 0.0
    var forceB2 : Float = 0.0
    var barD : [Float] = []
    var barCount : Int = 0
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if(event.subtype == UIEventSubtype.MotionShake){
            self.performSegueWithIdentifier("reset", sender: self)
            
            barCount = 0
            isCheckedGlobal = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println("BarViewController2")
        println(self.length2)
        println(self.youngMod2)
        println(self.diamter2)
        println(self.forceBarWall2)
        
        if(isCheckedGlobal && barCount != 0) {
            (forceB1, forceB2, barD) =  Bar_Calculate_Boundary(&forceBarWall2, length2, youngMod2, diamter2, barCount)
            
            let alert = UIAlertController(title: "Boundary Force", message: "Force at left wall is \(forceB1) (N) \nForce at right wall is \(forceB2) (N)", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .Default) {(ACTION: UIAlertAction!) -> Void in}
            
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
        else {
            
            println("BarViewController2")
            println(self.length2)
            println(self.youngMod2)
            println(self.diamter2)
            println(self.forceBarWall2)

            barD = Bar_Calculate(forceBarWall2, length2, youngMod2, diamter2, barCount)
            self.forceB1 = forceBarWall2[0]
            self.forceB2 = forceBarWall2[barCount-1]
            
            let alert = UIAlertController(title: "Boundary Force", message: "Force at left wall is \(forceB1) (N)", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .Default) {(ACTION: UIAlertAction!) -> Void in}
            
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barD.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("barCell", forIndexPath: indexPath) as! UITableViewCell
        let item = barD[indexPath.row]
        cell.textLabel?.text = "Displacement at node \(indexPath.row) = \(item.description)"
        
        return cell
    }

}
