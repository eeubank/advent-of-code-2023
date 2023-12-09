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
        
    case "4":
        dayOfCode = Day4(input: Day4Input())
    case "4s":
        dayOfCode = Day4(input: Day4InputSample());
        
    case "5":
        dayOfCode = Day5(input: Day5Input())
    case "5s":
        dayOfCode = Day5(input: Day5InputSample());
        
    case "6":
        dayOfCode = Day6(input: Day6Input())
    case "6s":
        dayOfCode = Day6(input: Day6InputSample());
        
    case "7":
        dayOfCode = Day7(input: Day7Input())
    case "7s":
        dayOfCode = Day7(input: Day7InputSample());
        
    case "8":
        dayOfCode = Day8(input: Day8Input())
    case "8s1":
        dayOfCode = Day8(input: Day8InputSampleA());
    case "8s2":
        dayOfCode = Day8(input: Day8InputSampleB());
    case "8s3":
        dayOfCode = Day8(input: Day8InputSampleC());
        
    default:
        print("Day not completed!")
        exit(-1)
    }
    
    try dayOfCode.run();
}
