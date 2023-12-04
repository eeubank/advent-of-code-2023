//
//  Day3.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/3/23.
//

import Foundation

struct Day3: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let engine = Day3Engine(input: input)
        let resultA = engine.getValidPartNumbers().reduce(0, { acc, n in acc + n })
        let resultB = engine.getGearRatios().reduce(0, { acc, n in acc + n })
        
        print("Result A \(resultA)")
        print("Result B \(resultB)")
    }
}
