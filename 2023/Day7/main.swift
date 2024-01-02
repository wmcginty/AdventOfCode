//
//  main.swift
//  Day7
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Game {
    
    struct Round: Comparable {
        
        // MARK: - Properties
        let hand: Hand
        let bid: Int
        
        // MARK: - Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.hand < rhs.hand
        }
    }
    
    enum Card: String, CaseIterable, Equatable, Comparable {
        case ace = "A"
        case king = "K"
        case queen = "Q"
        case jack = "J"
        case ten = "T"
        case nine = "9"
        case eight = "8"
        case seven = "7"
        case six = "6"
        case five = "5"
        case four = "4"
        case three = "3"
        case two = "2"
        case joker = "X"

        // MARK: - Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            let lhsIndex = Card.allCases.firstIndex(of: lhs)!
            let rhsIndex = Card.allCases.firstIndex(of: rhs)!
            
            return lhsIndex < rhsIndex
        }
    }
    
    enum Kind: Int, Equatable, Comparable {
        case fiveOfAKind
        case fourOfAKind
        case fullHouse
        case threeOfAKind
        case twoPair
        case pair
        case highCard
        
        // MARK: - Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    struct Hand: Hashable, Comparable {
        
        // MARK: - Properties
        let cards: [Card]
        let kind: Kind
        
        // MARK : - Initializer
        init(cards: [Card]) {
            self.cards = cards
            self.kind = cards.kind // Do this once so we aren't repeating the calculation a lot when sorting
        }
        
        // MARK: - Interface
        var replacingJacks: Hand { return .init(cards: cards.map { $0 == .jack ? .joker : $0 }) }
        var description: String { return cards.map(\.rawValue).joined() }
        
        // MARK: - Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            if lhs.kind < rhs.kind {
                return true
            } else if lhs.kind > rhs.kind {
                return false
            } else {
                for (l, r) in zip(lhs.cards, rhs.cards) {
                    if l == r {
                        continue
                    }
                    
                    return l < r
                }
                
                return true
            }
        }
    }
    
    // MARK: - Properties
    let rounds: [Round]
}

// MARK: - Array<Game.Card> Convenience
extension Array where Element == Game.Card {
    
    var kind: Game.Kind {
        if Set(self).count == 1 {
            return .fiveOfAKind
        }
        
        let grouped = Dictionary(grouping: filter { $0 != .joker }, by: { $0.rawValue })
        let commonCounts = grouped.values.map(\.count).sorted(by: { $0 > $1 })

        let jokerCount = filter { $0 == .joker }.count
        let highestCommonCount = commonCounts.first ?? 0
        let secondHighestCommonCount = commonCounts.endIndex > 1 ? commonCounts[1] : 0
        
        if jokerCount + highestCommonCount == 5 {
            return .fiveOfAKind
        }
        
        if jokerCount + highestCommonCount == 4 {
            return .fourOfAKind
        }
        
        // At this point, definitely don't have five our four of a kind. Figure out the rest of the kinds.

        switch (highestCommonCount, jokerCount) {
        case (3, 0):
            // No jokers. 3 + 2 is a full house, 3 and anything else is 3 of a kind
            return secondHighestCommonCount == 2 ? .fullHouse : .threeOfAKind
        case (2, 1):
            // 1 joker. 2 (+1 joker) + 2 is a full house. 2 (+1 joker) and anything else is 3 of a kind
            return secondHighestCommonCount == 2 ? .fullHouse : .threeOfAKind
        case (2, 0):
            // No jokers. 2 + 2 is two pair, and anything else is a pair.
            return secondHighestCommonCount == 2 ? .twoPair : .pair
        case (1, 2): 
            // 2 jokers. 1 (+2 jokers) is three of a kind.
            return .threeOfAKind
        case (1, 1): 
            // 1 joker. 1 (+1 joker) is a pair.
            return .pair
        default: 
            // This hand sucks
            return .highCard
        }
    }
}

let handParser = Parse(input: Substring.self, Game.Hand.init) {
    Many(5, element: { Game.Card.parser() })
}

let roundParser = Parse(Game.Round.init) {
    handParser
    Whitespace()
    Int.parser()
}

let gameParser = Many { roundParser } separator: { Whitespace(1, .vertical) }.map(Game.init)
var game = try gameParser.parse(String.input)

measure(part: .one) {
    /* Part One */
    
    return game.rounds.sorted().reversed().enumerated()
        .map { ($0.offset + 1) * $0.element.bid }
        .reduce(0, +)
}

measure(part: .two) {
    /* Part Two */
    
    let jokerGame =  Game(rounds: game.rounds.map { .init(hand: $0.hand.replacingJacks, bid: $0.bid )})
    return jokerGame.rounds.sorted().reversed().enumerated()
        .map { ($0.offset + 1) * $0.element.bid }
        .reduce(0, +)
}

