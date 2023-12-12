//
//  Day10Maze.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/10/23.
//

import Foundation

struct Day10Maze {
    var junctions: Dictionary<Day10Coord, Day10Junction> = [:]
    var startCoord: Day10Coord?
    
    init(input: DayOfCodeInput) throws {
        for (y, line) in input.getDataArray().enumerated() {
            for (x, char) in line.enumerated() {
                if (char == ".") {
                    continue
                }
                let coord = Day10Coord(x, y)
                if (char == "S") {
                    startCoord = coord
                }
                let junction = Day10Junction(connector: Day10Connector(rawValue: char)!)
                junctions.updateValue(junction, forKey: coord)
                try connectJunction(at: coord, direction: .N)
                try connectJunction(at: coord, direction: .S)
                try connectJunction(at: coord, direction: .W)
                try connectJunction(at: coord, direction: .E)
            }
        }
        replaceStart()
    }
    
    func getMidpointAndArea() -> (midpoint: Int, area: Int) {
        var junction = junctions[startCoord!]!
        var coord = junction.paths.first!; //pick arbratriary direction to begin
        var visited: Dictionary<Day10Coord, Day10Coord> = [coord:startCoord!]
        var stack: [Day10Coord] = [coord];
        
        while !stack.isEmpty {
            coord = stack.removeLast()
            junction = junctions[coord]!
            
            if coord == startCoord {
                let path = getLoopPath(coord, history: visited)
                let area = calculateArea(path)
                return (midpoint: path.count / 2, area)
            }
            
            for nextCoord in junction.paths {
                // do not go immediately back to start
                if nextCoord == startCoord && visited.count < 4 {
                    continue
                }
                if visited[nextCoord] != nil {
                    continue
                }
                visited.updateValue(coord, forKey: nextCoord)
                stack.append(nextCoord)
            }
        }
        return (-1, -1)
    }
    
    private func connectJunction(at coord: Day10Coord, direction: Day10Direction) throws {
        guard let junction = junctions[coord] else {
            throw "Junction not found"
        }
        let adjacentCoord = coord.adjacent(direction: direction)
        if let adjacentJunction = junctions[adjacentCoord] {
            if junction.connector.canConnect(to: adjacentJunction.connector, direction: direction) {
                junction.paths.insert(adjacentCoord)
                adjacentJunction.paths.insert(coord)
            }
        }
    }
    
    private mutating func replaceStart() {
        let startJunction = junctions[startCoord!]!
        var directions: [Day10Direction] = []
        let candidates =  [
            (startCoord!.adjacent(direction: .N), Day10Direction.N),
            (startCoord!.adjacent(direction: .S), .S),
            (startCoord!.adjacent(direction: .W), .W),
            (startCoord!.adjacent(direction: .E), .E),
        ]
        for candidate in candidates {
            guard let candiateJunction = junctions[candidate.0] else {
                continue
            }
            if startJunction.connector.canConnect(to: candiateJunction.connector, direction: candidate.1) {
                directions.append(candidate.1)
            }
        }
        let newConnector = Day10Connector.from(directions[0], directions[1])!
        junctions.updateValue(Day10Junction(connector: newConnector, paths: startJunction.paths), forKey: startCoord!)
    }
    
    private func getLoopPath(_ coord: Day10Coord, history: Dictionary<Day10Coord, Day10Coord>) -> [Day10Coord] {
        var prevCoord = coord
        var path: [Day10Coord] = []
        repeat {
            prevCoord = history[prevCoord]!
            path.append(prevCoord)
        } while prevCoord != startCoord
        return path
    }
    
    private func calculateArea(_ path: [Day10Coord]) -> Int {
        var area = 0
        let pathSet = Set(path)
        let minX = path.reduce(Int.max, { x, coord in min(x, coord.x) })
        let maxX = path.reduce(0, { x, coord in max(x, coord.x) })
        let minY = path.reduce(Int.max, { y, coord in min(y, coord.y) })
        let maxY = path.reduce(0, { y, coord in max(y, coord.y) })
        
        for y in minY...maxY {
            for x in minX...maxX {
                var intersectionsX = 0
                var horizontalBendDirection: Day10Direction?
                for ix in x...maxX {
                    let testCoord = Day10Coord(ix, y)
                    let testCoordW = Day10Coord(ix - 1, y)
                    if pathSet.contains(testCoord) {
                        if ix == x {
                            break
                        }
                        let junction = junctions[testCoord]!
                        if junction.connector == .horizontal {
                            continue
                        }
                        if path.contains(testCoordW) {
                            let junctionW = junctions[testCoordW]!
                            if junction.connector.canConnect(to: junctionW.connector, direction: .W) {
                                if horizontalBendDirection == junction.connector.getBendDirection() {
                                    intersectionsX -= 1
                                }
                                horizontalBendDirection = nil
                                continue
                            }
                        }
                        if horizontalBendDirection == nil {
                            horizontalBendDirection = junction.connector.getBendDirection()
                        }
                        intersectionsX += 1
                    }
                }

                if intersectionsX % 2 == 1 {
                    area += 1
                }
            }
        }
        return area
    }
}

class Day10Junction {
    var connector: Day10Connector
    var paths: Set<Day10Coord> = []
    
    init (connector: Day10Connector) {
        self.connector = connector
    }
    
    init (connector: Day10Connector, paths: Set<Day10Coord>) {
        self.connector = connector
        self.paths = paths
    }
}

struct Day10Coord: Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func adjacent(direction: Day10Direction) -> Day10Coord {
        switch direction {
        case .N: return Day10Coord(x, y-1)
        case .S: return Day10Coord(x, y+1)
        case .W: return Day10Coord(x-1, y)
        case .E: return Day10Coord(x+1, y)
        }
    }
}

enum Day10Connector: Character, CaseIterable {
    case start = "S"
    case vertical = "|"
    case horizontal = "-"
    case bendNE = "L"
    case bendNW = "J"
    case bendSW = "7"
    case bendSE = "F"
    
    static func from(_ d1: Day10Direction, _ d2: Day10Direction) -> Day10Connector? {
        let directions = Set([d1, d2])
        for connector in Day10Connector.allCases {
            if (connector == .start) {
                continue
            }
            if Set(connector.directions()).intersection(directions).count == 2 {
                return connector
            }
        }
        return nil
    }
    
    func directions() -> [Day10Direction] {
        switch self {
        case .start: return [.N, .S, .W, .E]
        case .vertical: return [.N, .S]
        case .horizontal: return [.W, .E]
        case .bendNE: return [.N, .E]
        case .bendNW: return [.N, .W]
        case .bendSE: return [.S, .E]
        case .bendSW: return [.S, .W]
        }
    }
    
    func canConnect(to: Day10Connector, direction: Day10Direction) -> Bool {
        return Set(self.directions()).intersection(to.directions().map { $0.invert() }).contains(direction)
    }
    
    func getBendDirection() -> Day10Direction? {
        switch self {
        case .bendNE: fallthrough
        case .bendNW: return .N
        case .bendSE: fallthrough
        case .bendSW: return .S
        default: return nil
        }
    }
}

enum Day10Direction {
    case N, S, W, E
    
    func invert() -> Day10Direction {
        switch self {
        case .N: return .S
        case .S: return .N
        case .W: return .E
        case .E: return .W
        }
    }
}
