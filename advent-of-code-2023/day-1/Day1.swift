//
//  day-1.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/2/23.
//

import Foundation

struct Day1: DayOfCode {
    var input: DayOfCodeInput
    
    func run() throws {
        let rTwoDigits = /\w*?(\d|one|two|three|four|five|six|seven|eight|nine){1}[\w\d]*(\d|one|two|three|four|five|six|seven|eight|nine){1}/
        let rOneDigit = /\w*?(\d|one|two|three|four|five|six|seven|eight|nine){1}/
        
        var result = 0
        
        for line in input.getDataArray() {
            if let m = line.firstMatch(of: rTwoDigits) {
                result += Int("\(wordToNum(word: m.1))\(wordToNum(word: m.2))") ?? 0
            } else if let m = line.firstMatch(of: rOneDigit) {
                result += Int("\(wordToNum(word: m.1))\(wordToNum(word: m.1))") ?? 0
            }
        }
        
        print("Result: \(result)")
    }
    
    func wordToNum(word: Substring) -> Substring {
        switch word {
        case "one": return "1"
        case "two": return "2"
        case "three": return "3"
        case "four": return "4"
        case "five": return "5"
        case "six": return "6"
        case "seven": return "7"
        case "eight": return "8"
        case "nine": return "9"
        default: return word
        }
    }
}
