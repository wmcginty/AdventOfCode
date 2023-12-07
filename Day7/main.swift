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
        
        // MARK: - Preset
        static var allValidInJokerGames: [Card] {
            var all = Set(Game.Card.allCases)
            all.remove(.joker)
            all.remove(.jack)
            
            return Array(all)
        }
        
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
        var replacingJacks: Hand { return Self(cards: cards.map { $0 == .jack ? .joker : $0 }) }
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
        let containsJoker = contains { $0 == .joker }
        if containsJoker {
            var transformedHands: Set<[Game.Card]> = []
            for (index, card) in zip(indices, self) {
                if card == .joker {
                    for newCard in Game.Card.allValidInJokerGames {
                        var modifiedCards = self
                        modifiedCards[index] = newCard
                        
                        transformedHands.insert(modifiedCards)
                    }
                }
            }
            
            return transformedHands.map(\.kind).min() ?? .highCard
            
        } else if Set(self).count == 1 {
            return .fiveOfAKind
        } else {
            let dict = Dictionary(grouping: self, by: { $0.rawValue })
            if dict.contains(where: { $0.value.count == 4 }) {
                return .fourOfAKind
            } else if dict.contains(where: { $0.value.count == 3}) {
                if dict.contains(where: { $0.value.count == 2 }) {
                    return .fullHouse
                } else {
                    return .threeOfAKind
                }
            } else {
                let pairs = dict.filter { $0.value.count == 2 }
                if pairs.count == 2 {
                    return .twoPair
                } else if pairs.count == 1 {
                    return .pair
                } else {
                    return .highCard
                }
            }
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

measure(part: .one) { logger in
    /* Part One */
    
    return game.rounds.sorted().reversed().enumerated()
        .map { ($0.offset + 1) * $0.element.bid }
        .reduce(0, +)
}

measure(part: .two) { logger in
    /* Part Two */
    
    var jokerRounds: [Game.Round] = []
    for (offset, round) in game.rounds.enumerated() {
        let jokerRound = Game.Round(hand: round.hand.replacingJacks, bid: round.bid)
        jokerRounds.append(jokerRound)
        
        if offset > 0, offset.isMultiple(of: 500) {
            logger.fault("Finished modifying \(offset)/\(game.rounds.count) hands.")
        }
    }
    
    logger.fault("Finished modying all hands.")
    return Game(rounds: jokerRounds).rounds.sorted().reversed().enumerated()
        .map { ($0.offset + 1) * $0.element.bid }
        .reduce(0, +)
}

