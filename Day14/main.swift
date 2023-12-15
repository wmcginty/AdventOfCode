//
//  main.swift
//  Day14
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Content: String, CaseIterable, CustomStringConvertible {
    case roundRock = "O"
    case cubeRock = "#"
    case empty = "."
    
    var description: String {
        rawValue
    }
}

let lineParser = Many(1...) { Content.parser(of: Substring.self) } terminator: {
    OneOf {
        Whitespace(1, .vertical)
        End()
    }
}
let inputParser = Many { lineParser }.map(Grid.init)

// MARK: - Grid Convenience
extension Grid<Content> {
    
    func loadValue(at coordinate: Coordinate) -> Int {
        guard self[coordinate] == .roundRock else { return 0 }
        return rowCount - coordinate.y
    }
    
    var totalLoadOnNorthSupports: Int {
        return allCoordinates.map { loadValue(at: $0) }.reduce(0,+)
    }
    
    mutating func tilt(to direction: Coordinate.Direction) {
        for row in rows {
            let columns = columns(forRow: row)
            for col in columns {
                let coordinate = Coordinate(row: direction == .south ? rows.upperBound - 1 - row  : row,
                                            column: direction == .east ? columns.upperBound - 1 - col : col)
                guard self[coordinate] == .roundRock else { continue }
                 
                var nextCoordinate = coordinate.neighbor(in: direction)
                while rows.contains(nextCoordinate.row) && columns.contains(nextCoordinate.column) && self[nextCoordinate] == .empty {
                    nextCoordinate = nextCoordinate.neighbor(in: direction)
                }
                nextCoordinate = nextCoordinate.neighbor(in: direction.inverse)
                
                self[coordinate] = .empty
                self[nextCoordinate] = .roundRock
            }
        }
    }
    
    mutating func tiltCycles(ofCount count: Int) {
        let directions: [Coordinate.Direction] = [.north, .west, .south, .east]
        
        var cycle = 0
        var seen: [Self: Int] = [:]
        while cycle < count {
            if let previous = seen[self] {
                let difference = cycle - previous
                let remainingIterations = count  - cycle
                let jump = remainingIterations - (remainingIterations % difference)
                cycle += jump

                if jump > 0 {
                    continue
                }
            }
    
            seen[self] = cycle
            directions.forEach { tilt(to: $0) }
            cycle += 1
        }
    }
}

var partOne = try inputParser.parse(String.input)
var partTwo = partOne

measure(part: .one) { logger in
    /* Part One */
    partOne.tilt(to: .north)
    return partOne.totalLoadOnNorthSupports
}

measure(part: .two) { logger in
    /* Part Two */
    partTwo.tiltCycles(ofCount: 1_000_000_000)
    return partTwo.totalLoadOnNorthSupports
}
