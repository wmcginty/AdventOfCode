//
//  main.swift
//  Day13
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Content: String, CaseIterable, CustomStringConvertible, Equatable {
    case ash = "."
    case rock = "#"
    
    var description: String { return rawValue }
}

let contentParser = Parse(input: Substring.self) { Content.parser() }
let lineParser = Many { contentParser } terminator: { Peek { Whitespace(.vertical) } }
let sectionParser = Many(1...) { lineParser } separator: { Whitespace(1, .vertical); Peek { Content.parser() } }.map(Grid.init)
let inputParser = Many { sectionParser } separator: { Whitespace(2, .vertical) } terminator: { End() }

let grids = try inputParser.parse(String.input)

// MARK: - Grid Symmetry
extension Grid<Content> {
    
    func verticalSymmetryLineIndices(withErrorAllowance error: Int) -> [Int] {
        func isVerticallySymmetrical(across index: Int, withOffset offset: Int, errorAllowance: Int) -> Bool {
            let columnCount = columnCount(for: 0)
            let indexLeft = index - offset
            let indexRight = index + 1 + offset
            
            if index < 0 || index >= columnCount - 1 || errorAllowance < 0 {
                return false
            }
            
            if offset > 0 && (indexLeft < 0 || indexRight >= columnCount) {
                return errorAllowance == 0
            }
            
            let columnLeft = contentsOfColumn(at: indexLeft)
            let columnRight = contentsOfColumn(at: indexRight)
            let diffCount = zip(columnLeft, columnRight).map { $0 != $1 ? 1 : 0 }.reduce(0, +)
            
            guard diffCount >= 0 else { return false }
            return isVerticallySymmetrical(across: index, withOffset: offset + 1, errorAllowance: errorAllowance - diffCount)
        }
        
        return columns(for: 0).filter { isVerticallySymmetrical(across: $0, withOffset: 0, errorAllowance: error) }
    }
    
    func horizontalSymmetryLineIndices(withErrorAllowance error: Int) -> [Int] {
        func isHorizontallySymmetrical(across index: Int, withOffset offset: Int, errorAllowance: Int) -> Bool {
            let indexAbove = index - offset
            let indexBelow = index + 1 + offset
            
            if index < 0 || index >= rowCount - 1 || errorAllowance < 0 {
                return false
            }
            
            if offset > 0 && (indexAbove < 0 || indexBelow >= rowCount) {
                return errorAllowance == 0
            }
            
            let rowAbove = contentsOfRow(at: indexAbove)
            let rowBelow = contentsOfRow(at: indexBelow)
            let diffCount = zip(rowAbove, rowBelow).map { $0 != $1 ? 1 : 0 }.reduce(0, +)
            
            guard diffCount >= 0 else { return false }
            return isHorizontallySymmetrical(across: index, withOffset: offset + 1, errorAllowance: errorAllowance - diffCount)
        }
        
        return rows.filter { isHorizontallySymmetrical(across: $0, withOffset: 0, errorAllowance: error) }
    }
}

measure(part: .one) { logger in
    /* Part One */
    return grids.reduce(0) { partialResult, grid in
        let vertical = grid.verticalSymmetryLineIndices(withErrorAllowance: 0).map { $0 + 1 }.reduce(0, +)
        let horizontal = grid.horizontalSymmetryLineIndices(withErrorAllowance: 0).map { ($0 + 1) * 100 }.reduce(0, +)
        
        return vertical + horizontal + partialResult
    }
}

measure(part: .two) { logger in
    /* Part Two */
    return grids.reduce(0) { partialResult, grid in
        let vertical = grid.verticalSymmetryLineIndices(withErrorAllowance: 1).map { $0 + 1 }.reduce(0, +)
        let horizontal = grid.horizontalSymmetryLineIndices(withErrorAllowance: 1).map { ($0 + 1) * 100 }.reduce(0, +)
        
        return vertical + horizontal + partialResult
    }
}


