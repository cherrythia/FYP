//
//  bar_calculateBoundary.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 2/3/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.
//

import UIKit

public func Bar_Calculate_Boundary(inout f:[Float], l:[Float], e:[Float], d:[Float], n:NSInteger) -> (forceBound1:Float, forceBound2: Float, barDisplacement: [Float]) {
    
    var barDisplacement = [Float] (count: n+1, repeatedValue: 0.0)
    var forceBound1 : Float = 0.0
    var forceBound2 : Float = 0.0

    var A = Array3D(zs: n+1, ys: n+1, xs: n+2)
    var B = Array3D(zs: n+1, ys: n+1, xs: n+2)
    var C = [Float] (count: n+1, repeatedValue: 0.0)
    var D = Array2d(rows: n+2, columns: 1)
    var fwall : Float   =   0.0
    
    //Deducing each individual Kb
    
    var Kb = [Float] (count:n, repeatedValue: 0.0)
    
    println("My Kb Values are")
    for rows in 0..<n {
        Kb[rows] = d[rows] * e[rows] / l[rows]    //d represents area here
        println("\(Float(Kb[rows]))")
    }
    
    //  Fixing the force at the other boundary to be zero for temporarily solution...
    println("\nForces in the array are")
    for rows in 0...n{
        if(rows==0||rows==n)
        { f[rows] = 0.0 }
        println(f[rows])
    }
    
    //  Display of Displacement matrix
    println("Displacement matrix is ")
    for rows in 0...(n+1){
        for column in 0..<1 {
            if (rows==0||rows==n) {D[rows,column] = 0 }
            else { D[rows,column] = 1}
            println("\(Float(D[rows,column]))")
        }
    }
    
    //Arrangement of stiffness matrices
    
    for z in 0..<n {
        
        for y in 0..<(n+1) {
            
            if(y==z||y==(z+1)) {
                
                for x in 0..<(n+1) {
                    
                    if(y%2==0 && z%2==0) {
                        if(x==z) {
                            A[z,y,x] = Kb[x] }
                        if(x==(z+1)) {
                            A[z,y,x] = -Kb[x-1] }
                    }
                    
                    if(y%2==1 && z%2==0) {
                        if(x==z) {
                            A[z,y,x] = -Kb[x] }
                        if(x==(z+1)) {
                            A[z,y,x] = Kb[x-1] }
                    }
                    
                    if(y%2 == 0 && z%2 == 1) {
                        if(x==z)    {
                            A[z,y,x] = -Kb[x] }
                        if(x == (z+1)) {
                            A[z,y,x] = Kb[x-1] }
                    }
                    
                    if(y%2 == 1 && z%2 == 1) {
                        if(x==z) {
                            A[z,y,x] = Kb[x] }
                        if(x==(z+1)) {
                            A[z,y,x] = -Kb[x-1] }
                    }
                }
            }
        }
    }
    
    //Adding in the forces into the Global matrix
    for z in 0..<n{
        for y in 0..<(n+1) {
            for x in 0..<(n+2) {
                B[0,y,x] = B[0,y,x] + A[z,y,x]
                if(x==(n+1)) {
                    B[0,y,x] = f[y]
                }
            }
        }
    }

    
    //Print Global Matrix
    println("\nGobal Matrix is")
    
    for y in 0..<(n+1) {
        for x in 0..<(n+2) {
            print(String (format: "%.3f\t", B[0,y,x]))
        }
        print("\n")
    }

    //Multiplying the displacement matrices into the Gloabl Matrix. NOTE: THE DISPLACEMENTS AT BOTH ENDS ARE ZEROS!!
    //Printing out the global matrices after multiplying with displacement matrix...
    println("\nGlobal matrix multiply by displacement")
    for y in 0..<(n+1) {
        for x in 0..<(n+2) {
            B[0,y,x] = B[0,y,x] * D[x,0]
            if(x == 0 || x == n) { B[0,y,x] = abs(B[0,y,x]) }
            print(String(format: "%.3f\t", B[0,y,x]))
        }
        print("\n")
    }
    
    //Computation of Gauss Jordan Method to solve..
    for x in 1...(n-1) {
        for y in 1...(n-1) {
            if (y != x) {
                
                C[x] = B[0,y,x] / B[0,x,x]
                
                for z in 1...(n+1) {
                    
                    B[0,y,z] = B[0,y,z] - C[x] * B[0,x,z]
                }
            }
        }
    }
    
    //Printing out the Array after computation ****Rows at the boundary are inclusive here****
    println("\nAfter computation using Gauss Jordan Method")
    for y in 0...n {
        for x in 0...(n+1) {
            print(String(format: "%.3f\t", B[0,y,x]))
        }
        print("\n")
    }
    
    //Solution of the displacement
    //ARRAY DISPLACEMENT TO PUT THE BOUNDARY CONDITIONS ARE BOTH ZEROS HERE....
    println("\nThe solutions are")
    for y in 0...n {
        if(y==0||y==n) { barDisplacement[y] = 0.0 }
            
        else {
            barDisplacement[y] = B[0,y,(n+1)] / B[0,y,y]
            println(String(format: "%.5f", barDisplacement[y]))
        }
    }
    
    //Forces to do an expansion here...
    //I can expand my stiffness array multiply by my displacement here to get my value of force
    for x in 0...n {
        forceBound1 = forceBound1 + (barDisplacement[x] * B[0,0,x])
        forceBound2 = forceBound2 + (barDisplacement[x] * B[0,n,x])
    }
    
    //Printing my forcebound1 & forcebound2 here.
    println("\nForce at left wall\t" + String(format: "%.3f", forceBound1))
    println("Force at right wall\t" + String(format: "%.3f", forceBound2))

    
    return (forceBound1, forceBound2, barDisplacement)
}

