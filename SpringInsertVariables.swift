//
//  SpringTableViewControllerInsertVariables.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 17/2/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.


/*View of adding variables into the Spring. */

import UIKit
import CoreData

class SpringInsertVariables : UIViewController {
    
    @IBOutlet weak var arrowOutlet: ForceArrow!
    @IBOutlet weak var leftNode: UILabel!
    @IBOutlet weak var rightNode: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var checkBoxOutlet: CheckBox2!
    var imageArray :[UIImage] = [UIImage(named: "springAtWall.jpg")!,
                                UIImage(named:"spring.jpg")!,
                                UIImage(named: "springAtWall1.jpg")!]
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var forceEntered: UITextField!
    @IBOutlet weak var stiffnessLabel: UILabel!
    @IBOutlet weak var stiffnessEntered: UITextField!
    
    var tempForce : Float = 0.0
    var tempStiffness : Float = 0.0
    var tempMangObj : NSManagedObject!
    var tempCount : Int = 0
    var tempChcekedGlobal : Bool = false
    var tempArrow : Bool = false
    var tempCanCheckCheckedBox : Bool = false

    override func viewDidLoad() {
        
        if(tempMangObj != nil && tempCanCheckCheckedBox == false){
            checkBoxOutlet.isEnabled = false
        }
        else{
            checkBoxOutlet.isEnabled = true
        }
        
        leftNode.text = "Node \(tempCount)"
        rightNode.text = "Node \(tempCount + 1)"
        
        if(isCheckedGlobal == false)
        {
            forceEntered.isEnabled = true
            arrowOutlet.isEnabled = true
            arrowOutlet.isHidden = false
            
            if(tempCount != 0)
            {
                image.image = imageArray[1]
            }
            else
            {
                image.image = imageArray[0]
            }
            
        }
        
        else if(isCheckedGlobal == true && tempCount != 0)
        {
            (image.image = imageArray[2])
            forceEntered.isEnabled = false
            forceEntered.text = "0"
            arrowOutlet.isEnabled=false
            arrowOutlet.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(tempMangObj != nil)
        {
            forceEntered.text = "\(tempForce)N"
            stiffnessEntered.text = "\(tempStiffness)N/m"
        }
        
    }
    
    //TODO: Comment out first
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 

    @IBAction func checkboxed(_ sender: AnyObject) {
        
            if(tempCount != 0) {
                
                if (isCheckedGlobal == true)
                {
                    isCheckedGlobal = false
                }
                else
                {
                    isCheckedGlobal = true
                }
            }
            
            else{   //warning Alert
                    let first_spring_alert = UIAlertController(title: "First spring must be inputted", message: "First spring musts always be attached on the left wall", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .default) {(ACTION: UIAlertAction!) -> Void in}
                    first_spring_alert.addAction(cancelAction)
                    present(first_spring_alert, animated: true, completion: nil)
                }
            
            self.viewDidLoad()
    }
    
    @IBAction func arrow(_ sender: AnyObject) {
        
        if(ArrowGlobal == true) {
            ArrowGlobal = false
            let tempForceConversion = (forceEntered.text as! NSString).floatValue
            forceEntered.text = "\(abs(tempForceConversion))"
        }
        else {
            ArrowGlobal = true
            forceEntered.text = "-\(forceEntered.text!)"
        }
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if(forceEntered.text == "" || stiffnessEntered.text == ""){
            let emptyTextAlert = UIAlertController(title: "TextField is empty", message: "Please input value(s)", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default , handler: nil)
            emptyTextAlert.addAction(okButton)
            present(emptyTextAlert, animated: true, completion: nil)
        }
        else  {
            
            //NSCoreData
            //Reference to App Delegate
            let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            //Reference moc
            let contxt : NSManagedObjectContext = appDel.managedObjectContext!
            let en = NSEntityDescription.entity(forEntityName: "SpringVariables", in: contxt)
            
            if(tempMangObj != nil){
                
                tempMangObj.setValue(NSString(string: forceEntered.text!).floatValue, forKey: "force")
                tempMangObj.setValue(NSString(string: stiffnessEntered.text!).floatValue, forKey: "stiffness")
                tempMangObj.setValue((Bool: isCheckedGlobal), forKey: "globalChecked")                          //isCheckedGloabl will not be nil because newItem will handle it.
                tempMangObj.setValue((Bool: ArrowGlobal), forKey: "arrowChecked")
            }
                
            else {
                //newItem created
                var newItem = SpringModel(entity:en!,insertInto: contxt)
                
                newItem.stiffness = NSString(string: stiffnessEntered.text!).floatValue
                newItem.arrowChecked = ArrowGlobal
                newItem.globalChecked = isCheckedGlobal
                
                if(isCheckedGlobal == true)
                {
                    newItem.force = 0
                }
                else{
                    newItem.force = NSString(string: forceEntered.text!).floatValue
                }
                print(newItem)
            }
            
            //Save our context
            do {
                try contxt.save()
            } catch  {
                
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
}
