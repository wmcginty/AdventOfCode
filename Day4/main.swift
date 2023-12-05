//
//  main.swift
//  Day4
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Collections
import Foundation
import Parsing

struct Card {
    
    let id: Int
    let winningNumbers: Set<Int>
    let containedNumbers: Set<Int>
    
    var containedWinningNumbers: Set<Int> { return containedNumbers.intersection(winningNumbers) }
    var value: Int {
        let count = containedWinningNumbers.count
        
        if count <= 1 {
            return count
        } else {
            return 1 * 2 ^^ (count - 1)
        }
    }
}

let card = Parse(input: Substring.self, Card.init) {
    "Card"
    Whitespace()
    Int.parser()
    ":"
    Whitespace()
    Many { Int.parser() } separator: { Whitespace(.horizontal) }.map(Set.init)
    Whitespace()
    "|"
    Whitespace()
    Many { Int.parser() } separator: { Whitespace(.horizontal) }.map(Set.init)
}
let cards = Many { card } separator: { "\n" }

let parsedCards = try cards.parse(String.input)
let reference: [Int: Card] = Dictionary(uniqueKeysWithValues: parsedCards.map { ($0.id, $0) })

measure(part: .one) {
    /* Part One */
    
    return parsedCards
        .map(\.value)
        .reduce(0, +)
}

//Brute force works, but is dangerously slow
measure(part: .two) {
    /* Part Two */
    
    var queue = Deque<Card>(parsedCards)
    var count = 0
    while let first = queue.popFirst() {
        count += 1
        
        let winningCount = first.containedWinningNumbers.count
        let wonCardIDs = (first.id + 1)..<(first.id + winningCount + 1)
            
        for id in wonCardIDs {
            let copy = reference[id]!
            queue.append(copy)
        }
    }
    
    return count
}

// If you just keep track of the count of each kind of card you have, it's... much faster
measure(part: .two) {
    /* Part Two */
    
    var countsByID: [Int: Int] = [:]
    for card in parsedCards {
        countsByID[card.id, default: 0] += 1
        
        let winningCount = card.containedWinningNumbers.count
        for idx in 0..<winningCount {
            // Take the count of the source card, and add that to each of the 'won' cards
            countsByID[card.id + idx + 1, default: 0] += countsByID[card.id] ?? 0
        }
    }
    
    return countsByID.values.reduce(0, +)
}
