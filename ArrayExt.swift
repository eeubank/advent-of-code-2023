//
//  ArrayExt.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/3/23.
//

import Foundation

extension Array {
    func printGrid() {
        for case let row as Array<CustomStringConvertible> in self {
            print(row.map { $0.description }.joined(separator: ""))
        }
    }
}
