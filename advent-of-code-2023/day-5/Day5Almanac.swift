//
//  Day5Garden.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/6/23.
//

import Foundation

struct Day5Almanac {
    var seeds: [Int] = []
    var seedsAsRange: [ClosedRange<Int>] = []
    var maps: Dictionary<Day5MapType, Day5Map> = [:]
    
    init (input: DayOfCodeInput) {
        let inputArr = input.getDataArray()
        self.seeds = processSeedsInput(line: inputArr[0])
        self.seedsAsRange = processSeedsInputAsRange(line: inputArr[0])
        var map: Day5Map?
        var valuesRange: ClosedRange<Int>?
        var mapType: Day5MapType?
        for i in 2..<inputArr.count {
            let line = inputArr[i]
            if map == nil {
                map = Day5Map()
                mapType = Day5MapType(rawValue: String(line.firstMatch(of: /([\w-]+)/)!.output.0))!
            } else if line == "" {
                map!.build(from: Array(inputArr[valuesRange!]))
                self.maps.updateValue(map!, forKey: mapType!)
                map = nil
                valuesRange = nil
            } else {
                valuesRange = valuesRange != nil ? valuesRange!.lowerBound...i : i...i
            }
        }
    }
    
    func getLowestPlantingLocation() -> Int {
        return seeds.map { maps[.seedToSoil]!.getMappedSourceToDest(value: $0) }
            .map { maps[.soilToFertalizer]!.getMappedSourceToDest(value: $0 )}
            .map { maps[.fertalizerToWater]!.getMappedSourceToDest(value: $0 )}
            .map { maps[.waterToLight]!.getMappedSourceToDest(value: $0 )}
            .map { maps[.lightToTemperature]!.getMappedSourceToDest(value: $0 )}
            .map { maps[.temperatureToHumidity]!.getMappedSourceToDest(value: $0 )}
            .map { maps[.humidityToLocation]!.getMappedSourceToDest(value: $0 )}
            .sorted(by: <)[0]
    }
    
    func getLowestPlantingLocationWithRange() -> Int? {
        for i in 0...maps[.humidityToLocation]!.getMaxSourceRangeValue() {
            let potentialSeed = [i]
                .map { maps[.humidityToLocation]!.getMappedDestToSource(value: $0) }
                .map { maps[.temperatureToHumidity]!.getMappedDestToSource(value: $0) }
                .map { maps[.lightToTemperature]!.getMappedDestToSource(value: $0) }
                .map { maps[.waterToLight]!.getMappedDestToSource(value: $0) }
                .map { maps[.fertalizerToWater]!.getMappedDestToSource(value: $0) }
                .map { maps[.soilToFertalizer]!.getMappedDestToSource(value: $0) }
                .map { maps[.seedToSoil]!.getMappedDestToSource(value: $0) }[0]
            
            if seedsAsRange.contains(where: { $0.contains(potentialSeed) }) {
                return i
            }
        }
        
        return nil
    }
    
    private func processSeedsInput(line: String) -> [Int] {
        return line.components(separatedBy: ":")[1]
            .matches(of: /(\d+)/)
            .map { Int($0.output.0)! }
    }
    
    private func processSeedsInputAsRange(line: String) -> [ClosedRange<Int>] {
        return line.components(separatedBy: ":")[1]
            .matches(of: /(?:(?<source>\d+) (?<length>\d+))+/)
            .map { Int($0.output.source)!...(Int($0.output.source)! + Int($0.output.length)!) }
    }
}

struct Day5Map {
    var rangesSourceSort: [(source: ClosedRange<Int>, dest: ClosedRange<Int>)] = []
    var rangesDestSort: [(source: ClosedRange<Int>, dest: ClosedRange<Int>)] = []
    
    mutating func build(from input: [String]) {
        let regex = /(?<dest>\d+) (?<source>\d+) (?<length>\d+)/
        for line in input {
            let values = line.firstMatch(of: regex)!
            let sourceRange = Int(values.source)!...(Int(values.source)! + (Int(values.length)! - 1))
            let destinationRange = Int(values.dest)!...(Int(values.dest)! + (Int(values.length)! - 1))
            rangesSourceSort.append((sourceRange, destinationRange))
            rangesDestSort.append((sourceRange, destinationRange))
        }
        rangesSourceSort.sort { $0.source.lowerBound < $1.source.lowerBound }
        rangesDestSort.sort { $0.dest.lowerBound < $1.dest.lowerBound }
    }
    
    func getMappedSourceToDest(value: Int) -> Int {
        for r in rangesSourceSort {
            if r.source.contains(value) {
                return r.dest.lowerBound + (value - r.source.lowerBound)
            } else if value > r.source.upperBound {
                continue
            } else if value < r.source.lowerBound {
                return value
            }
        }
        return value
    }
    
    func getMappedDestToSource(value: Int) -> Int {
        for r in rangesDestSort {
            if r.dest.contains(value) {
                return r.source.lowerBound + (value - r.dest.lowerBound)
            } else if value > r.dest.upperBound {
                continue
            } else if value < r.dest.lowerBound {
                return value
            }
        }
        return value
    }
    
    func getMaxSourceRangeValue() -> Int {
        return rangesSourceSort.last?.source.upperBound ?? 0
    }
}

enum Day5MapType: String {
    case seedToSoil = "seed-to-soil"
    case soilToFertalizer = "soil-to-fertilizer"
    case fertalizerToWater = "fertilizer-to-water"
    case waterToLight = "water-to-light"
    case lightToTemperature = "light-to-temperature"
    case temperatureToHumidity = "temperature-to-humidity"
    case humidityToLocation = "humidity-to-location"
}
