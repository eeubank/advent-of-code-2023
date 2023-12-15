//
//  Day12Springs.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/12/23.
//

import Foundation

struct Day12Springs {
    var rows: [Day12RowOfSprings] = []
    
    init(input: DayOfCodeInput) {
        for line in input.getDataArray() {
            let m = line.firstMatch(of: /(?<row>[\.\?#]+) (?<damaged>(\d+,)+\d+)/)!.output
            rows.append(Day12RowOfSprings(
                row: String(m.row),
                damaged: m.damaged.components(separatedBy: ",").map { Int($0)! })
            )
        }
    }
    
    func getArrangements() throws -> Int {
        var arrangements = 0
        for row in rows {
            arrangements += try row.getAllValidArrangements()
        }
        return arrangements
    }
    
    func getArrangementsUnfolded() throws -> Int {
        var arrangements = 0
        for var row in rows {
            let arrFolded = try row.getAllValidArrangements()
            row.unfold()
            let arrUnfolded = try row.getAllValidArrangements()
            print(arrUnfolded * arrUnfolded * arrFolded)
            arrangements = arrUnfolded * arrUnfolded * arrFolded
        }
        return arrangements
    }
}

struct Day12RowOfSprings {
    var rowRaw: String
    var row: [Character] = []
    var damaged: [Int] = []
    typealias Segment = (s: String, len: Int, pos: Int, validPos: [Int], range: ClosedRange<Int>)
    
    init(row: String, damaged: [Int]) {
        self.rowRaw = row
        self.row = trimBlanks(row).map { $0 }
        self.damaged = damaged
    }
    
    mutating func unfold() {
        let rowJoined = (0..<2).map { _ in rowRaw }.joined(separator: "?")
        row = trimBlanks(rowJoined).map { $0 }
        damaged = (0..<2).flatMap { _ in damaged }
    }
    
    private func trimBlanks(_ row: String) -> String {
        return String(row.replacing(/\.{2,}/, with: ".").reversed().trimmingPrefix(".").reversed().trimmingPrefix("."))
    }
    
    func getAllValidArrangements() throws -> Int {
        var arrangements = 0
        var failedFits = 0
        var segments: [Segment] = []
        
        for length in damaged {
            segments.append((s: String(repeating: "#", count: length), len: length, pos: 0, validPos: [], range: 0...0))
        }
        
        for i in (0..<segments.count).reversed() {
            let segment = segments[i]
            if i == segments.count - 1 {
                segments[i].range = segment.range.withMax(row.count - 1)
            } else {
                let nextSegment = segments[i+1]
                segments[i].range = segment.range.withMax(nextSegment.range.upperBound - nextSegment.len - 1)
            }
        }
        
        for i in 0..<segments.count {
            let segment = segments[i]
            var searchRange = segment.range
            if i > 0 {
                let prevSegment = segments[i - 1]
                searchRange = searchRange.withMin(prevSegment.range.lowerBound + prevSegment.len + 1)
            }
            let validPositions = try findFits(segmentLength: segment.len, range: searchRange, pinToHash: false)
            let range = validPositions.first!...(validPositions.last! + (segment.len - 1))
            segments[i].range = range
            //segments[i].pos = range.lowerBound
            segments[i].validPos = validPositions
//            if i > 0 {
//                let prevSegment = segments[i - 1]
//                let prevRange = prevSegment.range.withMax(range.upperBound - segment.len - 1)
//                segments[i - 1].range = prevRange
//            }
        }
        
        for i in (0..<segments.count).reversed() {
            let segment = segments[i]
            var searchRange = segment.range
            if i < segments.count - 1 {
                let nextSegment = segments[i + 1]
                searchRange = searchRange.withMax(nextSegment.range.upperBound - nextSegment.len - 1)
            }
            let validPositions = try findFits(segmentLength: segment.len, range: searchRange, pinToHash: true)
            let range = validPositions.first!...(validPositions.last! + (segment.len - 1))
            segments[i].range = range
            //segments[i].pos = range.lowerBound
            segments[i].validPos = validPositions
        }
        
//        print(row.map { String($0) }.joined(), " : ", damaged)
//        print(segments)
 
        var exitLoop = false
        var loopCount = 0
        repeat {
            loopCount += 1
            let firstSegment = segments.first!
            let lastSegment = segments.last!
            var s = String(repeating: ".", count: firstSegment.validPos[firstSegment.pos]) + firstSegment.s
            
            for i in 1..<segments.count {
                let segment = segments[i]
                let prevSegment = segments[i-1]
                s += String(repeating: ".", count: segment.validPos[segment.pos] - prevSegment.validPos[prevSegment.pos] - prevSegment.len) + segment.s
            }
            
            s += String(repeating: ".", count: row.count - 1 - (lastSegment.validPos[lastSegment.pos] + (lastSegment.len - 1)))
            //print(s)
            
            if testFit(s) {
                arrangements += 1
            } else {
                failedFits += 1
            }
                
            for i in (0..<segments.count).reversed() {
                if incrementSegment(&segments, at: i) {
                    break
                }
                if i == 0 {
                    exitLoop = true
                }
            }
        } while !exitLoop
        print(loopCount, " : ", row.map { String($0) }.joined(), " : ", damaged, " :: ", arrangements, " ::: ", failedFits)
        
        return arrangements
    }
    
    private func incrementSegment(_ segments: inout [Segment], at i: Int) -> Bool {
        let segment = segments[i]
        if segment.validPos[segment.pos] + (segment.len - 1) < segment.range.upperBound {
            segments[i].pos += 1
            for j in (i+1)..<segments.count {
                segments[j].pos = 0
                while segments[j].validPos[segments[j].pos] < segments[j-1].validPos[segments[j-1].pos] + segments[j-1].len + 1 {
                    //segments[j].pos = max(segments[j-1].pos + segments[j-1].len + 1, segments[j].range.lowerBound)
                    segments[j].pos += 1
                }
            }
            return true
        }
        return false
    }
    
    private func testFit(_ arrangement: String) -> Bool {
        let testFit = arrangement.map { $0 }
        for i in (0..<row.count).reversed() {
            if testFit[i] == row[i] {
                continue
            }
            if row[i] != "?" {
                return false
            }
        }
        return true
    }
    
    private func findFits(segmentLength: Int, range: ClosedRange<Int>, pinToHash: Bool) throws -> [Int] {
        var validPositions: [Int] = []
        var slideSegment: Bool
        
        //var rangeContainsHash = range.map({ row[$0] }).filter({ $0 == "#" }).count > 0
        
        for i in range.lowerBound...(range.upperBound - (segmentLength - 1)) {
            slideSegment = false
            let segmentRange = i..<(segmentLength + i)
//            for j in range {
//                if row[j] == "." && segmentRange.contains(j) {
//                    slideSegment = true
//                    break
//                }
//            }
            if segmentRange.map({ row[$0] }).filter({ $0 == "." }).count > 0 {
                slideSegment = true
            }
//            if pinToHash && rangeContainsHash && segmentRange.map({ row[$0] }).filter({ $0 == "#" }).count == 0 {
//                slideSegment = true
//            }
            if (segmentRange.upperBound < range.count && row[segmentRange.upperBound] == "#") {
                slideSegment = true
            }
            if (segmentRange.lowerBound > 0 && row[segmentRange.lowerBound - 1] == "#") {
                slideSegment = true
            }
            
            if slideSegment {
                continue
            }
            validPositions.append(i)
        }
        if validPositions.count == 0 {
            throw "no valid pos found"
        }
        return validPositions
    }
}
