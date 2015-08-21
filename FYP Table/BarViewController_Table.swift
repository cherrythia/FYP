//
//  TableViewController.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 7/2/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit
import CoreData

class BarViewController_Table: UITableViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var barVar : Array <AnyObject> = []
    
    //These arrays are to be passed to cal function later
    var areaArray : [Float] = []
    var youngModArray : [Float] = []
    var lengthArray : [Float] = []
    var forceBarArray : [Float] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bars' Variables"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "barCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName : "BarVariables")
        
        barVar = context.executeFetchRequest(freq, error: nil)!
        
        if(isCheckedGlobal == true){
            addBarButton.enabled = false
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func canBecomeFirstResponder() -> Bool{
        return true
    }
    

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        
        if(event.subtype == UIEventSubtype.MotionShake){
            
            let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context : NSManagedObjectContext = appDel.managedObjectContext!
            var error : NSError?
            
            for object in barVar as! [NSManagedObject] {
                context.deleteObject(object)
            }
            
            if !context.save(&error){
                print("save failed : \(error)")
            }
            barVar.removeAll(keepCapacity: true)
            isCheckedGlobal = false
            addBarButton.enabled = true
            self.tableView.reloadData()
            self.viewDidLoad()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(barVar.count) * 45.0) -  44.0 - 0.0 - 64.0) //check value if is okay, because SpringViewController - 64.0
        
        let footerCell = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerHeight))
        /********************************** View of footerCell edit here***********************************/
        return footerCell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
         let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(barVar.count) * 45.0) -  44.0 - 0.0 - 64.0 ) //check value if is okay, because SpringViewController - 64.0
        
        return footerHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detail", sender: self)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barVar.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "barCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        
        var data : NSManagedObject = barVar[indexPath.row] as! NSManagedObject
        
        cell!.textLabel!.text = "Bar \(indexPath.row + 1)"
        cell!.textLabel!.font = UIFont.boldSystemFontOfSize(17)
        
        var force : Float = data.valueForKey("force") as! Float
        var area : Float = data.valueForKey("area") as! Float
        var length : Float = data.valueForKey("length") as! Float
        var youngMod : Float = data.valueForKey("youngMod") as! Float
        
        cell!.detailTextLabel!.text = "Force = \(force)\tArea =\(area)\tLength =\(length)\tYoung Mod =\(youngMod)"
        cell!.detailTextLabel!.textColor = UIColor .darkGrayColor()
        cell!.detailTextLabel!.font = UIFont.systemFontOfSize(9)
        
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    //Prepare arrays to be passed into calculations
    //ForceArray + Negative at the wall for calculation later

    func arrayPrepareForCalculation () {
        forceBarArray.append(0)
        
        for (var index = 0; index < barVar.count ; ++index){
            var selectedItem : NSManagedObject = barVar[index] as! NSManagedObject
            var tempForce : Float = selectedItem.valueForKey("force") as! Float
            var tempArea : Float = selectedItem.valueForKey("area") as! Float
            var tempLength : Float = selectedItem.valueForKey("length") as! Float
            var tempMod : Float = selectedItem.valueForKey("youngMod") as! Float
            
            forceBarArray.append(tempForce)
            areaArray.append(tempArea)
            lengthArray.append(tempLength)
            youngModArray.append(tempMod)
            
            print(forceBarArray)
            print(areaArray)
            print(lengthArray)
            print(youngModArray)
        }
        
        for index in 0 ... (barVar.count){              //Negative Value for forceAtWall here
            forceBarArray[0] += forceBarArray[index]
        }
        forceBarArray[0] = -(forceBarArray[0])
    }
    
    @IBAction func addBar(sender: AnyObject) {
        self.performSegueWithIdentifier("addBar", sender: sender)
    }

    @IBAction func solve_PressedBar(sender: AnyObject) {
        self.performSegueWithIdentifier("SolveBar", sender: sender)
    }
    
    override func prepareForSegue ( segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "addBar"){
            let svcBarInsertVariables = segue.destinationViewController as! BarInsertVariables
            
            svcBarInsertVariables.tempCount = barVar.count
        }
        
        if (segue.identifier == "SolveBar") {
            
            arrayPrepareForCalculation()
            let segueToBarResults = segue.destinationViewController as! BarViewController_Results
            
            segueToBarResults.forceBarWall2 = forceBarArray
            segueToBarResults.length2 = lengthArray
            segueToBarResults.youngMod2 = youngModArray
            segueToBarResults.diamter2 = areaArray
            segueToBarResults.barCount = barVar.count
        }
        
        if (segue.identifier == "detail"){
            let insertBarVarViewController : BarInsertVariables = segue.destinationViewController as! BarInsertVariables

            var selectedItem : NSManagedObject = barVar[self.tableView.indexPathForSelectedRow()!.row] as! NSManagedObject
            var tempForce : Float = selectedItem.valueForKey("force") as! Float
            var tempArea : Float = selectedItem.valueForKey("area") as! Float
            var tempLength : Float = selectedItem.valueForKey("length") as! Float
            var tempMod : Float = selectedItem.valueForKey("youngMod") as! Float
            
            insertBarVarViewController.tempForce = tempForce
            insertBarVarViewController.tempArea = tempArea
            insertBarVarViewController.tempLength = tempLength
            insertBarVarViewController.tempMod = tempMod
            insertBarVarViewController.tempCount = self.tableView.indexPathForSelectedRow()!.row
            insertBarVarViewController.tempMangObj = selectedItem
            
            if(self.tableView.indexPathForSelectedRow()!.row != (barVar.count - 1)){
                var tempCanCheckCheckedBox : Bool = false
                insertBarVarViewController.tempCanCheckCheckedBox = tempCanCheckCheckedBox
            }
            else{
                var tempCanCheckCheckedBox : Bool = true
                insertBarVarViewController.tempCanCheckCheckedBox = tempCanCheckCheckedBox
            }
        }
            
    }
}


