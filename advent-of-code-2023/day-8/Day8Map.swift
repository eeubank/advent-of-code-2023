//
//  Day8Map.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/8/23.
//

import Foundation

struct Day8Map {
    var steps: [Character]
    var maps: Dictionary<String, (left: String, right: String)> = [:]
    var startingNodes: Set<String> = []
    var endingNodes: Set<String> = []
    
    init (input: DayOfCodeInput) {
        let inputArr = input.getDataArray()
        steps = inputArr[0].enumerated().map { _, c in c }
        
        for i in 2..<inputArr.count {
            let line = inputArr[i]
            let m = line.firstMatch(of: /(?<node>[1-9A-Z]{3}) = \((?<left>[1-9A-Z]{3}), (?<right>[1-9A-Z]{3})/)!.output
            if m.node.last == "A" {
                startingNodes.insert(String(m.node))
            } else if m.node.last == "Z" {
                endingNodes.insert(String(m.node))
            }
            maps.updateValue((String(m.left), String(m.right)), forKey: String(m.node))
        }
    }
    
    func getSteps(forNode: String = "AAA") -> Int {
        var curNode = forNode
        var totalSteps = 0
        while !endingNodes.contains(curNode) {
            let step = steps[totalSteps % steps.count]
            if step == "L" {
                curNode = maps[curNode]!.left
            } else {
                curNode = maps[curNode]!.right
            }
            totalSteps += 1
        }
        return totalSteps
    }
    
    func getGhostSteps() -> Int {
        var steps: [Int] = []
        let nodes = Array(startingNodes)
        for i in 0..<nodes.count {
            steps.append(getSteps(forNode: nodes[i]))
        }
        
        var totalSteps = lcm(steps[0], steps[1])
        for i in 2..<steps.count {
            totalSteps = lcm(totalSteps, steps[i])
        }
        return totalSteps
    }
    
    private func gcd(_ x: Int, _ y: Int) -> Int {
        var a = 0
        var b = max(x, y)
        var r = min(x, y)
        
        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }

    private func lcm(_ x: Int, _ y: Int) -> Int {
        return x / gcd(x, y) * y
    }
}
