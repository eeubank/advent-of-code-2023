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
            arrangements += try row.getAllValidArrangements().count
        }
        return arrangements
    }
    
    func getArrangementsUnfolded() throws -> Int {
        var arrangements = 0
        for var row in rows {
            row.unfold()
            arrangements += try row.getAllValidArrangements().count
        }
        return arrangements
    }
}

struct Day12RowOfSprings {
    var rowRaw: String
    var row: [Character] = []
    var damaged: [Int] = []
    typealias Segment = (s: String, len: Int, pos: Int, range: ClosedRange<Int>)
    
    init(row: String, damaged: [Int]) {
        self.rowRaw = row
        self.row = trimBlanks(row).map { $0 }
        self.damaged = damaged
    }
    
    mutating func unfold() {
        let rowJoined = (0..<5).map { _ in rowRaw }.joined(separator: "?")
        row = trimBlanks(rowJoined).map { $0 }
        damaged = (0..<5).flatMap { _ in damaged }
    }
    
    private func trimBlanks(_ row: String) -> String {
        return String(row.replacing(/\.{2,}/, with: ".").reversed().trimmingPrefix(".").reversed().trimmingPrefix("."))
    }
    
    func getAllValidArrangements() throws -> [String] {
        var arrangements: [String] = []
        var segments: [Segment] = []
        
        for length in damaged {
            segments.append((s: String(repeating: "#", count: length), len: length, pos: 0, range: 0...0))
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
            let validPositions = try findFits(segmentLength: segment.len, range: searchRange)
            let range = validPositions.first!...(validPositions.last! + (segment.len - 1))
            segments[i].range = range
            segments[i].pos = range.lowerBound
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
            let validPositions = try findFits(segmentLength: segment.len, range: searchRange)
            let range = validPositions.first!...(validPositions.last! + (segment.len - 1))
            segments[i].range = range
            segments[i].pos = range.lowerBound
        }
        
//        print(row.map { String($0) }.joined(), " : ", damaged)
//        print(segments)
 
        var exitLoop = false
        var loopCount = 0
        repeat {
            loopCount += 1
            let firstSegment = segments.first!
            let lastSegment = segments.last!
            var s = String(repeating: ".", count: firstSegment.pos) + firstSegment.s
            
            for i in 1..<segments.count {
                let segment = segments[i]
                let prevSegment = segments[i-1]
                s += String(repeating: ".", count: segment.pos - prevSegment.pos - prevSegment.len) + segment.s
            }
            
            s += String(repeating: ".", count: row.count - 1 - (lastSegment.pos + (lastSegment.len - 1)))
            //print(s)
            
            if testFit(s) {
                arrangements.append(s)
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
        print(loopCount, " : ", row.map { String($0) }.joined(), " : ", damaged)
        
        return arrangements
    }
    
    private func incrementSegment(_ segments: inout [Segment], at i: Int) -> Bool {
        let segment = segments[i]
        if segment.pos + (segment.len - 1) < segment.range.upperBound {
            segments[i].pos += 1
            for j in (i+1)..<segments.count {
                segments[j].pos = max(segments[j-1].pos + segments[j-1].len + 1, segments[j].range.lowerBound)
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
    
    private func findFits(segmentLength: Int, range: ClosedRange<Int>) throws -> [Int] {
        var validPositions: [Int] = []
        var slideSegment: Bool
        for i in range.lowerBound...(range.upperBound - (segmentLength - 1)) {
            slideSegment = false
            let segmentRange = i..<(segmentLength + i)
            for j in range {
                if row[j] == "." && segmentRange.contains(j) {
                    slideSegment = true
                    break
                }
            }
            if (segmentRange.upperBound < range.count && row[segmentRange.upperBound] == "#") {
                slideSegment = true
            }
            
            if (segmentRange.lowerBound > 0 && row[segmentRange.lowerBound - 1] == "#") {
//                if (validPositions.count > 0) {
//                    return validPositions
//                }
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
