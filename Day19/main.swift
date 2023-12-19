//
//  main.swift
//  Day19
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing
import os

enum Category: String, CaseIterable {
    case extremelyCool = "x"
    case musical = "m"
    case aerodynamic = "a"
    case shiny = "s"
}

struct Part {

    // MARK: - Properties
    let extremelyCoolRating: Int64
    let musicalRating: Int64
    let aerodynamicRating: Int64
    let shinyRating: Int64

    // MARK: - Interface
    var ratingSum: Int64 { return Category.allCases.map(value(for:)).reduce(0,+) }

    func value(for category: Category) -> Int64 {
        switch category {
        case .aerodynamic: return aerodynamicRating
        case .extremelyCool: return extremelyCoolRating
        case .musical: return musicalRating
        case .shiny: return shinyRating
        }
    }
}

struct Workflow {

    enum Rule {
        enum Comparison: String, CaseIterable {
            case lessThan = "<"
            case greaterThan = ">"
        }
        
        enum Outcome: Equatable {
            case accepted
            case rejected
            case destination(String)

            var acceptedValue: Bool? { return self == .accepted ? true : self == .rejected ? false : nil }
            var workflowName: String? {
                switch self {
                case .destination(let str): return str
                default: return nil
                }
            }
        }
        
        case rule(Category, Comparison, Int64, Outcome)
        case otherwise(Outcome)
        
        // MARK: - Interface
        func validRange(for cat: Category) -> Range<Int64> {
            switch self {
            case .otherwise: return 1..<4001
            case .rule(let category, let comparison, let value, _):
                guard category == cat else { return 1..<4001 }
                switch comparison {
                case .lessThan: return 1..<value
                case .greaterThan: return value + 1..<40001
                }
            }
        }

        func failureRange(for cat: Category) -> Range<Int64> {
            switch self {
            case .otherwise: return 1..<4001
            case .rule(let category, let comparison, let value, _):
                guard category == cat else { return 1..<4001 }
                switch comparison {
                case .lessThan: return value..<40001
                case .greaterThan: return 1..<value + 1
                }
            }
        }

        func outcome(for part: Part) -> Outcome? {
            switch self {
            case .otherwise(let outcome): return outcome
            case .rule(let category, let comparison, let value, let outcome):
                let actual = part.value(for: category)
                switch comparison {
                case .greaterThan: return actual > value ? outcome : nil
                case .lessThan: return actual < value ? outcome : nil
                }
            }
        }
    }
    
    // MARK: - Properties
    let name: String
    let rules: [Rule]
    
    // MARK: - Interface
    func outcome(for part: Part) -> Workflow.Rule.Outcome {
        for rule in rules {
            if let outcome = rule.outcome(for: part) {
                return outcome
            }
        }
        
        fatalError("Ran out of rules running: \(self).")
    }
}

let (workflows, parts) = try inputParser.parse(String.input)
let workflowDictionary = Dictionary(uniqueKeysWithValues: workflows.map { ($0.name, $0) })
let initialWorkflow = workflowDictionary["in"]!

extension Range<Int64> {

    func intersected(with other: Range<Int64>) -> Range<Int64> {
        return intersection(with: other) ?? 0..<0
    }
}

measure(part: .one) { (logger: Logger) -> Int64 in
    /* Part One */

    func outcome(for part: Part, in workflow: Workflow?) -> Bool {
        let initialOutcome = (workflow ?? initialWorkflow).outcome(for: part)

        switch initialOutcome {
        case .accepted: return true
        case .rejected: return false
        case .destination(let string): return outcome(for: part, in: workflowDictionary[string])
        }
    }

    return parts.filter { outcome(for: $0, in: nil) }.map(\.ratingSum).reduce(0, +)
}

measure(part: .two) { (logger: Logger) -> Int64 in
    /* Part Two */

    struct State: Hashable {
        let workflowName: String
        let extremelyCoolRange: Range<Int64>
        let musicalRange: Range<Int64>
        let aerodynamicRange: Range<Int64>
        let shinyRange: Range<Int64>
        let accepted: Bool?

        func updating(range: Range<Int64>, for category: Category) -> Self {
            return .init(workflowName: workflowName,
                         extremelyCoolRange: category == .extremelyCool ? range.intersected(with: extremelyCoolRange) : extremelyCoolRange,
                         musicalRange:  category == .musical ? range.intersected(with: musicalRange) : musicalRange,
                         aerodynamicRange:  category == .aerodynamic ? range.intersected(with: aerodynamicRange) : aerodynamicRange,
                         shinyRange:  category == .shiny ? range.intersected(with: shinyRange) : shinyRange, accepted: accepted)
        }
    }
    
    var answer: Int64 = 0
    var deque = Deque<State>([.init(workflowName: "in", extremelyCoolRange: 1..<4001, musicalRange: 1..<4001, aerodynamicRange: 1..<4001, shinyRange: 1..<4001, accepted: nil)])
    while let next = deque.popFirst() {
        if let accepted = next.accepted {
            if accepted {
                answer += Int64(next.extremelyCoolRange.count) * Int64(next.musicalRange.count) * Int64(next.aerodynamicRange.count) * Int64(next.shinyRange.count)
            }
            
            continue
        }

        let workflow = workflowDictionary[next.workflowName]!

        var state = next
        for rule in workflow.rules {
            // Pass this rule, and move to it's outcome
            switch rule {
            case .otherwise(let outcome):
                // The workflow name shouldn't matter here, we'll process and discard the 'accepted' state before we check it's workflow name.
                let newState = State(workflowName: outcome.workflowName ?? state.workflowName, extremelyCoolRange: state.extremelyCoolRange, musicalRange: state.musicalRange,
                                     aerodynamicRange: state.aerodynamicRange, shinyRange: state.shinyRange, accepted: outcome.acceptedValue)
                deque.append(newState)

            case .rule(let category, _, _, let outcome):
                let successRange = rule.validRange(for: category)
                let updatedState = state.updating(range: successRange, for: category)

                // Use the outcome's workflow name if it's present, or keep the current one. If the outcome doesn't have a new workflow name, we'll process and discard the 'accepted' state before we check it's workflow name.
                let newState = State(workflowName: outcome.workflowName ?? updatedState.workflowName, extremelyCoolRange: updatedState.extremelyCoolRange, musicalRange: updatedState.musicalRange,
                                     aerodynamicRange: updatedState.aerodynamicRange, shinyRange: updatedState.shinyRange, accepted: outcome.acceptedValue)
                deque.append(newState)
            }

            // Fail this rule, and move on to the next one
            switch rule {
            case .otherwise(_):
                // You can't fail this rule, and we processed the success already - continue
                continue

            case .rule(let category, _, _, _):
                let failureRange = rule.failureRange(for: category)
                state = state.updating(range: failureRange, for: category)
                continue
            }
        }
    }

    return answer
}


