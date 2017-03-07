//
//  TableViewController2.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 7/2/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit

class BarViewController_Results: UITableViewController {

    var forceBarWall2 = [Float]()
    var length2 = [Float]()
    var youngMod2 = [Float]()
    var diamter2 = [Float]()
    var forceB1 : Float = 0.0
    var forceB2 : Float = 0.0
    var barD : [Float] = []
    var barCount : Int = 0
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake){
            self.performSegue(withIdentifier: "reset", sender: self)
            
            barCount = 0
            isCheckedGlobal = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("BarViewController2")
        print(self.length2)
        print(self.youngMod2)
        print(self.diamter2)
        print(self.forceBarWall2)
        
        if(isCheckedGlobal && barCount != 0) {
            (forceB1, forceB2, barD) =  Bar_Calculate_Boundary(&forceBarWall2, l: length2, e: youngMod2, d: diamter2, n: barCount)
            
            let alert = UIAlertController(title: "Boundary Force", message: "Force at left wall is \(forceB1) (N) \nForce at right wall is \(forceB2) (N)", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .default) {(ACTION: UIAlertAction!) -> Void in}
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        else {
            
            print("BarViewController2")
            print(self.length2)
            print(self.youngMod2)
            print(self.diamter2)
            print(self.forceBarWall2)

            barD = Bar_Calculate(forceBarWall2, l: length2, e: youngMod2, d: diamter2, n: barCount)
            self.forceB1 = forceBarWall2[0]
            self.forceB2 = forceBarWall2[barCount-1]
            
            let alert = UIAlertController(title: "Boundary Force", message: "Force at left wall is \(forceB1) (N)", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .default) {(ACTION: UIAlertAction!) -> Void in}
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barD.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath) 
        let item = barD[indexPath.row]
        cell.textLabel?.text = "Displacement at node \(indexPath.row) = \(item.description)"
        
        return cell
    }

}
