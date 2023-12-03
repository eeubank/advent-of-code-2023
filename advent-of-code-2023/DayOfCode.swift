//
//  day-of-code.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/2/23.
//

import Foundation

protocol DayOfCode {
    var input: DayOfCodeInput {get}
    
    func run() throws -> Void
}
