//
//  Day7.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/7/23.
//

import Foundation

struct Day7: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let cards = Day7CamelCards(input: input)
        
        let resultA = cards.getWinnings()
        print("Result A \(resultA)")
        
        let resultB = cards.getWinnings(jokersAreWild: true)
        print("Result B \(resultB)")
    }
}
