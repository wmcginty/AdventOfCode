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
}

struct Row {
    
    // MARK: - Row.Status
    struct Status: Hashable {
        
        // MARK: - Properties
        var conditionIndex: Int = 0
        var countsIndex: Int = 0
        var consecutiveDamaged: Int = 0
    }
    
    // MARK: - Properties
    let gearConditions: [Condition]
    let counts: [Int]
    
    // MARK: - Interface
    var unfolded: Row {
        return Row(gearConditions: Array(Array(repeating: gearConditions + [.unknown], count: 5).flatMap { $0 }.dropLast()),
                   counts: Array(repeating: counts, count: 5).flatMap { $0 })
    }
    
    var countOfSolutions: Int {
        func countOfSolutions(_ status: Status, answerTable: inout [Status: Int]) -> Int {
            if let ans = answerTable[status] {
                return ans
            }
            
            if status.conditionIndex == gearConditions.count {
                // We have finished iterating over all the gears
                
                if status.countsIndex == counts.count, status.consecutiveDamaged == 0 {
                    //We have finished iterating over all the `counts`, and there is no unaccounted for damaged gears. Valid.
                    return 1
                } else if status.countsIndex == counts.count - 1, counts[status.countsIndex] == status.consecutiveDamaged {
                    // We are on the last `count` and the current amount of damaged gears matches that last `count`. Valid.
                    return 1
                } else {
                    // Invalid
                    return 0
                }
            }
            
            // The status isn't done iterating, ensure we capture all the possibilities
            var answer = 0
            for condition in [Condition.operational, .damaged] {
                if gearConditions[status.conditionIndex] == condition || gearConditions[status.conditionIndex] == .unknown {
                    /* We only want to do further processing when the next gear is the status one we're looking at (`condition`), or `.unknown`, so we can consider it as either damaged or operational. */
                    
                    if condition == .operational && status.consecutiveDamaged == 0 {
                        // This is an operational gear, and there is no existing streak of damaged gears. Move to the next gear.
                        answer += countOfSolutions(.init(conditionIndex: status.conditionIndex + 1,
                                                         countsIndex: status.countsIndex,
                                                         consecutiveDamaged: 0), 
                                                   answerTable: &answerTable)
                        
                        
                    } else if condition == .operational,
                              status.consecutiveDamaged > 0,
                              status.countsIndex < counts.count,
                              counts[status.countsIndex] == status.consecutiveDamaged {
                        /* This is an operational gear, there is an existing streak of damaged gears, there are remaining `counts` (meaning this streak is expected),
                         and the current amount of damaged gears matches that corresponding `count`. Move to the next gear, move to the next count and reset the streak. */
                        answer += countOfSolutions(.init(conditionIndex: status.conditionIndex + 1,
                                                         countsIndex: status.countsIndex + 1,
                                                         consecutiveDamaged: 0), 
                                                   answerTable: &answerTable)
                        
                    } else if condition == .damaged {
                        // This is a damaged gear. Move to the next index, and increment the current streak.
                        answer += countOfSolutions(.init(conditionIndex: status.conditionIndex + 1,
                                                         countsIndex: status.countsIndex,
                                                         consecutiveDamaged: status.consecutiveDamaged + 1), 
                                                   answerTable: &answerTable)
                    }
                }
            }
            
            // Put this answer in the cache, so if we see it again we don't have to recompute
            answerTable[status] = answer
            return answer
        }
        
        // Start at the beginning of the row, passing along an answer cache
        var answerTable: [Status: Int] = [:]
        return countOfSolutions(.init(), answerTable: &answerTable)
    }
}

let conditionParser = Parse(input: Substring.self) { Condition.parser() }
let conditionsParser = Many { conditionParser } terminator: { Whitespace() }
let countsParser = Many { Parse(input: Substring.self) { Int.parser() } } separator: { "," }
let lineParser = Parse(Row.init) {
    conditionsParser
    countsParser
}
let inputParser = Many { lineParser } separator: { Whitespace(1, .vertical) }
let rows = try inputParser.parse(String.input)

measure(part: .one) { logger in
    /* Part One */
    return rows.map(\.countOfSolutions).reduce(0, +)
}

measure(part: .two) { logger in
    /* Part Two */
    return rows.map(\.unfolded.countOfSolutions).reduce(0, +)
}
