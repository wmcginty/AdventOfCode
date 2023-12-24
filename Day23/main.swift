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

extension Grid<Contents> {
    
    struct State: Hashable {
        let coordinate: Coordinate
        let stepCount: Int
        let visited: [Coordinate]
    }
    
    struct EdgeState: Hashable {
        let coordinate: Coordinate
        let distance: Int
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
        
    func vertices(connectedTo coordinate: Coordinate, respectingSlopes: Bool, movingToward end: Coordinate) -> [Coordinate: Int] {
        var destinations: [Coordinate: Int] = [:]
        
        var deque: Deque<EdgeState> = [.init(coordinate: coordinate, distance: 0)]
        var seen: Set<Coordinate> = []
        while let next = deque.popFirst() {
            if seen.contains(next.coordinate) {
                continue
            }
            seen.insert(next.coordinate)
            
            if next.coordinate == end {
                destinations[next.coordinate] = next.distance
                continue
            }
            
            let neighbors = neighbors(of: next.coordinate, respectingSlopes: respectingSlopes)
            if neighbors.count > 2 && next.coordinate != coordinate {
                destinations[next.coordinate] = next.distance
                continue
            }
            
            deque.append(contentsOf: neighbors.map { .init(coordinate: $0, distance: next.distance + 1) })
        }
        
        return destinations
    }
    
    func navigationGraph(respectingSlopes: Bool = true, movingToward end: Coordinate) -> [Coordinate: [Coordinate: Int]] {
        var graph: [Coordinate: [Coordinate: Int]] = [:]
        var vertices: Deque<Coordinate> = [start]
        var visited: Set<Coordinate> = []
        while let vertex = vertices.popFirst() {
            if visited.contains(vertex) {
                continue
            }
            
            let destinations = self.vertices(connectedTo: vertex, respectingSlopes: respectingSlopes, movingToward: end)
            graph[vertex] = destinations
            
            vertices.append(contentsOf: destinations.keys)
            visited.insert(vertex)
        }

        return graph
    }
        
    func longestHike(from start: Coordinate, to end: Coordinate, respectingSlopes: Bool) -> Int? {
        let graph = navigationGraph(respectingSlopes: respectingSlopes, movingToward: end)
    
        var stepCounts: [Int] = []
        var deque: Deque<State> = [.init(coordinate: start, stepCount: 0, visited: [start])]
        while let next = deque.popLast() {
            if next.coordinate == end {
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
                                       visited: next.visited + [coordinate]))
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
