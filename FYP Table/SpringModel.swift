//
//  SpringModel.swift
//  FYP Table
//
//  Created by Quix Creations Singapore iOS 1 on 15/7/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit
import CoreData

@objc (SpringModel) //Add this for obj C just in case 

class SpringModel: NSManagedObject {
    
    @NSManaged var force : Float
    @NSManaged var stiffness : Float
    @NSManaged var globalChecked : Bool
    @NSManaged var arrowChecked : Bool
}
