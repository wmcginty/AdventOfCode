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
let gridParser = Many { lineParser } separator: { Whitespace(1, .vertical) }

var contents = try gridParser.parse(String.testInput)
var copy = contents

var cOffset = 0
for col in 0..<contents[0].count {
    let rows = contents.count
    let colEls = (0..<rows).map { contents[$0][col] }
    if colEls.allSatisfy({ $0 == .empty }) {
        cOffset += 1
        
        (0..<rows).forEach {
            copy[$0].insert(.empty, at: col + cOffset)
        }
    }
}

var copy2 = copy

var rOffset = 0
for row in 0..<copy.count {
    if copy[row].allSatisfy({ $0 == .empty }) {
        rOffset += 1
        copy2.insert(copy[row], at: row + rOffset)
    }
}

let grid = Grid(contents: copy2)
//print(grid.description)

extension Grid<Content> {
    
    var distancesBetweenAllPairsOfGalaxies: Int {
        return Set(dictionary.filter { $0.value == .galaxy }.map(\.key))
            .combinations(ofCount: 2)
            .map { $0[0].manhattanDistance(to: $0[1]) }
            .reduce(0, +)
    }
}

extension Grid {
    
    func adjustedCoordinate(for originalCoordinate: Coordinate, emptyRows: [Int], emptyColumns: [Int], by factor: Int) -> Coordinate {
        let addedRows = emptyRows.filter { $0 < originalCoordinate.row }.count * (factor - 1)
        let addedCols = emptyColumns.filter { $0 < originalCoordinate.column }.count * (factor - 1)
        return Coordinate(row: originalCoordinate.row + addedRows,
                          column: originalCoordinate.column + addedCols)
    }
}

measure(part: .one) { logger in
    /* Part One */
    return grid.distancesBetweenAllPairsOfGalaxies
}



measure(part: .two) { logger in
    /* Part Two */
    
    let originalGrid = Grid(contents: contents)
//    print(originalGrid.description)
//    print()
//    print(grid.description)
    
//    print()
    let emptyRows = originalGrid.rows.filter { originalGrid.contentsOfRow(at: $0).allSatisfy { $0 == .empty } }
    let emptyCols = originalGrid.columns(for: 0).filter { originalGrid.contentsOfColumn(at: $0).allSatisfy { $0 == .empty } }
//    
//    print(originalGrid.adjustedCoordinate(for: .init(row: 8, column: 7), emptyRows: emptyRows, emptyColumns: emptyCols, by: 2))
//    return 0
    
    return Set(originalGrid.dictionary.filter { $0.value == .galaxy }
        .map { originalGrid.adjustedCoordinate(for: $0.key, emptyRows: emptyRows, emptyColumns: emptyCols, by: 1_000_000) }
    )
    .combinations(ofCount: 2)
    .map { $0[0].manhattanDistance(to: $0[1]) }
    .reduce(0, +)
}
