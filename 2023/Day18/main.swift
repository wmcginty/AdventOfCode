//
//  main.swift
//  Day18
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Instruction {

    enum Direction: String, CaseIterable {
        case up = "U"
        case left = "L"
        case right = "R"
        case down = "D"
        
        // MARK: - Initializer
        init(_ int: Int) {
            switch int {
            case 0: self = .right
            case 1: self = .down
            case 2: self = .left
            default: self = .up
            }
        }
    }
    
    // MARK: - Properties
    let direction: Direction
    let count: Int
    let colorString: String
    
    // MARK: - Interface
    var extractingHexInstructions: Self? {
        guard let direction: Direction = colorString.last.flatMap({ Int(String($0)) }).map(Direction.init),
              let decimalCount = Int(String(colorString.dropLast()), radix: 16) else { return nil }

        return Self(direction: direction, count: decimalCount, colorString: colorString)
    }

    func coordinate(startingFrom coordinate: Coordinate) -> Coordinate {
        switch direction {
        case .up: return .init(x: coordinate.x, y: coordinate.y - count)
        case .left: return .init(x: coordinate.x - count, y: coordinate.y)
        case .right: return .init(x: coordinate.x + count, y: coordinate.y)
        case .down: return .init(x: coordinate.x, y: coordinate.y + count)
        }
    }
}

let lineParser = Parse(input: Substring.self, Instruction.init) {
    Instruction.Direction.parser()
    Whitespace()
    Int.parser()
    Whitespace()
    "(#"
    Prefix(while: { $0 != ")" }).map(String.init)
    ")"
}

let inputParser = Many { lineParser } separator: { "\n" }
let instructions = try inputParser.parse(String.input)
let instructions2 = instructions.compactMap { $0.extractingHexInstructions }

measure(part: .one) {
    /* Part One */
    var current = Coordinate.zero
    var coordinates: [Coordinate] = [.zero]

    for instruction in instructions {
        let new = instruction.coordinate(startingFrom: current)

        current = new
        coordinates.append(new)
    }
    
    let polygon = Polygon(vertices: coordinates)
    return polygon.interiorLatticePoints()
}

measure(part: .two) {
    /* Part Two */
    var current = Coordinate.zero
    var coordinates: [Coordinate] = [.zero]

    for instruction in instructions2 {
        let new = instruction.coordinate(startingFrom: current)

        current = new
        coordinates.append(new)
    }

    let polygon = Polygon(vertices: coordinates)
    return polygon.interiorLatticePoints()
}
