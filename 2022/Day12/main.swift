//
//  main.swift
//  Day12
//
//  Created by Will McGinty on 12/19/22.
//

import Foundation
import AdventKit

struct Map {

    // MARK: - Properties
    let map: [Coordinate: UInt8]
    let start: Coordinate
    let end: Coordinate
    let reversed: Bool

    // MARK: - Initializers
    init(map: [Coordinate: UInt8], start: Coordinate, end: Coordinate, reversed: Bool) {
        self.map = map
        self.start = start
        self.end = end
        self.reversed = reversed
    }

    init(input: String, reversed: Bool = false) {
        var start = Coordinate(x: 0, y: 0)
        var end = Coordinate(x: 0, y: 0)
        var map = [Coordinate: UInt8]()

        for (y, line) in input.lines().enumerated() {
            for (x, character) in line.enumerated() {
                var copy = character
                let coordinate = Coordinate(x: x, y: y)

                if copy == "S" {
                    start = coordinate
                    copy = "a"
                } else if copy == "E" {
                    end = coordinate
                    copy = "z"
                }

                map[coordinate] = reversed ? ((122 - copy.asciiValue!) + 97) : copy.asciiValue!
            }
        }

        self.init(map: map, start: start, end: end, reversed: reversed)
    }

    // MARK: - Interface
    func reachableNeighbors(from coordinate: Coordinate) -> [Coordinate] {
        guard let currentHeight = map[coordinate] else { return [] }
        return coordinate.neighbors(in: .cardinal).filter { map[$0].map { $0 <= currentHeight + 1 } ?? false }
    }

    var lowestElevation: UInt8 {
        let min = map.map(\.value).min()!
        return reversed ? ((122 - min) + 97) : min
    }
}

// MARK: - Part 1
measure(part: .one) {
    let heightMap = Map(input: .input)
    let pathfinder = AStarPathfinder<Coordinate, Int> {
        return heightMap.reachableNeighbors(from: $0).map { .init(state: $0, cost: 1) }
    }

    return pathfinder.shortestManhattanCost(from: heightMap.start, toPossibleTargets: [heightMap.end])
}

measure(part: .two) {
    let heightMap = Map(input: .input, reversed: true)
    let pathfinder = DijkstraPathfinder<Coordinate, Int> {
        return heightMap.reachableNeighbors(from: $0).map { .init(state: $0, cost: 1) }
    }

    return pathfinder.shortestCost(from: heightMap.end) { possibleTarget in
        return heightMap.map[possibleTarget] == heightMap.lowestElevation
    }
}
