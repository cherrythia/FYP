//
//  Calculate.swift
//  FYP Table
//
//  Created by Chia Wei Zheng Terry on 22/1/15.
//  Copyright (c) 2015 Chia Wei Zheng Terry. All rights reserved.

import UIKit
public func spring_calculate (f:[Float], s:[Float], n:NSInteger) -> [Float]  {
    
    var Ans = [Float] (count: n+1, repeatedValue: 0.0)
    let A  = Array3D(zs: n+1, ys: n+1, xs: n+2)
    let B = Array3D(zs: n+1, ys: n+1 , xs: n+2)
    var C = [Float] (count: n+1, repeatedValue: 0.0)
    let D = Array2d(rows: n+1, columns: 1)
    var fwall : Float = 0.0
    
    print("\nForces in the array are", terminator: "")
    for rows in 0..<(n+1) {
        print(f[rows], terminator: "")
    }
    
    //Displament matrix
    for rows in 0..<(n+1) {
        for columns in 0..<1
        {
        if (rows==0)
            {
            D[rows,columns] = 0
            }
        else
            {
            D[rows,columns] = 1
            }
        }
    }
    
    //Arrangement of matrices
    
    for z in 0..<n {
        
        for y in 0..<(n+1) {                    //Note that rows are represented by y and columns are represented by x
            
            if(y==z||y==(z+1))  {
                
                for x in 0..<(n+1) {
                    
                    if (y%2==0 && z%2==0 ) {                            //Formation of Value 1 Diagonal Matrix
                        if(x==z)    {
                            A[z,y,x] = s[x] }
                        
                        if(x==(z+1))    {
                            A[z,y,x] = -s[x-1]   }
                    }
                    
                    if(y%2==1 && z%2==0) {
                        if(x==z)    {
                            A[z,y,x] = -s[x]    }
                        
                        if(x==(z+1))    {
                            A[z,y,x] = s[x-1]   }
                    }
                    
                    if (y%2==0 && z%2==1)   {                           //Formation of Value 2 Digonal Matrix
                        if(x==z) {
                            A[z,y,x] = -s[x]  }
                        
                        if(x == (z+1))  {
                            A[z,y,x] = s[x-1]   }
                        
                    }
                    
                    if (y%2==1 && z%2 == 1)  {
                        if(x==z) {
                            A[z,y,x] = s[x]     }
                        
                        if(x==(z+1))    {
                            A[z,y,x] = -s[x-1]  }
                    }
                    
                }
            }
        }
    }
    
            for z in 0..<n{
                for y in 0..<(n+1) {
                    for x in 0..<(n+2) {
                        B[0,y,x] = B[0,y,x] + A[z,y,x]
                            if(x==(n+1)) {
                                B[0,y,x] = f[y] }
                    }
                }
            }
    
        //Print Global Matrix
        print("\nGobal Matrix is", terminator: "")
        
        for y in 0..<(n+1) {
            for x in 0..<(n+2) {
                print(String (format: "%.3f\t", B[0,y,x]), terminator: "")
            }
            print("\n", terminator: "")
        }
    
        //Multiplying my displacement matrix into the Gloabl Matrix
    for y in 0..<(n+1) {
        for x in 0..<(n+1) {
                B[0,y,x] = B[0,y,x] * D[x,0]
            if(x==0) { B[0,y,x] = abs(B[0,y,x]) }
        }
    }
    
    print("\nGlobal Matrix after multiplication with Displacements")
    
    //Print Global Matrix W Displacement
    for y in 0..<(n+1) {
        for x in 0..<(n+2)   {
            print(String(format: "%.3f\t", B[0,y,x]), terminator: "")
            
        }
        print("\n", terminator: "")
    }
    
    print("\n\n", terminator: "")
    
        //Computation to solve
        for x in 1...(n) {
            for y in 1...(n) {
                if (y != x) {
                                C[x] = B[0,y,x] / B[0,x,x]
                    
                                for z in 1...(n+1) {
                                B[0,y,z] = B[0,y,z] - C[x] * B[0,x,z]
                    }
                }
            }
        }
    
    print("After computation using Gauss Jordan Method")
    
    //Try printing the solution after computation
    for y in 0..<(n+1) {
        for x in 0..<(n+2) {
            print(String(format: "%.3f\t" , B[0,y,x]), terminator: "")
        }
        print("\n", terminator: "")
    }
    
        print("\nThe Solution is ")
    
        for y in 0...(n) {
            
            if( y==0) {Ans[y] = 0.0 }
            
            else {
                
            Ans[y]=B[0,y,(n+1)]/B[0,y,y] }
            print(String(format: "%.5f", Ans[y]))
        }

    return Ans
}
