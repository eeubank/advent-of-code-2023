//
//  Day7CamelCards.swift
//  advent-of-code-2023
//
//  Created by Eric Eubank on 12/7/23.
//

import Foundation

struct Day7CamelCards {
    var hands: [Day7Hand]
    var handsJokersAreWild: [Day7Hand]
    
    init (input: DayOfCodeInput) {
        hands = input.getDataArray().map { Day7Hand(input: $0) }
        hands.sort()
        //print(hands.map { ($0.cardsRaw, $0.strength) })
        
        handsJokersAreWild = input.getDataArray().map { Day7Hand(input: $0, jokersAreWild: true) }
        handsJokersAreWild.sort()
        //print(handsJokersAreWild.map { ($0.cardsRaw, $0.strength) })
    }
    
    func getWinnings(jokersAreWild: Bool = false) -> Int {
        let handsToPlay = jokersAreWild ? handsJokersAreWild : hands
        return handsToPlay.enumerated().map { i, hand in hand.bet * (i + 1) }
            .reduce(0, {acc, winnings in acc + winnings })
    }
}

struct Day7Hand: Comparable {
    var cardsRaw: String
    var cards: [Day7Card]
    var bet: Int
    var strength: Day7HandStrength?
    
    init(input: String, jokersAreWild: Bool = false) {
        let parts = input.components(separatedBy: " ")
        cardsRaw = jokersAreWild ? parts[0].replacingOccurrences(of: "J", with: "W") : parts[0]
        cards = cardsRaw.enumerated().map { Day7Card(rawValue: String($0.element))! }
        bet = Int(parts[1])!
        strength = getHandStrength(cards)
    }
    
    static func < (lhs: Day7Hand, rhs: Day7Hand) -> Bool {
        if lhs.strength == rhs.strength {
            for i in 0...3 {
                if lhs.cards[i] != rhs.cards[i] {
                    return lhs.cards[i] < rhs.cards[i]
                }
            }
            return lhs.cards[4] < rhs.cards[4]
        } else {
            return lhs.strength! < rhs.strength!
        }
    }
    
    private func getHandStrength(_ cards: [Day7Card]) -> Day7HandStrength {
        let countedSet = NSCountedSet(array: cards)
        var countedCards = countedSet.enumerated().map { _, card in (card: card as! Day7Card, count: countedSet.count(for: card)) }
            .sorted(by: sortCountedCards)
        
        if countedCards.last!.card == .W && countedCards.first!.card != .W {
            countedCards[0].count += countedCards.last!.count
        }
        
        switch countedCards.first!.count {
        case 5: return .FiveOfKind
        case 4: return .FourOfKind
        case 3: return countedCards[1].count == 2 ? .fullHouse : .threeOfKind
        case 2: return countedCards[1].count == 2 ? .twoPair : .onePair
        default: return .highCard
        }
    }
    
    private func sortCountedCards(lhs: (card: Day7Card, count: Int), rhs: (card: Day7Card, count: Int)) -> Bool {
        return lhs.card == .W ? false : rhs.card == .W ? true : lhs.count > rhs.count
    }
}

enum Day7Card: String, Comparable {
    case W = "W"
    case N2 = "2"
    case N3 = "3"
    case N4 = "4"
    case N5 = "5"
    case N6 = "6"
    case N7 = "7"
    case N8 = "8"
    case N9 = "9"
    case T = "T"
    case J = "J"
    case Q = "Q"
    case K = "K"
    case A = "A"
    
    func getRelativeValue() -> Int {
        switch self {
        case .W: return 1
        case .N2: return 2
        case .N3: return 3
        case .N4: return 4
        case .N5: return 5
        case .N6: return 6
        case .N7: return 7
        case .N8: return 8
        case .N9: return 9
        case .T: return 10
        case .J: return 11
        case .Q: return 12
        case .K: return 13
        case .A: return 14
        }
    }
    
    static func < (lhs: Day7Card, rhs: Day7Card) -> Bool {
        return lhs.getRelativeValue() < rhs.getRelativeValue()
    }
}

enum Day7HandStrength: Int, Comparable {
    case highCard
    case onePair
    case twoPair
    case threeOfKind
    case fullHouse
    case FourOfKind
    case FiveOfKind
    
    static func < (lhs: Day7HandStrength, rhs: Day7HandStrength) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
