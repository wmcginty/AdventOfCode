//
//  main.swift
//  Day18
//
//  Created by Will McGinty on 12/20/22.
//

import AdventKit
import Foundation
import Parsing

class ObsidianChunk {

    struct Coordinate: Hashable {
        let x, y, z: Int

        func neighbors() -> [Coordinate] {
            return [.init(x: x - 1, y: y, z: z),
                    .init(x: x + 1, y: y, z: z),
                    .init(x: x, y: y - 1, z: z),
                    .init(x: x, y: y + 1, z: z),
                    .init(x: x, y: y, z: z - 1),
                    .init(x: x, y: y, z: z + 1)]
        }
    }

    enum Contents {
        case water, lava
    }

    let minX, maxX, minY, maxY, minZ, maxZ: Int
    var coordinates: [Coordinate: Contents]

    init(points: [Coordinate]) {
        minX = points.map(\.x).min()! - 1
        maxX = points.map(\.x).max()! + 1
        minY = points.map(\.y).min()! - 1
        maxY = points.map(\.y).max()! + 1
        minZ = points.map(\.z).min()! - 1
        maxZ = points.map(\.z).max()! + 1

        let lava = [Contents](repeating: .lava, count: points.count)
        self.coordinates = Dictionary(uniqueKeysWithValues: zip(points, lava))
    }

    func contains(_ coord: Coordinate) -> Bool {
        coord.x >= minX && coord.x <= maxX &&
        coord.y >= minY && coord.y <= maxY &&
        coord.z >= minZ && coord.z <= maxZ
    }

    func floodFill(with contents: Contents, from start: ObsidianChunk.Coordinate) {
        coordinates[start] = contents

        let neighbors = start.neighbors()
            .filter { contains($0) && coordinates[$0] == nil }

        for n in neighbors {
            floodFill(with: contents, from: n)
        }
    }
}

let coordinateParser = Parse(input: Substring.self) {
    Int.parser()
    ","
    Int.parser()
    ","
    Int.parser()
}.map(ObsidianChunk.Coordinate.init)


func part1(from input: String) throws -> Int {
    let coordinates = try Many { coordinateParser } separator: { "\n" }.parse(input)
    return coordinates.flatMap { $0.neighbors() }
        .filter { !coordinates.contains($0) }
        .count
}

func part2(from input: String) throws -> Int {
    let coordinates = try Many { coordinateParser } separator: { "\n" }.parse(input)
    let chunk = ObsidianChunk(points: coordinates)

    chunk.floodFill(with: .water, from: .init(x: chunk.maxX,
                                              y: chunk.maxY,
                                              z: chunk.maxY))

    return chunk.coordinates
        .filter { $0.value == .water }.map(\.key)
        .reduce(0) { partialResult, coordinate in
            return partialResult + coordinate.neighbors().filter { chunk.coordinates[$0] == .lava }.count
    }
}

try measure(part: .one) {
    try part1(from: .input)
}

try measure(part: .one) {
    try part2(from: .input)
}
