//
//  Parse.swift
//  Day19
//
//  Created by Will McGinty on 12/19/23.
//

import AdventKit
import Parsing

// MARK: - Parsing
extension Part {
    static let parser = Parse(input: Substring.self, Part.init) {
        "{x="
        Int64.parser()
        ",m="
        Int64.parser()
        ",a="
        Int64.parser()
        ",s="
        Int64.parser()
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
                Int64.parser()
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
