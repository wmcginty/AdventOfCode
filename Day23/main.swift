//
//  main.swift
//  Day23
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Contents: String, CaseIterable, CustomStringConvertible {
    case path = "."
    case forest = "#"
    case slopeUp = "^"
    case slopeDown = "v"
    case slopeRight = ">"
    case slopeLeft = "<"

    var description: String { rawValue }
}

let lineParser = Many { Contents.parser(of: Substring.self) }
let inputParser = Many { lineParser } separator: { Whitespace(1, .vertical) }
let grid = try Grid<Contents>(contents: inputParser.parse(String.input))

struct DistanceToCoordinate: Hashable {
    let coordinate: Coordinate
    let distance: Int
}

extension Grid<Contents> {
    
    struct State: Hashable {
        let coordinate: Coordinate
        let stepCount: Int
        let visited: Set<Coordinate>
    }
    
    var start: Coordinate { allCoordinates.first(where: { grid.contents(at: $0) == .path })! }
    var end: Coordinate { allCoordinates.last(where: { grid.contents(at: $0) == .path })! }
    
    func isRespectingSlope(from coordinate: Coordinate, to: Coordinate) -> Bool {
        guard let contents = contents(at: coordinate) else { return false }
        
        if contents == .path {
            return true
        }
        
        switch coordinate.direction(to: to) {
        case .east: return contents == .slopeRight
        case .west: return contents == .slopeLeft
        case .south: return contents == .slopeDown
        default: return contents == .slopeUp
        }
    }
    
    func neighbors(of position: Coordinate, respectingSlopes: Bool) -> Set<Coordinate> {
        let neighbors = position.neighbors(in: .cardinal)
            .filter { contents(at: $0) != nil && contents(at: $0) != .forest }
            .filter { respectingSlopes ? isRespectingSlope(from: position, to: $0) : true }
        
        return neighbors
    }
    
    func navigationGraph(respectingSlopes: Bool = true) -> [Coordinate: [Coordinate: Int]] {
        var vertices: [Coordinate] = [start]
        var visited: Set<Coordinate> = []
        
        var graph: [Coordinate: [Coordinate: Int]] = [:]
        while let vertex = vertices.popLast() {
            if visited.contains(vertex) {
                continue
            }
     
            for nextStep in neighbors(of: vertex, respectingSlopes: respectingSlopes) {
                var length = 1
                var prev = vertex
                var position = nextStep
                var deadEnd = false

                while true {
                    let neighbors =  neighbors(of: position, respectingSlopes: respectingSlopes)
                    if neighbors == [prev] && "<>^v".contains(grid[position].rawValue) {
                        deadEnd = true
                        break
                    }
                    if neighbors.count != 2 {
                        break
                    }
                    for neighbor in neighbors {
                        if neighbor != prev {
                            length += 1
                            prev = position
                            position = neighbor
                            break
                        }
                    }
                }

                if deadEnd {
                    continue
                }

                graph[vertex, default: [:]][position] = length
                vertices.append(position)
            }

            visited.insert(vertex)
        }

        return graph
    }
        
    func longestHike(from start: Coordinate, to goal: Coordinate, respectingSlopes: Bool) -> Int? {
        let graph = navigationGraph(respectingSlopes: respectingSlopes)
    
        var stepCounts: [Int] = []
        var deque: Deque<State> = [.init(coordinate: start, stepCount: 0, visited: [start])]
        while let next = deque.popLast() {
            if next.coordinate == goal {
                stepCounts.append(next.stepCount)
                continue
            }
                       
            if let distancesToNextVertices = graph[next.coordinate] {
                for (coordinate, distance) in distancesToNextVertices {
                    if next.visited.contains(coordinate) {
                        continue
                    }
                    
                    deque.append(.init(coordinate: coordinate,
                                       stepCount: next.stepCount + distance,
                                       visited: next.visited.union([coordinate])))
                }
            }
        }
        
        return stepCounts.max()
    }
}

measure(part: .one) {
    return grid.longestHike(from: grid.start, to: grid.end, respectingSlopes: true) ?? -1
}

measure(part: .two) {
    return grid.longestHike(from: grid.start, to: grid.end, respectingSlopes: false) ?? -1
}

//var edges: [Coordinate: [(Coordinate, Int)]] = [:]
//    for coordinate in vertices {
//        var otherVertices = vertices
//        otherVertices.remove(coordinate)
//
//        var distances: [(Coordinate, Int)] = []
//        for vertex in otherVertices {
////            print("Shortest: \(coordinate) to \(vertex):")
//            if let shortest = grid.shortestPath(from: coordinate, to: vertex, respectingSlopes: true) {
////                print(grid.description { c, _ in
////                    return shortest.contains(c) ? "X" : nil
////                })
//
//
//                distances.append((vertex, shortest.count))
//            }
////            print()
//        }
////
//        edges[coordinate] = distances
//    }
        
//    func shortestPath(from coordinate: Coordinate, to: Coordinate, respectingSlopes: Bool) -> Set<Coordinate>? {
//        
//        let pathfinder = AStarPathfinder<Coordinate, Int> { currentState in
//            let neighbors = currentState.neighbors(in: .cardinal)
//                .filter { contents(at: $0) != nil && contents(at: $0) != .forest }
//                .filter { respectingSlopes ? isRespectingSlope(from: currentState, to: $0) : true }
//            
//            return neighbors.map { .init(state: $0, cost: 1) }
//        }
//        
//        return pathfinder.shortestPath(from: coordinate, toTargets: [to]) { state in
//            return state.manhattanDistance(to: to)
//        }.map { Set($0.states.dropFirst()) }
//    }
//}
//
