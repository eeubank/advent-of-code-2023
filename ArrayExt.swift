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

extension Array<Int> {
    func sum() -> Int {
        return self.reduce(0, { acc, n in acc + n })
    }
}
