//
//  main.swift
//  Day12
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Condition: String, CaseIterable {
    case operational = "."
    case damaged = "#"
    case unknown = "?"

    func isCaseOrUnknown(_ test: Self) -> Bool {
        return self == test || self == .unknown
    }
}

struct Row {

    // MARK: - Row.State
    struct State: Hashable {
        var conditionIndex: Int = 0
        var countIndex: Int = 0
        var streak: Int = 0
    }

    // MARK: - Properties
    let gearConditions: [Condition]
    let counts: [Int]

    // MARK: - Interface
    func unfolded(times: Int) -> Row {
        return Row(gearConditions: Array(repeating: gearConditions, count: times).interspersed(with: [.unknown]).flatMap { $0 },
                   counts: Array(repeating: counts, count: times).flatMap { $0 })
    }

    var countOfValidSolutions: Int {
        func countOfValidSolutions(given state: State, cache: inout [State: Int]) -> Int {
            if let cached = cache[state] {
                return cached
            }

            if state.conditionIndex == gearConditions.count {
                // We have finished iterating over all the gears

                if state.countIndex == counts.count, state.streak == 0 {
                    // Valid: We have accounted for all the expected streaks, and there is no current streak.
                    return 1

                } else if state.countIndex == counts.count - 1, state.streak == counts[state.countIndex] {
                    // Valid: There is 1 final unaccounted for streak, and it matches the current streak.
                    return 1

                } else {
                    // Invalid: All other ending cases.
                    return 0
                }
            }

            var answer = 0
            let currentCondition = gearConditions[state.conditionIndex]
            if currentCondition.isCaseOrUnknown(.operational) {
                // This is an operational/unknown gear (treat it as though it's operational).

                if state.streak == 0 {
                    // There is no existing streak of damaged gears. Move to the next gear.
                    answer += countOfValidSolutions(given: .init(conditionIndex: state.conditionIndex + 1, countIndex: state.countIndex, streak: 0), 
                                                    cache: &cache)
                } else if state.streak > 0, state.countIndex < counts.count, counts[state.countIndex] == state.streak {
                    // There was a streak of damaged gears, and there are remaining streaks expected. Finally, the streak that is about to end matches the next expected streak. Move to the next gear, next expected streak, and reset the current streak.
                    answer += countOfValidSolutions(given: .init(conditionIndex: state.conditionIndex + 1, countIndex: state.countIndex + 1, streak: 0), 
                                                    cache: &cache)
                }
            }

            if currentCondition.isCaseOrUnknown(.damaged) {
                // This is an damaged/unknown gear (treat it as though it's damaged). Move to the next gear, and increment the current streak.
                answer += countOfValidSolutions(given: .init(conditionIndex: state.conditionIndex + 1, countIndex: state.countIndex, streak: state.streak + 1), 
                                                cache: &cache)
            }

            cache[state] = answer
            return answer
        }

        var cache: [State: Int] = [:]
        return countOfValidSolutions(given: State(), cache: &cache)
    }
}

let conditionParser = Parse(input: Substring.self) { Condition.parser() }
let conditionsParser = Many { conditionParser } terminator: { Whitespace() }
let countsParser = Many { Parse(input: Substring.self) { Int.parser() } } separator: { "," }
let lineParser = Parse(Row.init) { conditionsParser; countsParser }
let inputParser = Many { lineParser } separator: { Whitespace(1, .vertical) }
let rows = try inputParser.parse(String.input)

measure(part: .one) { logger in
    /* Part One */
    return rows.map(\.countOfValidSolutions).reduce(0, +)
}

measure(part: .two) { logger in
    /* Part Two */
    return rows
        .map { $0.unfolded(times: 5) }
        .map(\.countOfValidSolutions)
        .reduce(0, +)
}
