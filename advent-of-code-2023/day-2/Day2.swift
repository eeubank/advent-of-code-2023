//
//  day-1.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/2/23.
//

import Foundation

struct Day2: DayOfCode {
    var input: DayOfCodeInput
    
    let maxR = 12, maxG = 13, maxB = 14
    
    func run() throws {
        var resultA = 0
        var resultB = 0;
        
        for line in input.getDataArray() {
            let game = try Day2Game(game: line)
            let maxCubes = game.maxCubes()
            if (maxCubes.red <= maxR && maxCubes.green <= maxG && maxCubes.blue <= maxB) {
                resultA += game.id
            }
            resultB += maxCubes.red * maxCubes.green * maxCubes.blue
        }
        
        print("Result A: \(resultA)")
        print("Result B: \(resultB)")
    }

}
