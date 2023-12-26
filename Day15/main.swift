//
//  main.swift
//  Day15
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

extension Character {
    
    func updateHash(current: inout Int) {
        current += Int(asciiValue!)
        current *= 17
        current %= 256
    }
}

struct InitializationSequence {
    
    // MARK: - InitializationSequence.Step
    struct Step: CustomStringConvertible {
        
        // MARK: - Step.Operation
        enum Operation: String, CaseIterable {
            case equals = "="
            case dash = "-"
        }
        
        // MARK: - Properties
        let label: String
        let operation: Operation
        let focalLength: Int?
        
        // MARK: - Interface
        var description: String { return label + operation.rawValue + (focalLength.map { "\($0)" } ?? "") }
        
        func HASH(for keyPath: KeyPath<Step, String>) -> Int {
            return self[keyPath: keyPath].reduce(into: 0) {
                if $1 != "\n" {
                    $1.updateHash(current: &$0)
                }
            }
        }
    }
    
    // MARK: - Properties
    let steps: [Step]
    
    // MARK: - Interface
    var HASH: Int { return steps.map { $0.HASH(for: \.description) }.reduce(0, +) }
    
    var sumOfFocusingPower: Int {
        let boxes: [Int: Box] = initializationSequence.steps.reduce(into: [:]) { boxes, step in
            let number = step.HASH(for: \.label)
            switch step.operation {
            case .dash:
                var matchingBox = boxes[number, default: .init(number: number, lenses: [])]
                if let matchIndex = matchingBox.lenses.firstIndex(where: { $0.label == step.label }) {
                    matchingBox.lenses.remove(at: matchIndex)
                    boxes[number] = matchingBox
                }
               
            case .equals:
                var matchingBox = boxes[number, default: .init(number: number, lenses: [])]
                if let matchIndex = matchingBox.lenses.firstIndex(where: { $0.label == step.label }) {
                    matchingBox.lenses[matchIndex] = step
                } else {
                    matchingBox.lenses.append(step)
                }
                
                boxes[number] = matchingBox
            }
        }
        
        return boxes.values.reduce(0) { $0 + $1.focusingPower }
    }
}

struct Box {
    
    // MARK: - Properties
    let number: Int
    var lenses: [InitializationSequence.Step]
    
    var focusingPower: Int {
        return lenses.enumerated().map {
            return (number + 1) * ($0.offset + 1) * $0.element.focalLength!
        }.reduce(0,+)
    }
}

let elementParse = Parse(input: Substring.self, InitializationSequence.Step.init) {
    Prefix(while: { $0 != "=" && $0 != "-" }).map(String.init)
    InitializationSequence.Step.Operation.parser(of: Substring.self)
    Optionally {
        Int.parser()
    }
}
let inputParse = Many { elementParse } separator: { "," }
let initializationSequence = InitializationSequence(steps: try inputParse.parse(String.input))

measure(part: .one) {
    /* Part One */
    return initializationSequence.HASH
}

measure(part: .two) {
    /* Part Two */
    return initializationSequence.sumOfFocusingPower
}

