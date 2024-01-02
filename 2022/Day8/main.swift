//
//  main.swift
//  Day8
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation

extension Grid<Int> {

    var visibleTrees: Int { return allCoordinates.map { isTreeVisible(at: $0) }.filter { $0 }.count }
    var highestScenicScore: Int { return allCoordinates.map { scenicScore(at: $0) }.max() ?? 0 }

    func trees(_ direction: Coordinate.Direction, of point: Coordinate) -> any Collection<Int> {
        switch direction {
        case .east: return contents[point.y][(point.x + 1)...]
        case .west: return contents[point.y][..<point.x]
        case .north: return (0..<point.y).map { contents[$0][point.x] }
        case .south: return ((point.y + 1)..<contents.count).map { contents[$0][point.x] }
        default: return []
        }
    }

    func scenicScore(_ direction: Coordinate.Direction, of point: Coordinate) -> Int {
        let thisTree = contents[point.y][point.x]
        let treesInDirection = trees(direction, of: point)
        let fullyVisibleTrees = direction == .north || direction == .west ? treesInDirection.reversed().prefix { $0 < thisTree } : treesInDirection.prefix { $0 < thisTree }

        return fullyVisibleTrees.count == treesInDirection.count ? fullyVisibleTrees.count : fullyVisibleTrees.count + 1
    }

    func isTreeVisible(at point: Coordinate) -> Bool {
        if point.x == 0 || point.x == contents[0].count || point.y == 0 || point.y == contents.count {
            return true
        }

        let thisTree = contents[point.y][point.x]
        if trees(.north, of: point).allSatisfy({ $0 < thisTree }) {
            return true
        }

        if trees(.east, of: point).allSatisfy({ $0 < thisTree }) {
            return true
        }

        if trees(.south, of: point).allSatisfy({ $0 < thisTree }) {
            return true
        }

        if trees(.west, of: point).allSatisfy({ $0 < thisTree }) {
            return true
        }

        return false
    }

    func scenicScore(at point: Coordinate) -> Int {
        return [
            scenicScore(.north, of: point),
            scenicScore(.east, of: point),
            scenicScore(.south, of: point),
            scenicScore(.west, of: point)
        ].reduce(1, *)
    }

    func coordinateMap(for direction: Coordinate.Direction) -> [[Coordinate]] {
        switch direction {
        case .north, .west:
            return (0..<contents.count).map { row in
                return (0..<contents[0].count).map { column in
                    return .init(x: column, y: row)
                }
            }

        case .south:
            return (0..<contents.count).map { row in
                return (0..<contents[0].count).map { column in
                    return .init(x: column, y: contents.count - 1 - row)
                }
            }

        case .east:
            return (0..<contents.count).map { row in
                return (0..<contents[0].count).map { column in
                    return .init(x: contents[0].count - 1 - column, y: row)
                }
            }
        default: return []
        }
    }

    func visibleTreeMap(from direction: Coordinate.Direction) -> [[Bool]] {
        var highest = Array(repeating: 0, count: contents.count)
        let map = coordinateMap(for: direction).map { coordinateRow in
            return coordinateRow.map { coordinate in
                let value = contents[coordinate.y][coordinate.x]

                defer {
                    if value > highest[direction == .north || direction == .south ? coordinate.x : coordinate.y] {
                        highest[direction == .north || direction == .south ? coordinate.x : coordinate.y] = value
                    }
                }

                if direction == .north && coordinate.y == 0 {
                    return true
                } else if direction == .south && coordinate.y == contents.count - 1 {
                    return true
                } else if direction == .west && coordinate.x == 0 {
                    return true
                } else if direction == .east && coordinate.x == contents[0].count - 1 {
                    return true
                } else if value > highest[direction == .north || direction == .south ? coordinate.x : coordinate.y] {
                    return true
                }

                return false
            }
        }

        if direction == .north || direction == .west {
            return map
        } else if direction == .south {
            return map.reversed()
        } else {
            return map.map { $0.reversed() }
        }
    }

    var betterVisibleTreeCount: Int {
        var count = 0

        // If I pass in the previous map, does the short circuiting actually improve the speed?
        let northMap = visibleTreeMap(from: .north)
        let southMap = visibleTreeMap(from: .south)
        let eastMap = visibleTreeMap(from: .east)
        let westMap = visibleTreeMap(from: .west)

        for row in (0..<northMap.count) {
            for column in (0..<northMap[0].count) {
                if northMap[row][column] || southMap[row][column] || eastMap[row][column] || westMap[row][column] {
                    count += 1
                }
            }
        }

        return count
    }
}

let grid = Grid(input: .input, transform: { Int(String($0))! })

measure(part: .one) {
    return grid.visibleTrees
}

measure(part: .one) {
    // A more optimized version
    return grid.betterVisibleTreeCount
}

// MARK: - Part 2
measure(part: .two) {
    return grid.highestScenicScore
}
