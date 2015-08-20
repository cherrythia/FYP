//
//  BarModel.swift
//  FYP Table
//
//  Created by Quix Creations Singapore iOS 1 on 20/8/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit
import CoreData

@objc (BarModel) //add this for obj c just in case

class BarModel: NSManagedObject {
    
    @NSManaged var area : Float
    @NSManaged var force : Float
    @NSManaged var length : Float
    @NSManaged var youngMod : Float
    @NSManaged var arrowChecked : Bool
    @NSManaged var globalChecked : Bool

}
