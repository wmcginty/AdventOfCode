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
    func quadraticSolve(for zero: Int, one: Int, two: Int, x: Int) -> Int {
        let a0 = zero
        let a1 = one
        let a2 = two
        
        let b0 = a0
        let b1 = a1 - a0
        let b2 = a2 - a1
        
        return b0 + b1 * x + (x * (x - 1) / 2) * (b2 - b1)
    }
    
    let goalSteps: Int = 26501365
    let gWidth = grid.columnCount(forRow: 0)
    
    // x = width of input grid, f(x) = number of gardens reachable after x steps.
    let xs = (0..<3).map { 65 + $0 * gWidth }
    let ys = xs.map { grid.reachableGardensFromCenter(inSteps: $0) }
    
    // use the quadratic equation
    return quadraticSolve(for: ys[0], one: ys[1], two: ys[2], x: goalSteps / gWidth)
}


