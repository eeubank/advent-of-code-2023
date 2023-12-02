//
//  Input.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/2/23.
//

import Foundation

protocol DayOfCodeInput {
    var data: String {get}
}

extension DayOfCodeInput {
    func getData() -> String {
        return data
    }
    
    func getDataArray() -> [String] {
        return getData().components(separatedBy: "\n")
    }
}
