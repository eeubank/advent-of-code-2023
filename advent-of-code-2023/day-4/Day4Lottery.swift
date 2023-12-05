//
//  Day4Lottery.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/4/23.
//

import Foundation

struct Day4Lottery {
    var tickets: [Day4Ticket] = []
    
    init(input: DayOfCodeInput) throws {
        for line in input.getDataArray() {
            let raw = line.split(separator: ":")[1]
                .split(separator: "|")
            try self.tickets.append(Day4Ticket(winningNumbers: String(raw[0]), ticketNumbers: String(raw[1])))
        }
    }
    
    func getTotalPoints() -> Decimal {
        return tickets.map { $0.getPoints() }
            .reduce(0, { acc, n in acc + n })
    }
    
    mutating func getTotalTickets() -> Int {
        for i in 0..<tickets.count {
            let ticket = tickets[i]
            let ticketsWon = ticket.getNumberOfMatches()
            ((i+1)..<(i+1 + ticketsWon)).forEach { tickets[$0].addCopies(amount: ticket.numCopies) }
        }
        return tickets.reduce(0, { acc, ticket in acc + ticket.numCopies })
    }
}

struct Day4Ticket {
    var winningNumbers: [Int]
    var ticketNumbers: Set<Int>
    var numCopies = 1
    
    init(winningNumbers: String, ticketNumbers: String) throws {
        let numRegEx = /(\d+)/
        
        self.winningNumbers = winningNumbers.matches(of: numRegEx)
            .map { Int($0.output.0)! }
        
        self.ticketNumbers = Set(ticketNumbers.matches(of: numRegEx)
            .map { Int($0.output.0)! }
        )
    }
    
    func getNumberOfMatches() -> Int {
        return winningNumbers.filter { ticketNumbers.contains($0) }.count
    }
    
    func getPoints() -> Decimal {
        let numMatches = getNumberOfMatches()
        guard numMatches > 0 else {
            return 0
        }
        return pow(2, numMatches - 1)
    }
    
    mutating func addCopies(amount: Int) {
        numCopies += amount
    }
}
