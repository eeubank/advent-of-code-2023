//
//  Day3Engine.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/3/23.
//

import Foundation

struct Day3Engine {
    var partNumbers: [Day3Coord: Day3PartNumber] = [:]
    var symbolCoords: [Day3Coord: Character] = [:]
    
    init(input: DayOfCodeInput) {
        var isParsingNum = false
        var numRange: Range<Int>? = nil
        var numY = 0
        var numStr = ""
        
        for (y, line) in input.getDataArray().enumerated() {
            for (x, character) in line.enumerated() {

                if character.isASCII && character.isNumber {
                    // found number, collect digits
                    isParsingNum = true
                    if (numRange == nil) {
                        numRange = x..<(x+1)
                    } else {
                        numRange = numRange!.lowerBound..<(x+1)
                    }
                    numY = y
                    numStr += String(character)
                    continue
                } else if isParsingNum {
                    // found end of number, record it
                    let partNumber = createPartNumber(numStr: numStr, numRange: numRange!, numY: numY)
                    recordPartNumber(partNumber: partNumber, partNumberMap: partNumbers)
                    isParsingNum = false
                    numRange = nil
                    numStr = ""
                }
                
                if character != "." {
                    // found symbol, record it
                    symbolCoords.updateValue(character, forKey: Day3Coord(x: x, y: y))
                }
            }
        }
        
        // Process number at EOF
        if isParsingNum {
            let partNumber = createPartNumber(numStr: numStr, numRange: numRange!, numY: numY)
            recordPartNumber(partNumber: partNumber, partNumberMap: partNumbers)
        }
    }
    
    func getValidPartNumbers() -> [Int] {
        return Set(partNumbers.map { $0.value})
            .filter { partNumberIsValid(partNumber: $0) }
            .map { $0.number }
    }
    
    func getGearRatios() -> [Int] {
        return symbolCoords.filter { $0.value == "*" }
            .map { getPartNumbersAdjacentToCoord(coord: $0.key) }
            .filter { $0.count >= 2 }
            .map { $0.reduce(1, { acc, pn in acc * pn.number }) }
    }
    
    private func createPartNumber(numStr: String, numRange: Range<Int>, numY: Int) -> Day3PartNumber {
        return Day3PartNumber(number: Int(numStr)!, x1: numRange.lowerBound, x2: numRange.upperBound-1, y: numY)
    }
    
    private mutating func recordPartNumber(partNumber: Day3PartNumber, partNumberMap: Dictionary<Day3Coord, Day3PartNumber>) {
        for x in partNumber.x1..<(partNumber.x2+1) {
            partNumbers.updateValue(partNumber, forKey: Day3Coord(x: x, y: partNumber.y))
        }
    }
    
    private func partNumberIsValid(partNumber: Day3PartNumber) -> Bool {
        for y in (partNumber.y-1)..<(partNumber.y+2) {
            for x in (partNumber.x1-1)..<(partNumber.x2+2) {
                if symbolCoords[Day3Coord(x: x, y: y)] != nil {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func getPartNumbersAdjacentToCoord(coord: Day3Coord) -> Set<Day3PartNumber> {
        var results: Set<Day3PartNumber> = []
        
        for y in (coord.y-1)..<(coord.y+2) {
            for x in (coord.x-1)..<(coord.x+2) {
                if let pn = partNumbers[Day3Coord(x: x, y: y)] {
                    results.insert(pn)
                }
            }
        }
        
        return results
    }
}

struct Day3PartNumber: Hashable {
    var number: Int
    var x1, x2, y: Int
}

struct Day3Coord: Hashable {
    var x, y: Int
}
