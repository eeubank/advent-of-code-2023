//
//  Day4.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/4/23.
//

import Foundation

struct Day4: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        var lottery = try Day4Lottery(input: input)
        let resultA = lottery.getTotalPoints()
        let resultB = lottery.getTotalTickets()
        
        print("Result A \(resultA)")
        print("Result B \(resultB)")
    }
}
