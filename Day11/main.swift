//
//  main.swift
//  Day11
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Content: String, CaseIterable, CustomStringConvertible {
    case empty = "."
    case galaxy = "#"

    var description: String { return rawValue }
}

let contentParser = Parse(input: Substring.self) { Content.parser() }
let lineParser = Many { contentParser } terminator: { Peek { Whitespace() } }
let gridParser = Many { lineParser } separator: { Whitespace(1, .vertical) }.map(Grid.init)

extension Grid {
    
    func adjustedCoordinate(for originalCoordinate: Coordinate, emptyRows: [Int], emptyColumns: [Int], by factor: Int) -> Coordinate {
        let addedRows = emptyRows.filter { $0 < originalCoordinate.row }.count * (factor - 1)
        let addedCols = emptyColumns.filter { $0 < originalCoordinate.column }.count * (factor - 1)
        
        return Coordinate(row: originalCoordinate.row + addedRows, column: originalCoordinate.column + addedCols)
    }
}

extension Grid<Content> {
    
    func distancesBetweenAllPairsOfGalaxies(withEmptyRows: [Int], emptyColumns: [Int], expansionFactor: Int) -> Int {
        return Set(dictionary.filter { $0.value == .galaxy }
            .map { adjustedCoordinate(for: $0.key, emptyRows: emptyRows, emptyColumns: emptyCols, by: expansionFactor) }
        )
        .combinations(ofCount: 2)
        .map { $0[0].manhattanDistance(to: $0[1]) }
        .reduce(0, +)
    }
}

let grid = try gridParser.parse(String.input)
let emptyRows = grid.rows.filter { grid.contentsOfRow(at: $0).allSatisfy { $0 == .empty } }
let emptyCols = grid.columns(for: 0).filter { grid.contentsOfColumn(at: $0).allSatisfy { $0 == .empty } }

measure(part: .one) { logger in
    /* Part One */
    return grid.distancesBetweenAllPairsOfGalaxies(withEmptyRows: emptyRows, emptyColumns: emptyCols, expansionFactor: 2)
}

measure(part: .two) { logger in
    /* Part Two */
    return grid.distancesBetweenAllPairsOfGalaxies(withEmptyRows: emptyRows, emptyColumns: emptyCols, expansionFactor: 1_000_000)
}
