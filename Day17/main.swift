//
//  main.swift
//  Day17
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct State: Hashable {
    
    enum Part {
        case one, two
    }

    let coordinate: Coordinate
    let direction: Coordinate.Direction?
    let consecutiveInDirection: Int
    
    func nextStates(in grid: Grid<Int>, for part: Part) -> [DijkstraPathfinder<State, Int>.StateCost] {
        func isValidState(for part: Part, previousConsecutiveStraight: Int, newConsecutiveStraight: Int, didChangeDirection: Bool) -> Bool {
            switch part {
            case .one: return newConsecutiveStraight <= 3
            case .two: return newConsecutiveStraight <= 10
                && (!didChangeDirection || previousConsecutiveStraight >= 4 || previousConsecutiveStraight == 0)
            }
        }
        
        let validDirections: [Coordinate.Direction] = .cardinal.filter { $0 != direction?.inverse }
        return validDirections.compactMap { newDirection in
            let nextCoordinate = coordinate.neighbor(in: newDirection)
            let newConsecutive = newDirection == direction ? consecutiveInDirection + 1 : 1
            let isValid = isValidState(for: part,
                                       previousConsecutiveStraight: consecutiveInDirection, newConsecutiveStraight: newConsecutive,
                                       didChangeDirection: direction != newDirection)

            guard let cost = grid.contents(at: nextCoordinate), isValid else { return nil }
            return .init(state: .init(coordinate: nextCoordinate, direction: newDirection, consecutiveInDirection: newConsecutive), cost: cost)
        }
    }
}

let lines = String.input.lines()
let contents = lines.map { $0.map( { Int(String($0))! }) }
let grid = Grid(contents: contents)

measure(part: .one) {
    /* Part One */
    let pathfinder = AStarPathfinder<State, Int>.distances { $0.nextStates(in: grid, for: .one) }
    
    let initialState = State(coordinate: .zero, direction: nil, consecutiveInDirection: 0)
    let target = grid.bottomRight
    return pathfinder.shortestCost(from: initialState, toTarget: { $0.coordinate == target },
                                   heuristic: { $0.coordinate.manhattanDistance(to: target) })
}

measure(part: .two) {
    /* Part Two */
    let pathfinder = AStarPathfinder<State, Int>.distances { $0.nextStates(in: grid, for: .two) }
    
    let initialState = State(coordinate: .zero, direction: nil, consecutiveInDirection: 0)
    let target = grid.bottomRight
    return pathfinder.shortestCost(from: initialState, toTarget: { $0.coordinate == target },
                                   heuristic: { $0.coordinate.manhattanDistance(to: target) })
}
