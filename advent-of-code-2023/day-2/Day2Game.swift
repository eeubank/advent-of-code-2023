//
//  Day2Game.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/2/23.
//

import Foundation

struct Day2Game {
    var id: Int
    var cubes: [Day2Cubes]
    
    let rGame = /Game (\d+): (.*)/
    
    init(game: String) throws {
        if let m = game.firstMatch(of: rGame) {
            self.id = Int(m.1) ?? 0;
            self.cubes = m.2.split(separator: ";")
                .map{ (s) -> Day2Cubes in Day2Cubes(cubes: String(s)) }
        } else {
            throw "Game did not init"
        }
    }
    
    func maxCubes() -> Day2Cubes {
        var r = 0, g = 0, b = 0
        for cube in cubes {
            r = max(r, cube.red)
            g = max(g, cube.green)
            b = max(b, cube.blue)
        }
        return Day2Cubes(red: r, green: g, blue: b)
    }
}

struct Day2Cubes {
    var red = 0, green = 0, blue = 0
    
    let rRed = /(\d+) red/
    let rGreen = /(\d+) green/
    let rBlue = /(\d+) blue/
    
    init(cubes: String) {
        if let m = cubes.firstMatch(of: rRed) {
            red = Int(m.1) ?? 0
        }
        if let m = cubes.firstMatch(of: rGreen) {
            green = Int(m.1) ?? 0
        }
        if let m = cubes.firstMatch(of: rBlue) {
            blue = Int(m.1) ?? 0
        }
    }
    
    init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
