//
//  TableViewController.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 7/2/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit
import CoreData

class BarViewController_Table: UITableViewController {
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "barCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest<NSFetchRequestResult>(entityName : "BarVariables")
        
        //barVar = context.executeFetchRequest(freq, error: nil)!
        do {
            try barVar = context.fetch(freq)
        } catch  {
            
        }
        
        
        if(isCheckedGlobal == true){
            addBarButton.isEnabled = false
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var canBecomeFirstResponder : Bool{
        return true
    }
    

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if(event?.subtype == UIEventSubtype.motionShake){
            
            let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context : NSManagedObjectContext = appDel.managedObjectContext!
            var error : NSError?
            
            for object in barVar as! [NSManagedObject] {
                context.delete(object)
            }
            
            do {
                try context.save()
            } catch  {
                print("save failed : \(error)")
            }
            
            barVar.removeAll(keepingCapacity: true)
            isCheckedGlobal = false
            addBarButton.isEnabled = true
            self.tableView.reloadData()
            self.viewDidLoad()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(barVar.count) * 45.0) -  44.0 - 0.0 - 64.0) //check value if is okay, because SpringViewController - 64.0
        
        let footerCell = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerHeight))
        /********************************** View of footerCell edit here***********************************/
        return footerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
         let footerHeight : CGFloat = (tableView.frame.size.height - (CGFloat(barVar.count) * 45.0) -  44.0 - 0.0 - 64.0 ) //check value if is okay, because SpringViewController - 64.0
        
        return footerHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barVar.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "barCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) 
        
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        var data : NSManagedObject = barVar[indexPath.row] as! NSManagedObject
        
        cell!.textLabel!.text = "Bar \(indexPath.row + 1)"
        cell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        
        var force : Float = data.value(forKey: "force") as! Float
        var area : Float = data.value(forKey: "area") as! Float
        var length : Float = data.value(forKey: "length") as! Float
        var youngMod : Float = data.value(forKey: "youngMod") as! Float
        
        cell!.detailTextLabel!.text = "Force = \(force)\tArea =\(area)\tLength =\(length)\tYoung Mod =\(youngMod)"
        cell!.detailTextLabel!.textColor = UIColor.darkGray
        cell!.detailTextLabel!.font = UIFont.systemFont(ofSize: 9)
        
        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    
    //Prepare arrays to be passed into calculations
    //ForceArray + Negative at the wall for calculation later

    func arrayPrepareForCalculation () {
        forceBarArray.append(0)
        
        for index in 0..<barVar.count {
            let selectedItem : NSManagedObject = barVar[index] as! NSManagedObject
            let tempForce : Float = selectedItem.value(forKey: "force") as! Float
            let tempArea : Float = selectedItem.value(forKey: "area") as! Float
            let tempLength : Float = selectedItem.value(forKey: "length") as! Float
            let tempMod : Float = selectedItem.value(forKey: "youngMod") as! Float
            
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
    
    @IBAction func addBar(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "addBar", sender: sender)
    }

    @IBAction func solve_PressedBar(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "SolveBar", sender: sender)
    }
    
    override func prepare ( for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "addBar"){
            let svcBarInsertVariables = segue.destination as! BarInsertVariables
            
            svcBarInsertVariables.tempCount = barVar.count
        }
        
        if (segue.identifier == "SolveBar") {
            
            arrayPrepareForCalculation()
            let segueToBarResults = segue.destination as! BarViewController_Results
            
            segueToBarResults.forceBarWall2 = forceBarArray
            segueToBarResults.length2 = lengthArray
            segueToBarResults.youngMod2 = youngModArray
            segueToBarResults.diamter2 = areaArray
            segueToBarResults.barCount = barVar.count
        }
        
        if (segue.identifier == "detail"){
            let insertBarVarViewController : BarInsertVariables = segue.destination as! BarInsertVariables

            let selectedItem : NSManagedObject = barVar[self.tableView.indexPathForSelectedRow!.row] as! NSManagedObject
            let tempForce : Float = selectedItem.value(forKey: "force") as! Float
            let tempArea : Float = selectedItem.value(forKey: "area") as! Float
            let tempLength : Float = selectedItem.value(forKey: "length") as! Float
            let tempMod : Float = selectedItem.value(forKey: "youngMod") as! Float
            
            insertBarVarViewController.tempForce = tempForce
            insertBarVarViewController.tempArea = tempArea
            insertBarVarViewController.tempLength = tempLength
            insertBarVarViewController.tempMod = tempMod
            insertBarVarViewController.tempCount = self.tableView.indexPathForSelectedRow!.row
            insertBarVarViewController.tempMangObj = selectedItem
            
            if(self.tableView.indexPathForSelectedRow!.row != (barVar.count - 1)){
                let tempCanCheckCheckedBox : Bool = false
                insertBarVarViewController.tempCanCheckCheckedBox = tempCanCheckCheckedBox
            }
            else{
                let tempCanCheckCheckedBox : Bool = true
                insertBarVarViewController.tempCanCheckCheckedBox = tempCanCheckCheckedBox
            }
        }
            
    }
}


