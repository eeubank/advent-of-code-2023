//
//  Day10.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/10/23.
//

import Foundation

struct Day10: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let maze = try Day10Maze(input: input)
        
        let results = maze.getMidpointAndArea()
        print("Result A \(results.midpoint)")
        print("Result B \(results.area)")
    }
}
