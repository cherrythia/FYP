//
//  ViewController.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 18/1/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.

import UIKit
import CoreData

class SpringViewController_Table : UITableViewController, UITableViewDataSource {

    @IBOutlet weak var addButton: UIBarButtonItem!
    var springVar : Array <AnyObject> = []
    var forceArray : [Float] = []
    var stiffness : [Float] = []
    
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return springVar.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        var data : NSManagedObject = springVar[indexPath.row] as! NSManagedObject
        
        cell!.textLabel!.text = "Spring \(indexPath.row + 1)"
        cell!.textLabel!.font = UIFont.boldSystemFontOfSize(17)
        
        var force : Float = data.valueForKey("force") as! Float
        var stiffness : Float = data.valueForKey("stiffness") as! Float
        
        cell!.detailTextLabel!.text = "Force = \(force)N \t\t Stiffness = \(stiffness)N/m"
        cell!.detailTextLabel!.textColor = UIColor .darkGrayColor()
        
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    // Negative of [Summation of forces] for calculation later
    func forceAtWall() {
        
        forceArray.append(0)
        
        for (var index = 0; index < springVar.count ; ++index )//arrange force to array
        {
            var selectedItem : NSManagedObject = springVar[index] as! NSManagedObject       //first index is 1 not zero
            var tempForce : Float = selectedItem.valueForKey("force") as! Float
            
            forceArray.append(tempForce)
        }
        
        for index in 0...(springVar.count){
            forceArray[0] += forceArray[index]
        }
        
        forceArray[0] = -(forceArray[0])
        
   }
    
    func arrayOfStiff() {
        
        for var index = 0 ; index < springVar.count ; ++index
        {
            var selectedItem : NSManagedObject = springVar[index] as! NSManagedObject
            var tempStiffness : Float = selectedItem.valueForKey("stiffness") as! Float
            
            stiffness.append(tempStiffness)
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Springs' Variables "
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "SpringVariables")
        
        springVar = context.executeFetchRequest(freq, error: nil)!
        
        if(isCheckedGlobal == true){
            addButton.enabled = false
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Add(sender: AnyObject) {
        self.performSegueWithIdentifier("addSpring", sender: sender)
    }
    
    @IBAction func solve_Pressed(sender: AnyObject) {
        
        self.forceAtWall()
        self.arrayOfStiff()
        self.performSegueWithIdentifier("Solve", sender: sender)
    }
    
    //Shake to reset
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        
        if(event.subtype == UIEventSubtype.MotionShake){

            let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context : NSManagedObjectContext = appDel.managedObjectContext!
            
            var error : NSError?
            for object in springVar as! [NSManagedObject] {
                    context.deleteObject(object)
            }
            
            if !context.save(&error){
                print("save failed : \(error)")
            }
            
            springVar.removeAll(keepCapacity: true)
            isCheckedGlobal = false
            addButton.enabled = true
            self.tableView.reloadData()
            self.viewDidLoad()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(springVar.count) * 45.0) - 45.0 - 64.0)
        
        let oneCell = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: footerHeight))
        
        /************************************** View of UIView ************************************************/
        
        return oneCell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(springVar.count) * 45.0) - 45.0 - 64.0)

        return footerHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detail", sender:self)
    }
    
    override func prepareForSegue ( segue: UIStoryboardSegue, sender: AnyObject!) {
        
        //solve button
        if (segue.identifier == "Solve") {
            var svcViewController_Results = segue.destinationViewController as! SpringViewController_Results
            
            svcViewController_Results.forceView2 = self.forceArray
            svcViewController_Results.stiffView2 = self.stiffness
            svcViewController_Results.springCount = springVar.count
        }
        
        //detail display onto next view
        if (segue.identifier == "detail") {
        
            var selectedItem : NSManagedObject = springVar[self.tableView.indexPathForSelectedRow()!.row] as! NSManagedObject
            
            let insertSpringVar : SpringInsertVariables = segue.destinationViewController as! SpringInsertVariables
            
            var tempForce : Float = selectedItem.valueForKey("force") as! Float
            var tempStiff : Float = selectedItem.valueForKey("stiffness") as! Float
            
            var globalChecked : Bool = selectedItem.valueForKey("globalChecked") as! Bool
            var arrowChecked : Bool = selectedItem.valueForKey("arrowChecked") as! Bool
            
            insertSpringVar.tempForce = tempForce
            insertSpringVar.tempStiffness = tempStiff
            insertSpringVar.tempMangObj = selectedItem
            insertSpringVar.tempChcekedGlobal = globalChecked
            insertSpringVar.tempCount = self.tableView.indexPathForSelectedRow()!.row
            insertSpringVar.tempArrow = arrowChecked
        }
        
        //add button
        if(segue.identifier == "addSpring"){
            
            let insertSpringVar : SpringInsertVariables = segue.destinationViewController as! SpringInsertVariables
            
            insertSpringVar.tempCount = springVar.count
        }
        
    }
    
    @IBAction func unwindSpringInserttoTable (segue: UIStoryboardSegue){
        self.tableView.reloadData()
        
        if(isCheckedGlobal == true) {
            addButton.enabled = false
        }
    }

}

