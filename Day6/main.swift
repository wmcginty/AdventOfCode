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

measure(part: .one) { logger in
    /* Part One */
    return races.races.map { $0.possibleWinningStrategyCount() }.reduce(1, *)
}

measure(part: .two) { logger in
    /* Part Two */
    return races.combinedRace.possibleWinningStrategyCount()
}
