//
//  main.swift
//  Day9
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

extension [Int] {
    
    var diffs: [Int] {
        return adjacentPairs().map { $1 - $0 }
    }
}

extension Array {
    var lastIndex: Index { return endIndex - 1 }
}

struct Histories {
    struct History {
        
        // MARK: - Properties
        let values: [Int]
        
        // MARK: - Interface
        func interpolationSequences() -> [[Int]] {
            var sequences = [values]
            var latestSequence = values
            
            while latestSequence.contains(where: { $0 != 0 }) {
                let diffs = latestSequence.diffs
                
                sequences.append(diffs)
                latestSequence = diffs
            }
            
            return sequences
        }
        
        func nextValue() -> Int {
            var sequences = interpolationSequences()
            
            // Add a zero to the end of the last generated list
            sequences[sequences.lastIndex] = sequences[sequences.lastIndex] + [0]
            
            // Walk up the lists, appending the 'interpolated' value
            var index = sequences.count - 2
            while index >= 0 {
                var current = sequences[index]
                let diffs = sequences[index + 1]
                
                current.append(current[current.lastIndex] + diffs[diffs.lastIndex])
                sequences[index] = current
                index -= 1
            }
            
            return sequences[0][sequences[0].lastIndex]
        }
        
        func previousValue() -> Int {
            var sequences = interpolationSequences()
            
            // Add a zero to the beginning of the last generated list
            sequences[sequences.lastIndex] = [0] + sequences[sequences.lastIndex]
            
            // Walk up the lists, prepending the 'interpolated' value
            var index = sequences.count - 2
            while index >= 0 {
                var current = sequences[index]
                let diffs = sequences[index + 1]
                
                current.insert(current[0] - diffs[0], at: 0)
                sequences[index] = current
                index -= 1
            }
            
            return sequences[0][0]
        }
    }
    
    // MARK: - Properties
    let histories: [History]
}

let historyParser = Parse(input: Substring.self, Histories.init) {
    Many {
        Many { Int.parser() } separator: { Whitespace(1, .horizontal) }.map(Histories.History.init)
    } separator: { Whitespace(1, .vertical) }
}

let history = try historyParser.parse(String.input)

measure(part: .one) { logger in
    /* Part One */
    return history.histories
        .map { $0.nextValue() }
        .reduce(0, +)
}

measure(part: .two) { logger in
    /* Part Two */
    return history.histories
        .map { $0.previousValue() }
        .reduce(0, +)
}
