//
//  Day6Race.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/7/23.
//

import Foundation

struct Day6Race {
    var records: [Day6RaceRecord] = []
    var kernedRecord: Day6RaceRecord
    
    init(input: DayOfCodeInput) {
        let inputArr = input.getDataArray()
        let times = inputArr[0].matches(of: /(\d+)/).map { Int($0.output.0)! }
        let distances = inputArr[1].matches(of: /(\d+)/).map { Int($0.output.0)! }
        for i in 0..<times.count {
            records.append(Day6RaceRecord(time: times[i], distance: distances[i]))
        }
        
        let kernedTime = Int(times.map { "\($0)" }.reduce("", { acc, s in acc + s }))!
        let kernedDistance = Int(distances.map { "\($0)" }.reduce("", { acc, s in acc + s }))!
        kernedRecord = Day6RaceRecord(time: kernedTime, distance: kernedDistance)
    }
    
    func getMarginOfError() -> Int {
        return records.map { $0.getCountOfWaysToBeat() }
            .reduce(1, { acc, c in acc * c})
    }
    
    func getMarginOfErrorKerned() -> Int {
        return kernedRecord.getCountOfWaysToBeat()
    }
}

struct Day6RaceRecord {
    var time: Int
    var distance: Int
    
    func getCountOfWaysToBeat() -> Int {
        return (1..<time).filter { ($0 * (time - $0) > distance) }.count
    }
}
