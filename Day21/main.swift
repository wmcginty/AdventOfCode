//
//  main.swift
//  Day21
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Content: String, CaseIterable, CustomStringConvertible {
    case start = "S"
    case garden = "."
    case rock = "#"
    
    var description: String { rawValue }
}

let lines = String.input.lines()
let contents = lines.map { $0.map { Content(rawValue: String($0))! } }
let grid = Grid(contents: contents)

// MARK: - Grid + Convenience
extension Grid<Content> {
    
    struct State: Hashable {
        let stepsTaken: Int
        let coordinate: Coordinate
        let mapCoordinate: Coordinate
    }

    var start: Coordinate { return allCoordinates.first { self[$0] == .start }! }
    
    func reachableGardensFromCenter(inSteps steps: Int) -> Int {
        let gWidth = columnCount(forRow: 0)
        let gHeight = rowCount
        let totalSteps = steps
        
        var answer = 0
        var seen: Set<State> = []
        var deque = Deque<State>([.init(stepsTaken: 0, coordinate: start, mapCoordinate: .zero)])
        while let next = deque.popFirst() {
            if seen.contains(next) {
                continue
            }
            seen.insert(next)
            
            if next.stepsTaken == totalSteps {
                answer += 1
                continue
            }
            
            let neighbors = next.coordinate.neighbors(in: .cardinal)
            for neighbor in neighbors {
                var mapCoordinate = next.mapCoordinate
                var mappedNeighbor = neighbor
                
                if neighbor.x < 0 {
                    mappedNeighbor.x += gWidth
                    mapCoordinate.x -= 1
                    
                } else if neighbor.x >= gWidth {
                    mappedNeighbor.x -= gWidth
                    mapCoordinate.x += 1
                }
                
                if neighbor.y < 0 {
                    mappedNeighbor.y += gHeight
                    mapCoordinate.y -= 1
                    
                } else if neighbor.y >= gHeight {
                    mappedNeighbor.y -= gHeight
                    mapCoordinate.y += 1
                }
                
                if let contents = contents(at: mappedNeighbor), contents != .rock {
                    deque.append(.init(stepsTaken: next.stepsTaken + 1, coordinate: mappedNeighbor, mapCoordinate: mapCoordinate))
                }
            }
        }
        
        return answer
    }
}

measure(part: .one) { logger in
    /* Part One */
    return grid.reachableGardensFromCenter(inSteps: 64)
}

measure(part: .two) { logger -> Int in
    let goalSteps: Int = 26501365
    let gWidth = grid.columnCount(forRow: 0)
    
    // n = width of grid, x = number of steps, f(x) = number of gardens reachable after x steps.
    let xs = (0..<3).map { (gWidth / 2) + $0 * gWidth } //n/2, 3n/2, 5n/2
    let ys = xs.map { grid.reachableGardensFromCenter(inSteps: $0) } //f(n/2), f(3n/2), f(5n/2)
    return Quadratic.interpolatedValue(givenF0: ys[0], f1: ys[1], f2: ys[2], x: goalSteps / gWidth)
}
