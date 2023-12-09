//
//  Day9.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/9/23.
//

import Foundation

struct Day9: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let oasis = Day9OASIS(input: input)
        
        let results = oasis.getPredictions()
        print("Result A \(results.predicted)")
        print("Result B \(results.extrapolated)")
    }
}
