//
//  Array3d.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 22/1/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import Foundation
import UIKit

class Array3D {
    var zs:Int, ys:Int, xs:Int
    var matrix: [Float]
    
    init(zs: Int, ys:Int, xs:Int)
    {
        self.zs = zs
        self.ys = ys
        self.xs = xs
        matrix = Array(repeating: 0, count: zs*ys*xs)
    }
    
    subscript(z:Int, y:Int, x:Int) -> Float
    {
        get {
            return matrix[ z * ys * xs + y * xs + x ]
        }
        set {
            matrix[ z * ys * xs + y * xs + x ] = newValue
        }
    }
    
    var description : String
        {
       return String(format: "\(matrix) zs:%d ys:%d xs:%d", zs, ys, zs)
        }

}



