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
        let clock = ContinuousClock()
        let race = Day6Race(input: input)
        
        let resultA = race.getMarginOfError()
        print("Result A \(resultA)")
        
        let elapsedTime = clock.measure {
            let resultB = race.getMarginOfErrorKerned()
            print("Result B \(resultB)")
        }
        
        print("Time \(elapsedTime)")
    }
}
