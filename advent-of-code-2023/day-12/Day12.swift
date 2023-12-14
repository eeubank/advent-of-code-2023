//
//  Day12.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/12/23.
//

import Foundation

struct Day12: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let springs = Day12Springs(input: input)
        let resultsA = try springs.getArrangements()
        print("Result A \(resultsA)")

//        let resultsB = try springs.getArrangementsUnfolded()
//        print("Result B \(resultsB)")
    }
}

