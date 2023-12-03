//
//  Model.swift
//  Day3Visualization
//
//  Created by Will McGinty on 12/3/23.
//

import AdventKit
import Foundation

struct EngineSchematic {
    
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
    
    let grid: Grid<Contents>
    let symbols: [Coordinate: Contents]
    
    init(contents: [[Contents]]) {
        let grid = Grid(contents: contents)
        let symbolsDict: [Coordinate: Contents] = Dictionary(uniqueKeysWithValues: grid.allCoordinates.compactMap {
            guard grid[$0].isSymbol else { return nil }
            return ($0, grid[$0])
        })
        
        self.grid = grid
        self.symbols = symbolsDict
    }
      
    func allCoordinates(forNumberString string: String, endingAtColumn column: Int, inRow row: Int) -> [Coordinate] {
        return (0..<string.count).map { Coordinate(row: row, column: column - $0) }
    }
}
