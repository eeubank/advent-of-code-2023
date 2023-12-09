//
//  Day9Oasis.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/9/23.
//

import Foundation

struct Day9OASIS {
    var sensorData: [Day9SensorData]
    
    init (input: DayOfCodeInput) {
        sensorData = input.getDataArray()
            .map { Day9SensorData(data: $0.matches(of: /([-\d]+)/).map { Int($0.output.0)! }) }
    }
    
    func getPredictions() -> (predicted: Int, extrapolated: Int) {
        let preditions = sensorData.map { $0.getPredictedValues() }
        return (preditions.map { $0.predicted }.sum(), preditions.map { $0.extrapolated }.sum())
    }
}

struct Day9SensorData {
    var data: [Int]
    
    func getPredictedValues() -> (predicted: Int, extrapolated: Int) {
        var curSeq = data
        var bookendValues: [(beginning: Int, end: Int)] = []
        
        while curSeq.filter({ $0 != 0 }).count > 0 {
            bookendValues.append((curSeq.first!, curSeq.last!))
            curSeq = getNextSequence(curSeq)
        }
        
        return bookendValues.reversed()
            .reduce((predicted: 0, extrapolated: 0), { acc, bookendValue
                in (acc.predicted + bookendValue.end, bookendValue.beginning - acc.extrapolated) }
            )
    }
    
    private func getNextSequence(_ sequence: [Int]) -> [Int] {
        var result: [Int] = []
        for i in 1..<sequence.count {
            result.append(sequence[i] - sequence[i - 1])
        }
        return result
    }
}
