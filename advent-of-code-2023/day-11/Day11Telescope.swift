//
//  Day11Galaxies.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/11/23.
//

import Foundation

struct Day11Telescope {
    var galaxies: [Day11Galaxy] = []
    
    init (input: DayOfCodeInput, expansionFactor: Int) {
        var inputArr = input.getDataArray()
        var xAxis: [[Day11Galaxy]] = (0..<inputArr[0].count).map { _ in [] }
        var yAxis: [[Day11Galaxy]] = (0..<inputArr.count).map { _ in [] }
        
        for (y, line) in inputArr.enumerated() {
            for (x, char) in line.enumerated() {
                if char == "#" {
                    let galaxy = Day11Galaxy(galaxies.count + 1, x: x, y: y)
                    xAxis[x].append(galaxy)
                    yAxis[y].append(galaxy)
                    galaxies.append(galaxy)
                }
            }
        }
        
        // expand the elfin universe
        var xExpansion = 0
        for galaxyList in xAxis {
            if galaxyList.isEmpty {
                xExpansion += expansionFactor
                continue
            }
            galaxyList.forEach { $0.x += xExpansion }
        }
        
        var yExpansion = 0
        for galaxyList in yAxis {
            if galaxyList.isEmpty {
                yExpansion += expansionFactor
                continue
            }
            galaxyList.forEach { $0.y += yExpansion }
        }
    }
    
    func getGalaxyDistances() -> Int {
        var distance = 0
        for g1 in galaxies {
            for g2 in galaxies {
                if g1 == g2 {
                    continue
                }
                distance += abs(g1.x - g2.x) + abs(g1.y - g2.y)
            }
        }
        return distance / 2
    }
}

class Day11Galaxy: Equatable {
    var id: Int
    var x: Int
    var y: Int
    
    init(_ id: Int, x: Int, y:Int) {
        self.id = id
        self.x = x
        self.y = y
    }
    
    static func == (lhs: Day11Galaxy, rhs: Day11Galaxy) -> Bool {
        return lhs.id == rhs.id
    }
}
