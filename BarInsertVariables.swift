//
//  BarInsertVariables.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 1/3/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit
import CoreData

class BarInsertVariables: UIViewController {

    @IBOutlet weak var arrowOutlet: ForceArrow!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var barImage: UIImageView!
    var barImageArray : [UIImage] = [UIImage(named: "barAtWall.jpg")!,
                                    UIImage(named: "bar.jpg")!,
                                    UIImage(named: "BarAtWall1.jpg")!]
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var forceEntered: UITextField!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var lengthEntered: UITextField!
    @IBOutlet weak var modulusLabel: UILabel!
    @IBOutlet weak var modulusEntered: UITextField!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaEntered: UITextField!
    
    var tempForce : Float = 0.0
    var tempArea : Float = 0.0
    var tempLength : Float = 0.0
    var tempMod : Float = 0.0
    var tempCount : Int = 0
    var tempCheckedGlobal : Bool = false
    var tempArrow : Bool = false
    var tempMangObj : NSManagedObject!
    
    override func viewDidLoad() {
        
        leftLabel.text = "Node \(tempCount)"
        rightLabel.text = "Node \(tempCount + 1)"
       
        if(isCheckedGlobal == false) {
            
            forceEntered.enabled = true
            arrowOutlet.enabled = true
            arrowOutlet.hidden = false
            
            if(tempCount != 0)
            {
                image.image = barImageArray[1]
            } else
            {
                image.image = barImageArray[0]
            }
        }
        
        if(isCheckedGlobal == true && tempCount != 0) {
            
            barImage.image = barImageArray[2]
            forceEntered.enabled = false
            forceEntered.text = "0"
            arrowOutlet.enabled = false
            arrowOutlet.hidden = true
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(tempMangObj != nil)
        {
            forceEntered.text = "\(tempForce)N"
            areaEntered.text = "\(tempArea)m"
            lengthEntered.text = "\(tempLength)"
            modulusEntered.text = "\(tempMod)"
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func barCheckboxed(sender: AnyObject) {
        
        if(tempCount != 0){
            if(isCheckedGlobal == true){
                isCheckedGlobal = false
            }
            else{
                isCheckedGlobal = true
            }
        }
        
        else {
            
            //Warming for the first bar element
            let first_bar_alert = UIAlertController(title: "First bar must be inputted here", message: "First bar must always be attached on the left war here", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Default) {(ACTION: UIAlertAction!) -> Void in}
            first_bar_alert.addAction(cancelAction)
            presentViewController(first_bar_alert, animated: true, completion: nil)
        }
        self.viewDidLoad()
    }
    
    @IBAction func arrow(sender: AnyObject) {
        
        if(ArrowGlobal == true) {
            ArrowGlobal = false
            var tempForceConversion = (forceEntered.text as NSString).floatValue
            forceEntered.text = "-\(abs(tempForceConversion))"
        }
        
        else{
            ArrowGlobal = true
            forceEntered.text = "-\(forceEntered.text)"
        }
    }
    
    
    @IBAction func barSubmit(sender: AnyObject) {
        //CoreData
        //Reference to App Delegate
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //Reference moc
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("BarVariables", inManagedObjectContext: context)
        
        if(tempMangObj != nil) {       //save changes here
            
            tempMangObj.setValue(NSString(string: forceEntered.text).floatValue, forKey: "force")
            tempMangObj.setValue(NSString(string: areaEntered.text).floatValue, forKey: "area")
            tempMangObj.setValue(NSString(string: lengthEntered.text).floatValue, forKey: "length")
            tempMangObj.setValue(NSString(string: modulusEntered.text).floatValue, forKey: "youndMod")
            
            tempMangObj.setValue((Bool: isCheckedGlobal), forKey: "globalChecked")
            tempMangObj.setValue((Bool: ArrowGlobal), forKey: "arrowChecked")
            
        }
        else {                       //create new item here
            
            var newItem = BarModel(entity:en!,insertIntoManagedObjectContext: context)
            newItem.area = NSString(string: areaEntered.text).floatValue
            newItem.length = NSString(string: lengthEntered.text).floatValue
            newItem.youngMod = NSString(string: modulusEntered.text).floatValue
            
            if(isCheckedGlobal == true){
                newItem.force = 0
            }
            else{
                newItem.force = NSString(string: forceEntered.text).floatValue
            }
            println(newItem)
        }
        
        //save our context
        context.save(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
                
    }
    
    
}
