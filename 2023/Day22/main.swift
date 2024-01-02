//
//  main.swift
//  Day22
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Coordinate3D: Hashable, CustomStringConvertible {
    
    // MARK: - Properties
    var x, y, z: Int
    
    // MARK: - Interface
    var horizontalCoordinate: Coordinate { .init(x: x, y: y) }
    var fallenDown: Coordinate3D { return .init(x: x, y: y, z: z - 1) }
    
    // MARK: - CustomStringConvertible
    var description: String {
        return "(\(x), \(y), \(z))"
    }
}

struct BrickDescription {
    
    // MARK: - Properties
    let start: Coordinate3D
    let end: Coordinate3D
    
    // MARK: - Interface
    var xRange: ClosedRange<Int> { return min(start.x, end.x)...max(start.x, end.x) }
    var yRange: ClosedRange<Int> { return min(start.y, end.y)...max(start.y, end.y) }
    var zRange: ClosedRange<Int> { return min(start.z, end.z)...max(start.z, end.z) }
    
    var allCoordinates: [Coordinate3D] {
        var filledCubes: [Coordinate3D] = []
        for x in xRange {
            for y in yRange {
                for z in zRange {
                    filledCubes.append(.init(x: x, y: y, z: z))
                }
            }
        }
        
        return filledCubes
    }
}

struct Brick: Hashable, CustomStringConvertible {
    
    // MARK: - Properties
    let id: UUID
    let name: String
    var coordinates: [Coordinate3D]
    
    /// The list of bricks this brick is supporting.
    private(set) var supportedBricks: Set<UUID> = []
    
    /// The list of bricks that are supporting this brick.
    private(set) var supportingBricks: Set<UUID> = []
    
    static let names = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static var nameIndex: String.Index = names.startIndex
    
    // MARK: - Initializers
    init(id: UUID, name: String, coordinates: [Coordinate3D]) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
    }
    
    init(brickDescription: BrickDescription) {
        self.id = UUID()
        self.name = String(Self.names[Self.nameIndex])
        Self.nameIndex = Self.nameIndex == Self.names.index(before: Self.names.endIndex) ? Self.names.startIndex : Self.names.index(after: Self.nameIndex)
        self.coordinates = brickDescription.allCoordinates
    }
    
    // MARK: - Interface
    var xRange: ClosedRange<Int> { return coordinates.map(\.x).min()! ... coordinates.map(\.x).max()! }
    var yRange: ClosedRange<Int> { return coordinates.map(\.y).min()! ... coordinates.map(\.y).max()! }
    var zRange: ClosedRange<Int> { return coordinates.map(\.z).min()! ... coordinates.map(\.z).max()! }
    var baseCoordinates: [Coordinate3D] { return coordinates.filter { $0.z == zRange.lowerBound } }
    
    mutating func move(downToZ: Int) {
        let difference = zRange.lowerBound - downToZ
        coordinates = coordinates.map { .init(x: $0.x, y: $0.y, z: $0.z - difference) }
    }
        
    mutating func recordSupported(by brick: Brick) {
        supportingBricks.insert(brick.id)
    }
    
    mutating func recordSupporting(brick: Brick) {
        supportedBricks.insert(brick.id)
    }
        
    // MARK: - CustomStringConvertible
    var description: String {
        return coordinates.map(\.description).formatted()
    }
}

struct BrickStack {
    
    // MARK: - Properties
    let bricks: [Brick]
    let dictionary: [UUID: Brick]
    
    // MARK: - Initializer
    init(brickSnapshot: [Brick]) {
        var sortedBricks = brickSnapshot
        sortedBricks.sort(by: \.zRange.lowerBound)
        
        var lowestAvailableZ: [Coordinate: Int] = [:]
        var finalBricks: [Brick] = []
        for brick in sortedBricks {
            
            var movedBrick = brick
            var highestOfLowestAvailableZCoordinates = 1
            
            // Identify the 'lowestAvailableZ' for each vertical column and move the brick down as low as it can go
            for baseCoordinate in brick.baseCoordinates.map(\.horizontalCoordinate) {
                
                let lowestAvailableInXYColumn = lowestAvailableZ[baseCoordinate, default: 1]
                if lowestAvailableInXYColumn > highestOfLowestAvailableZCoordinates {
                    highestOfLowestAvailableZCoordinates = lowestAvailableInXYColumn
                }
            }
            movedBrick.move(downToZ: highestOfLowestAvailableZCoordinates)
            
            /* Now that the brick has moved to it's final destination - update the available `lowestAvailableZ` space,
            and set up the "supported by / is supporting" relationships between fallen bricks. */
            for baseCoordinate in movedBrick.baseCoordinates {
                
                // Update the 'lowestAvailableZ' record
                let xyCoordinate = Coordinate(x: baseCoordinate.x, y: baseCoordinate.y)
                lowestAvailableZ[xyCoordinate] = baseCoordinate.z + movedBrick.zRange.count
                
                // Find all the bricks that are below our base
                let belowBaseCoordinate = baseCoordinate.fallenDown
                if let matchIndex = finalBricks.firstIndex(where: { $0.coordinates.contains(belowBaseCoordinate) }) {
                    movedBrick.recordSupported(by: finalBricks[matchIndex])
                    finalBricks[matchIndex].recordSupporting(brick: movedBrick)
                }
            }
            
            finalBricks.append(movedBrick)
        }
        
        self.bricks = finalBricks
        self.dictionary = Dictionary(uniqueKeysWithValues: finalBricks.map { ($0.id, $0) })
    }
    
    // MARK: - Interface
    var countOfDisintegratableBricks: Int {
        return bricks.reduce(0) { partialResult, brick in
            let supported = bricks.filter { $0.supportingBricks.contains(brick.id) }
            return supported.allSatisfy { $0.supportingBricks.count > 1 } ? partialResult + 1 : partialResult
        }
    }
    
    func countOfBricksToFallAfterDisintegration(of originalBrick: Brick, withAlreadyFallingBricks: Set<UUID> = []) -> Int {
        var ans = 0
        var fallingBricks: Set<UUID> = [originalBrick.id]
        for brick in bricks {
            if brick.supportingBricks.isEmpty {
                assert(brick.zRange.lowerBound == 1) // Only a brick on the ground could possible have no `supportingBricks`.
                continue
            }

            // If all the `supportingBricks` are falling, this one will also fall
            if brick.supportingBricks.isSubset(of: fallingBricks) {
                fallingBricks.insert(brick.id)
                ans += 1
            }
        }
                
        return ans
    }
}

let brickDescriptions = try inputParser.parse(String.input)
let bricks = brickDescriptions.map(Brick.init)
let brickStack = BrickStack(brickSnapshot: bricks)

measure(part: .one) {
    /* Part One */
    return brickStack.countOfDisintegratableBricks
}

measure(part: .two) {
    /* Part Two */
    return brickStack.bricks.reduce(0) { $0 + brickStack.countOfBricksToFallAfterDisintegration(of: $1) }
}
