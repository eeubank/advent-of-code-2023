//
//  Day6.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/7/23.
//

import Foundation

struct Day6: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let race = Day6Race(input: input)
        let resultA = race.getMarginOfError()
        let resultB = race.getMarginOfErrorKerned()
        
        print("Result A \(resultA)")
        print("Result B \(resultB)")
    }
}
