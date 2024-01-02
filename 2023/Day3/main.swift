//
//  main.swift
//  Day3
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Contents: CustomStringConvertible {
    case digit(String)
    case empty
    case symbol(String)
    
    // MARK: - Interface
    var isNumber: Bool {
        switch self {
        case .digit: return true
        default: return false
        }
    }

    var isSymbol: Bool {
        switch self {
        case .symbol: return true
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case .digit(let digit): return digit
        case .symbol(let symbol): return symbol
        case .empty: return "."
        }
    }
}

struct EngineSchematic {
    
    // MARK: - Properties
    let grid: Grid<Contents>
    let symbols: [Coordinate: Contents]
    
    // MARK: - Initializer
    init(contents: [[Contents]]) {
        let grid = Grid(contents: contents)
        let symbolsDict: [Coordinate: Contents] = Dictionary(uniqueKeysWithValues: grid.allCoordinates.compactMap {
            guard grid[$0].isSymbol else { return nil }
            return ($0, grid[$0])
        })
        
        self.grid = grid
        self.symbols = symbolsDict
    }
      
    // MARK: - Interface
    func allCoordinates(forNumberString string: String, endingAtColumn column: Int, inRow row: Int) -> [Coordinate] {
        return (0..<string.count).map { Coordinate(row: row, column: column - $0) }
    }
    
    // includes diagonals
    func isNumberStringSymbolAdjacent(_ string: String, endingAtColumn column: Int, inRow row: Int) -> Bool {
        let coordinates = allCoordinates(forNumberString: string, endingAtColumn: column, inRow: row)
        let neighbors = Set(coordinates.flatMap { $0.neighbors() }.filter { !coordinates.contains($0) })
        
        return neighbors.contains { symbols[$0] != nil }
    }
    
    func storeGearAdjaceNumberString(_ string: String, endingAtColumn column: Int, inRow row: Int, gears: inout [Coordinate: Set<Int>]) {
        let coordinates = allCoordinates(forNumberString: string, endingAtColumn: column, inRow: row)
        let neighbors = Set(coordinates.flatMap { $0.neighbors() }.filter { !coordinates.contains($0) })
        
        neighbors.forEach {
            if grid.dictionary[$0]?.description == "*" {
                let number = Int(string)!
                gears[$0, default: []].insert(number)
            }
        }
    }
    
    var sumOfPartNumbers: Int {
        var answer = 0
        for row in grid.rows {
            var numString = ""
            for column in grid.columns(forRow: row) {
                let coordinate = Coordinate(row: row, column: column)
                let content = grid[coordinate]
                
                if content.isNumber {
                    numString += content.description
                    
                    // this is the last column, handle now
                    if column == grid.lastColumnIndex(forRow: row) {
                        if isNumberStringSymbolAdjacent(numString, endingAtColumn: column, inRow: row) {
                            let number = Int(numString)!
                            answer += number
                        }
                        
                        numString = ""
                    }
                } else if !numString.isEmpty {
                    // a number has ended
                    let number = Int(numString)!
                    if isNumberStringSymbolAdjacent(numString, endingAtColumn: column - 1, inRow: row) {
                        answer += number
                    }
                    
                    numString = ""
                }
            }
        }
            
        return answer
    }
    
    var sumOfGearRatios: Int {
        var gears: [Coordinate: Set<Int>] = [:]
        
        for row in grid.rows {
            
            var numString = ""
            for column in grid.columns(forRow: row) {
                let coordinate = Coordinate(row: row, column: column)
                let content = grid[coordinate]
                
                if content.isNumber {
                    numString += content.description
                    
                    // this is the last column, handle now
                    if column == grid.lastColumnIndex(forRow: row) {
                        storeGearAdjaceNumberString(numString, endingAtColumn: column, inRow: row, gears: &gears)
                        numString = ""
                    }
                    
                    
                } else if !numString.isEmpty {
                    //a number has ended
                    storeGearAdjaceNumberString(numString, endingAtColumn: column - 1, inRow: row, gears: &gears)
                    numString = ""
                }
            }
        }
        
        return gears.filter { $0.value.count == 2}.reduce(0) { $0 + $1.value.reduce(1, *) }
    }
}

let content = Parse(input: Substring.self) {
    OneOf {
        Digits(1).map { Contents.digit(String($0)) }
        Parse { "." }.map { Contents.empty }
        Prefix(1, while: { $0 != "\n" }).map { Contents.symbol(String($0)) }
    }
}

let line = Parse(input: Substring.self) { Many { content } }
let lines = Parse { Many { line } separator: { "\n" } }
let schematic = EngineSchematic(contents: try lines.parse(String.input))

measure(part: .one) {
    /* Part One */
    
    return schematic.sumOfPartNumbers
}

measure(part: .two) {
    /* Part Two */
    
    return schematic.sumOfGearRatios
}
