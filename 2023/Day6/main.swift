//
//  main.swift
//  Day6
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Races {
    
    // MARK: - Properties
    let times: [Int]
    let distances: [Int]
    
    // MARK: - Interface
    var races: [Race] { return zip(times, distances).map(Race.init) }
    var combinedRace: Race {
        let time = Int(times.map(String.init).joined())!
        let distance = Int(distances.map(String.init).joined())!
        return .init(time: time, recordDistance: distance)
    }
}

struct Race {
    
    // MARK: - Properties
    let time: Int
    let recordDistance: Int
    
    // MARK: - Interface
    func distance(ifHeldForMilliseconds ms: Int) -> Int { return (time - ms) * ms }
    func possibleWinningStrategyCount() -> Int {
        return (1..<time)
            .map(distance(ifHeldForMilliseconds:))
            .filter{ $0 > recordDistance }.count
    }
    
    func optimizedPossibleWinningStrategyCount() -> Int {
        var low = 0
        var high = time / 2
        
        if distance(ifHeldForMilliseconds: high) < recordDistance {
            //if it doesn't work at the midpoint, it's not going to work ever
            return 0
        }
        
        while low + 1 < high {
            let mid = (low + high) / 2
            if distance(ifHeldForMilliseconds: mid) >= recordDistance {
                high = mid
            } else {
                low = mid
            }
        }
        
        let first = low + 1
        let last = time / 2 + (time / 2 - first) + (time.isMultiple(of: 2) ? 0 : 1)
        return last - first + 1
    }
}

let parser = Parse(input: Substring.self, Races.init) {
    "Time:"
    Whitespace(.horizontal)
    Many { Int.parser() } separator: { Whitespace(.horizontal) }
    
    Whitespace(1, .vertical)
    
    "Distance:"
    Whitespace(.horizontal)
    Many { Int.parser() } separator: { Whitespace(.horizontal) }
}

let races = try parser.parse(String.input)

measure(part: .one) {
    /* Part One */
    return races.races.map { $0.possibleWinningStrategyCount() }.reduce(1, *)
}

measure(part: .one) {
    /* Part One - Binary Search */
    return races.races.map { $0.optimizedPossibleWinningStrategyCount() }.reduce(1, *)
}

measure(part: .two) {
    /* Part Two */
    return races.combinedRace.possibleWinningStrategyCount()
}

measure(part: .two) {
    /* Part Two - Binary Search */
    return races.combinedRace.optimizedPossibleWinningStrategyCount()
}
