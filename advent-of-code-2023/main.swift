//
//  main.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/2/23.
//

import Foundation

var dayOfCode: DayOfCode

print("Pick a day (1-25):");
if let dayInput = readLine() {
    switch dayInput {
    case "1":
        dayOfCode = Day1(input: Day1Input());
    case "1s1":
        dayOfCode = Day1(input: Day1InputSample1());
    case "1s2":
        dayOfCode = Day1(input: Day1InputSample2());
        
    case "2":
        dayOfCode = Day2(input: Day2Input())
    case "2s":
        dayOfCode = Day2(input: Day2InputSample());
        
    case "3":
        dayOfCode = Day3(input: Day3Input())
    case "3s":
        dayOfCode = Day3(input: Day3InputSample());
        
    default:
        print("Day not completed!")
        exit(-1)
    }
    
    try dayOfCode.run();
}
