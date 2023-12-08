//
//  main.swift
//  Day8
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Instructions {
    
    enum Step: String, CaseIterable {
        case left = "L"
        case right = "R"
    }
    
    // MARK: - Properties
    let steps: [Step]
    
    // MARK: - Interface
    func step(for index: Int) -> Step {
        return steps[index % steps.count]
    }
}

struct Node {
    
    // MARK: - Properties
    let id: String
    let left: String
    let right: String
    
    // MARK: - Interface
    func destination(for step: Instructions.Step) -> String {
        return step == .left ? left : right
    }
}

struct Map {
    
    // MARK: - Properties
    let instructions: Instructions
    let nodes: [Node]
    let dict: [String: Node]
    
    // MARK: - Initializer
    init(instructions: Instructions, nodes: [Node]) {
        self.instructions = instructions
        self.nodes = nodes
        self.dict = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
    }
    
    // MARK: - Interface
    func steps(from: String, endPredicate: (String) -> Bool) -> Int {
        var step = 0
        var currentLocation = from
        
        repeat {
            let instruction = instructions.step(for: step)
            let currentNode = dict[currentLocation]!
            let nextNode = currentNode.destination(for: instruction)
            
            currentLocation = nextNode
            step += 1
        } while endPredicate(currentLocation) == false
        
        return step
    }
}

let stepParser = Parse(input: Substring.self) { Instructions.Step.parser() }
let instructionsParser = Many { stepParser } terminator: {
    Peek {
        Whitespace()
    }
}

let nodeParser = Parse(input: Substring.self, Node.init) {
    Prefix(3).map(String.init)
    Whitespace()
    "="
    Whitespace()
    "("
    Prefix(3).map(String.init)
    ","
    Whitespace()
    Prefix(3).map(String.init)
    ")"
}

let mapParser = Parse(input: Substring.self, Map.init) {
    instructionsParser.map(Instructions.init)
    Whitespace(2, .vertical)
    Many { nodeParser } separator: { Whitespace(1, .vertical) }
}

let map = try mapParser.parse(String.input)

measure(part: .one) { logger in
    /* Part One */
    return map.steps(from: "AAA", endPredicate: { $0 == "ZZZ" })
}

measure(part: .two) { logger in
    /* Part Two */
    let startLocations: [String] = map.nodes.filter { $0.id.hasSuffix("A") }.map(\.id)
    let stepCounts = startLocations.map { map.steps(from: $0, endPredicate: { $0.hasSuffix("Z") }) }
    return stepCounts.reduce(stepCounts[0]) { $0.leastCommonMultiple(with: $1) }
}
