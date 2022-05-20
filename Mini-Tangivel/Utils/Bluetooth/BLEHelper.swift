//
//  BLEHelper.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 20/05/22.
//

import Foundation

func getStripeColorArray(for array: [[Int]], convertingTo colors: [Int: [Int]]) -> [Int] {
    var stripeArray: [Int] = []
    
    for row in array {
        for cell in row {
            if let conversion = colors[cell] {
                stripeArray += conversion
                continue
            }
            stripeArray += [0,0,0]
        }
    }
    
    return stripeArray
}
