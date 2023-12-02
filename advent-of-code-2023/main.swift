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
        
    default:
        print("Day not completed!")
        exit(-1)
    }
    
    dayOfCode.run();
}
