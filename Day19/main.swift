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
        
        fatalError("Ran out of rules running (which shouldn't be possible because the last is always 'else'): \(self).")
    }
}

let (workflows, parts) = try inputParser.parse(String.input)
let workflowDictionary = Dictionary(uniqueKeysWithValues: workflows.map { ($0.name, $0) })
let initialWorkflow = workflowDictionary["in"]!

measure(part: .one) { () -> Int64 in
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

measure(part: .two) { () -> Int64 in
    /* Part Two */

    struct State: Hashable {
        let workflowName: String
        let extremelyCoolRange: Range<Int64>?
        let musicalRange: Range<Int64>?
        let aerodynamicRange: Range<Int64>?
        let shinyRange: Range<Int64>?
        let accepted: Bool?

        var hasNilRange: Bool {
            return extremelyCoolRange == nil || musicalRange == nil || aerodynamicRange == nil || shinyRange == nil
        }

        var totalUniqueCombinations: Int64 {
            guard let extremelyCoolRange, let musicalRange, let aerodynamicRange, let shinyRange else { return 0 /* The ranges go nil when they're empty, meaning there is no possible part that satisfies */ }
            return Int64(extremelyCoolRange.count) * Int64(musicalRange.count) * Int64(aerodynamicRange.count) * Int64(shinyRange.count)
        }

        func updating(range: Range<Int64>, for category: Category) -> Self {
            return .init(workflowName: workflowName,
                         extremelyCoolRange: category == .extremelyCool ? extremelyCoolRange?.intersection(with: range) : extremelyCoolRange,
                         musicalRange:  category == .musical ? musicalRange?.intersection(with: range) : musicalRange,
                         aerodynamicRange:  category == .aerodynamic ? aerodynamicRange?.intersection(with: range) : aerodynamicRange,
                         shinyRange:  category == .shiny ? shinyRange?.intersection(with: range) : shinyRange, accepted: accepted)
        }
    }

    var answer: Int64 = 0
    var deque = Deque<State>([.init(workflowName: "in", extremelyCoolRange: 1..<4001, musicalRange: 1..<4001, aerodynamicRange: 1..<4001, shinyRange: 1..<4001, accepted: nil)])
    while let next = deque.popFirst() {
        if next.hasNilRange {
            continue
        }

        if let accepted = next.accepted {
            if accepted {
                answer += next.totalUniqueCombinations
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
                // Find the range of possibilities to pass this rule, and intersect that with the state's current range. If no intersection, nil out that range.
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
                // Find the range of possibilities to fail this rule, and intersect that with the state's current range. If no intersection, nil out that range.
                let failureRange = rule.failureRange(for: category)
                state = state.updating(range: failureRange, for: category)
                continue
            }
        }
    }

    return answer
}
