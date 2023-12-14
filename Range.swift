//
//  Range.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/13/23.
//

import Foundation

extension ClosedRange<Int> {
    func withMin(_ value: Int) -> ClosedRange {
        return value...self.upperBound
    }
    
    func withMax(_ value: Int) -> ClosedRange {
        return self.lowerBound...value
    }
    
    func incMin() -> ClosedRange {
        return (self.lowerBound + 1)...self.upperBound
    }
}
