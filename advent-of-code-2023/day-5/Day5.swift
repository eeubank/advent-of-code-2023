//
//  Day5.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/6/23.
//

import Foundation

struct Day5: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        print(Date.now)
        let almanac = Day5Almanac(input: input)
        let resultA = almanac.getLowestPlantingLocation()
        let resultB = almanac.getLowestPlantingLocationWithRange()
        
        print(Date.now)
        print("Result A \(resultA)")
        print("Result B \(resultB ?? -1)")
    }
}
