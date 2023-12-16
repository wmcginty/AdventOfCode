//
//  main.swift
//  Day16
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
    case leftMirror = "/"
    case rightMirror = "\\"
    case verticalSplitter = "|"
    case horizontalSplitter = "-"
    
    var description: String { rawValue }
}

let lineParser = Many(1...) { Content.parser(of: Substring.self) } terminator: {
    OneOf {
        Whitespace(1, .vertical)
        End()
    }
}
let inputParser = Many { lineParser }.map(Grid.init)

struct Beam: Hashable {
    let coordinate: Coordinate
    let direction: Coordinate.Direction
}

extension Grid<Content> {

    func beams(from beam: Beam) -> [Beam] {
        let coordinate = beam.coordinate
        let direction = beam.direction
        
        switch self[coordinate] {
        case .empty:
            return [.init(coordinate: coordinate.neighbor(in: direction), direction: direction)]
            
        case .leftMirror:
            switch direction {
            case .east: return [.init(coordinate: coordinate.neighbor(in: .north), direction: .north)]
            case .west: return [.init(coordinate: coordinate.neighbor(in: .south), direction: .south)]
            case .north: return [.init(coordinate: coordinate.neighbor(in: .east), direction: .east)]
            default: return [.init(coordinate: coordinate.neighbor(in: .west), direction: .west)]
            }
            
        case .rightMirror:
            switch direction {
            case .east: return [.init(coordinate: coordinate.neighbor(in: .south), direction: .south)]
            case .west: return [.init(coordinate: coordinate.neighbor(in: .north), direction: .north)]
            case .north: return [.init(coordinate: coordinate.neighbor(in: .west), direction: .west)]
            default: return [.init(coordinate: coordinate.neighbor(in: .east), direction: .east)]
            }
            
        case .horizontalSplitter:
            guard direction.isNorthOrSouth else { return [.init(coordinate: coordinate.neighbor(in: direction), direction: direction)] }
            return [
                .init(coordinate: coordinate.neighbor(in: .east), direction: .east),
                .init(coordinate: coordinate.neighbor(in: .west), direction: .west),
            ]
            
        case .verticalSplitter:
            guard direction.isEastOrWest else { return [.init(coordinate: coordinate.neighbor(in: direction), direction: direction)] }
            return [
                .init(coordinate: coordinate.neighbor(in: .north), direction: .north),
                .init(coordinate: coordinate.neighbor(in: .south), direction: .south),
            ]
        }
    }
    
    func energizedTiles(startingAt start: Coordinate, direction: Coordinate.Direction) -> Set<Coordinate> {
        var energized: Set<Coordinate> = []
        var seen: Set<Beam> = []
        
        var deque: Deque<Beam> = [.init(coordinate: start, direction: direction)]
        while let next = deque.popFirst() {
            if contents(at: next.coordinate) == nil {
                continue
            }
    
            energized.insert(next.coordinate)
            if seen.contains(next) {
                continue
            }
    
            seen.insert(next)
            deque.append(contentsOf: beams(from: next))
        }
        
        return energized
    }
    
    func mostEnergizedTiles(fromPossibleStarts starts: [Beam]) -> Int {
        return starts.map {
            return grid.energizedTiles(startingAt: $0.coordinate, direction: $0.direction)
        }.max(by: \.count)?.count ?? 0
    }
}

let grid = try inputParser.parse(String.input)

measure(part: .one) { logger in
    /* Part One */
    return grid.energizedTiles(startingAt: .init(x: 0, y: 0), direction: .east).count
}

measure(part: .two) { logger in
    /* Part Two */
    
    let starts: [Beam] = grid.coordinatesForRow(at: 0).map { Beam(coordinate: $0, direction: .south) }
    + grid.coordinatesForRow(at: grid.lastRowIndex).map { Beam(coordinate: $0, direction: .north) }
    + grid.coordinatesForColumn(at: 0).map { Beam(coordinate: $0, direction: .east) }
    + grid.coordinatesForColumn(at: grid.lastColumnIndex(forRow: 0)).map { Beam(coordinate: $0, direction: .west) }
        
    return grid.mostEnergizedTiles(fromPossibleStarts: starts)
}
