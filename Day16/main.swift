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
let grid = try inputParser.parse(String.input)

struct BeamMovement: Hashable {
    let coordinate: Coordinate
    let direction: Coordinate.Direction
}

extension Grid<Content> {

    struct State: Hashable {
        let previousMovements: Set<BeamMovement>
        let currentMovement: BeamMovement
        let visitedCoordinates: Set<Coordinate>
        
        init(previousMovements: Set<BeamMovement>, currentMovement: BeamMovement) {
            self.previousMovements = previousMovements
            self.currentMovement = currentMovement
            self.visitedCoordinates = Set(previousMovements.map(\.coordinate))
        }
    }
    
    func beamPath(startingAt starts: Set<BeamMovement>) -> Set<BeamMovement> {
        var seen: Set<BeamMovement> = []
        var deque = Deque<State>()
        
        for start in starts {
            let movement = BeamMovement(coordinate: start.coordinate, direction: start.direction)
            deque.append(.init(previousMovements: [movement], currentMovement: movement))
        }
    
        while let next = deque.popFirst() {
            if seen.contains(next.currentMovement) {
                continue
            }
            
            seen.insert(next.currentMovement)
            let beamOutputs = beamOutput(afterEntering: next.currentMovement.coordinate, moving: next.currentMovement.direction)
            for output in beamOutputs {
                if self.contents(at: output.coordinate) != nil {
                    deque.append(.init(previousMovements: next.previousMovements.union([next.currentMovement]),
                                       currentMovement: output))
                }
            }
        }
        
        return seen
    }
    
    func bestBeamPath(startingAt starts: [BeamMovement]) -> Int {
        var max = 0
        for start in starts {
            let path = beamPath(startingAt: [start])
            let coordCount = Set(path.map(\.coordinate)).count
            if coordCount > max {
                print("found \(coordCount)")
                max = coordCount
            }
        }
        
        return max
    }
    
    func beamOutput(afterEntering coordinate: Coordinate, moving direction: Coordinate.Direction) -> Set<BeamMovement> {
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
}

measure(part: .one) { logger in
    /* Part One */
    let energizedTiles = Set(grid.beamPath(startingAt: [.init(coordinate: .init(x: 0, y: 0), direction: .east)]))
    let count = Set(energizedTiles.map(\.coordinate)).count
    return count
}

measure(part: .two) { logger in
    /* Part Two */
    let starts: [BeamMovement] = grid.columns(forRow: 0).map { .init(coordinate: .init(row: 0, column: $0), direction: .south) }
    + grid.columns(forRow: grid.lastRowIndex).map { .init(coordinate: .init(row: grid.lastRowIndex, column: $0), direction: .north) }
    + grid.rows.map { .init(coordinate: .init(row: $0, column: 0), direction: .east) }
    + grid.rows.map { .init(coordinate: .init(row: $0, column: grid.lastColumnIndex(forRow: 0)), direction: .west) }
    
    return grid.bestBeamPath(startingAt: starts)
}
