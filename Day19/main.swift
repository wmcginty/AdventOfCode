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
    let extremelyCoolRating: Int // 1 - 4000
    let musicalRating: Int // 1 - 4000
    let aerodynamicRating: Int // 1 - 4000
    let shinyRating: Int // 1 - 4000
    
    // MARK: - Interface
    var ratingSum: Int { return Category.allCases.map(value(for:)).reduce(0,+) }
    
    func value(for category: Category) -> Int {
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
        
        enum Outcome {
            case accepted
            case rejected
            case destination(String)
        }
        
        case rule(Category, Comparison, Int, Outcome)
        case otherwise(Outcome)
        
        // MARK: - Interface
        func validRange(for cat: Category) -> ClosedRange<Int> {
            switch self {
            case .otherwise: return 1...4000
            case .rule(let category, let comparison, let value, _):
                guard category == cat else { return 1...4000 }
                switch comparison {
                case .lessThan: return 1...value - 1
                case .greaterThan: return value + 1...4000
                }
            }
        }
        func outcome(for part: Part) -> Outcome? {
            switch self {
            case .otherwise(let outcome): return outcome
            case .rule(let category, let comparison, let value, let outcome):
                let actual = part.value(for: category)
                switch comparison {
                case .greaterThan:
                    if actual > value {
                        return outcome
                    }
                    
                case .lessThan:
                    if actual < value {
                        return outcome
                    }
                }
            }
            
            return nil
        }
    }
    
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

// MARK: - Parsing
extension Part {
    static let parser = Parse(input: Substring.self, Part.init) {
        "{x="
        Int.parser()
        ",m="
        Int.parser()
        ",a="
        Int.parser()
        ",s="
        Int.parser()
        "}"
    }
}

extension Workflow.Rule.Outcome {
    static let parser = Parse(input: Substring.self) {
        OneOf(input: Substring.self) {
            "R".map { _ in Workflow.Rule.Outcome.rejected }
            "A".map { _ in Workflow.Rule.Outcome.accepted }
            Prefix { $0 != "," && $0 != "}" }.map { Workflow.Rule.Outcome.destination(String($0)) }
        }
    }
}

extension Workflow.Rule {
    static let parser = Parse(input: Substring.self) {
        OneOf {
            Parse {
                Category.parser()
                Comparison.parser()
                Int.parser()
                ":"
                Workflow.Rule.Outcome.parser
            }.map { Workflow.Rule.rule($0, $1, $2, $3) }
            
            Outcome.parser.map { Workflow.Rule.otherwise($0) }
        }
    }
}

extension Workflow {
    static let parser = Parse(input: Substring.self, Workflow.init) {
        Prefix(1...) { $0 != "{" }.map(String.init)
        "{"
        Many { Rule.parser } separator: { "," }
        "}"
    }
}

let workflowsParser = Many { Workflow.parser } separator: { Whitespace(.vertical) } terminator: { Whitespace(2, .vertical) }
let partsParser = Many { Part.parser } separator: { Whitespace(.vertical); Peek { Part.parser} }
let inputParser = Parse {
    workflowsParser
    partsParser
}

let (workflows, parts) = try inputParser.parse(String.input)
let workflowDictionary = Dictionary(uniqueKeysWithValues: workflows.map { ($0.name, $0) })
let initialWorkflow = workflowDictionary["in"]!


func outcome(for part: Part, in workflow: Workflow?) -> Bool {
    let initialOutcome = (workflow ?? initialWorkflow).outcome(for: part)
    
    switch initialOutcome {
    case .accepted: return true
    case .rejected: return false
    case .destination(let string): return outcome(for: part, in: workflowDictionary[string])
    }
}

measure(part: .one) { logger in
    let acceptedParts = parts.filter { outcome(for: $0, in: nil) }.map(\.ratingSum).reduce(0, +)
    return acceptedParts
    /* Part One */
}

measure(part: .two) { logger in
    /* Part Two */
}


