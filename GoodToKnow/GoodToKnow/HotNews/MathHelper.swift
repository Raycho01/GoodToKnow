//
//  MathHelper.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 24.01.24.
//

import Foundation

final class MathHelper {
    
    static func ceilingDivision(_ number: Int, by divisor: Int) -> Int {
        return Int(ceil(Double(number) / Double(divisor)))
    }
}
