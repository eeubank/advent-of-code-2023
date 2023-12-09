//
//  Day8.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/8/23.
//

import Foundation

struct Day8: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let map = Day8Map(input: input)
        
        let resultA = map.getSteps()
        print("Result A \(resultA)")
        
        let resultB = map.getGhostSteps()
        print("Result B \(resultB)")
    }
}
