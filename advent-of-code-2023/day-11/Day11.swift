//
//  Day11.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/11/23.
//

import Foundation

struct Day11: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let telescopeA = Day11Telescope(input: input, expansionFactor: 1)
        let resultsA = telescopeA.getGalaxyDistances()
        print("Result A \(resultsA)")
        
        let telescopeB = Day11Telescope(input: input, expansionFactor: 999999)
        let resultsB = telescopeB.getGalaxyDistances()
        print("Result B \(resultsB)")
    }
}
