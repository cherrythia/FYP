//
//  Array2d.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 27/1/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//
import UIKit

open class Array2d {
    let rows: Int, columns: Int
    var grid: [Float]
    
    init(rows: Int, columns: Int)
    {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    func indexIsValidForRow(_ row: Int, column: Int) -> Bool
    {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Float
    {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }

}
