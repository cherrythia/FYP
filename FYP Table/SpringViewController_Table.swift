//
//  ViewController.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 18/1/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.

import UIKit
import CoreData

class SpringViewController_Table : UITableViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    var springVar : Array <AnyObject> = []
    var forceArray : [Float] = []
    var stiffness : [Float] = []
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return springVar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        var data : NSManagedObject = springVar[indexPath.row] as! NSManagedObject
        
        cell!.textLabel!.text = "Spring \(indexPath.row + 1)"
        cell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        
        var force : Float = data.value(forKey: "force") as! Float
        var stiffness : Float = data.value(forKey: "stiffness") as! Float
        
        cell!.detailTextLabel!.text = "Force = \(force)N \t\t Stiffness = \(stiffness)N/m"
        cell!.detailTextLabel!.textColor = UIColor .darkGray
        
        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    
    // Negative of [Summation of forces] for calculation later
    func forceAtWall() {
        
        forceArray.append(0)
        
        //arrange force to array
        
        for index in 0..<springVar.count {
            let selectedItem : NSManagedObject = springVar[index] as! NSManagedObject       //first index is 1 not zero
            let tempForce : Float = selectedItem.value(forKey: "force") as! Float
            
            forceArray.append(tempForce)
        }
        
        for index in 0...(springVar.count){
            forceArray[0] += forceArray[index]
        }
        
        forceArray[0] = -(forceArray[0])
        
   }
    
    func arrayOfStiff() {
        
        for index in 0..<springVar.count
        {
            let selectedItem : NSManagedObject = springVar[index] as! NSManagedObject
            let tempStiffness : Float = selectedItem.value(forKey: "stiffness") as! Float
            
            stiffness.append(tempStiffness)
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Springs' Variables "
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest<NSFetchRequestResult>(entityName: "SpringVariables")
        
        do {
            try springVar = context.fetch(freq)
        } catch  {
            
        }
        //springVar = context.executeFetchRequest(freq)!
        
        if(isCheckedGlobal == true){
            addButton.isEnabled = false
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Add(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "addSpring", sender: sender)
    }
    
    @IBAction func solve_Pressed(_ sender: AnyObject) {
        
        self.forceAtWall()
        self.arrayOfStiff()
        self.performSegue(withIdentifier: "Solve", sender: sender)
    }
    
    //Shake to reset
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if(event?.subtype == UIEventSubtype.motionShake){

            let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context : NSManagedObjectContext = appDel.managedObjectContext!
            
            var error : NSError?
            for object in springVar as! [NSManagedObject] {
                    context.delete(object)
            }
            
            do {
                try context.save()
            } catch {
                print("save failed : \(error)")
            }
            
            springVar.removeAll(keepingCapacity: true)
            isCheckedGlobal = false
            addButton.isEnabled = true
            self.tableView.reloadData()
            self.viewDidLoad()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(springVar.count) * 45.0) - 45.0 - 64.0)
        
        let oneCell = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: footerHeight))
        
        /************************************** View of UIView ************************************************/
        
        return oneCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(springVar.count) * 45.0) - 45.0 - 64.0)

        return footerHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender:self)
    }
    
    override func prepare ( for segue: UIStoryboardSegue, sender: Any!) {
        
        //solve button
        if (segue.identifier == "Solve") {
            let svcViewController_Results = segue.destination as! SpringViewController_Results
            
            svcViewController_Results.forceView2 = self.forceArray
            svcViewController_Results.stiffView2 = self.stiffness
            svcViewController_Results.springCount = springVar.count
        }
        
        //detail display onto next view
        if (segue.identifier == "detail") {
        
            let selectedItem : NSManagedObject = springVar[self.tableView.indexPathForSelectedRow!.row] as! NSManagedObject
            
            let insertSpringVar : SpringInsertVariables = segue.destination as! SpringInsertVariables
            
            let tempForce : Float = selectedItem.value(forKey: "force") as! Float
            let tempStiff : Float = selectedItem.value(forKey: "stiffness") as! Float
            
            let globalChecked : Bool = selectedItem.value(forKey: "globalChecked") as! Bool
            let arrowChecked : Bool = selectedItem.value(forKey: "arrowChecked") as! Bool
            
            insertSpringVar.tempForce = tempForce
            insertSpringVar.tempStiffness = tempStiff
            insertSpringVar.tempMangObj = selectedItem
            insertSpringVar.tempChcekedGlobal = globalChecked
            insertSpringVar.tempCount = self.tableView.indexPathForSelectedRow!.row
            insertSpringVar.tempArrow = arrowChecked
            
            if(self.tableView.indexPathForSelectedRow!.row != (springVar.count-1)){
                let tempCanCheckCheckedBox : Bool = false
                insertSpringVar.tempCanCheckCheckedBox = tempCanCheckCheckedBox
            }
            else{
                let tempCanCheckCheckedBox : Bool = true
                insertSpringVar.tempCanCheckCheckedBox = tempCanCheckCheckedBox
            }
        }
        
        //add button
        if(segue.identifier == "addSpring"){
            
            let insertSpringVar : SpringInsertVariables = segue.destination as! SpringInsertVariables
            
            insertSpringVar.tempCount = springVar.count
        }
        
    }

}

