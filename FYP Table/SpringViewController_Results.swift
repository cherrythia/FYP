//
//  ViewController2.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 21/1/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//TableView that shows solution after calcualation.

import UIKit

class SpringViewController_Results : UITableViewController {

    @IBOutlet var tableview2: UITableView!
    var forceView2 = [Float]()
    var stiffView2 = [Float]()
    var forceB1 : Float = 0.0
    var forceB2 : Float = 0.0
    var SpringD : [Float] = []
    var springCount : Int = 0
    
    //shake function
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake){
            print("Shaken")
            
           self.performSegue(withIdentifier: "reset", sender: self)
            
            springCount = 0
            isCheckedGlobal = false
            
        }
    }
  
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SpringD.count    }
    
    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                for: indexPath) 
            
            let item = SpringD[indexPath.row]
            
            cell.textLabel?.text = "Displacement at node \(indexPath.row ) = \(item.description)"
            
            return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(isCheckedGlobal) {
            
            (forceB1,forceB2,SpringD) = Spring_CalculateBoundary(&forceView2, s: stiffView2, n: springCount)
            
            // Alert view
            
            let alert = UIAlertController(title: "Boundary Force", message: "Force at left wall is \(forceB1) (N) \nForce at right wall is \(forceB2) (N)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(ACTION: UIAlertAction!) -> Void in}
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
            
        else {  print(forceView2)
                print(stiffView2)
                print(springCount)
            
            SpringD = spring_calculate(forceView2, s: stiffView2, n: springCount)
            self.forceB1  = forceView2[0]
            self.forceB2 = forceView2[springCount - 1]
            
            let alert = UIAlertController(title: "Boundary Force", message: "Force at left wall is \(forceB1) (N)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(ACTION: UIAlertAction!) -> Void in}
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        tableview2.dataSource = self
        tableview2.delegate = self
        tableview2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}
