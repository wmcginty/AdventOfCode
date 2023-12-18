//
//  main.swift
//  Day18
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Instruction {
    enum Direction: String, CaseIterable {
        case up = "U"
        case left = "L"
        case right = "R"
        case down = "D"
        
        init(_ int: Int) {
            if int == 0 {
                self = .right
            } else if int == 1 {
                self = .down
            } else if int == 2 {
                self = .left
            } else {
                self = .up
            }
        }
    }
    
    let direction: Direction
    let count: Int
    let colorString: String
    
    func part2ed() -> Self {
        let dir = Int(String(colorString.last!))!
        let direction = Direction(dir)
        
        let countHex = String(colorString.dropLast(1))
        let decNumber = Int(countHex, radix: 16)!
        
        return Instruction(direction: direction, count: decNumber, colorString: colorString)
    }
    
    func coordinates(from coordinate: Coordinate) -> [Coordinate] {
        switch direction {
        case .up: return (1...count).map { .init(x: coordinate.x, y: coordinate.y - $0) }
        case .left: return (1...count).map { .init(x: coordinate.x - $0, y: coordinate.y) }
        case .right: return (1...count).map { .init(x: coordinate.x + $0, y: coordinate.y) }
        case .down: return (1...count).map { .init(x: coordinate.x, y: coordinate.y + $0) }
        }
    }
}

enum Content: String, CustomStringConvertible {
    case ground = "."
    case trench = "#"
    case other = "*"
    
    var description: String { rawValue }
}

let line = Parse(input: Substring.self, Instruction.init) {
    Instruction.Direction.parser()
    Whitespace()
    Int.parser()
    Whitespace()
    "(#"
    Prefix(while: { $0 != ")" }).map(String.init)
    ")"
}

let lines = Many { line } separator: { "\n" }
let instructions = try lines.parse(String.input)
let p2Instructions = instructions.map { $0.part2ed() }

struct SparseGrid {
    
    let coordinates: [Coordinate]
    let minX: Int
    let minY: Int
    let maxX: Int
    let maxY: Int
    
    init(coordinates: [Coordinate]) {
        self.coordinates = coordinates
        
        let (minimumX, maximumX) = coordinates.map(\.x).minAndMax()!
        let (minimumY, maximumY) = coordinates.map(\.y).minAndMax()!
        
        self.minX = minimumX - 1
        self.minY = minimumY - 1
        self.maxX = maximumX + 1
        self.maxY = maximumY + 1
    }
    
    var visual: String {
        var result = ""
        for y in minY...maxY {
            for x in minX...maxX {
                let coord = Coordinate(x: x, y: y)
                result += coordinates.contains(coord) ? "#" : "."
            }
            
            result += "\n"
        }
        
        return result
    }
    
    var grid: Grid<Content> {
        var contents: [[Content]] = []
        for y in minY...maxY {
            
            var row: [Content] = []
            for x in minX...maxX {
                let current = Coordinate(x: x, y: y)
                if coordinates.contains(current) {
                    row.append(.trench)
                } else {
                    row.append(.ground)
                }
            }
            
            contents.append(row)
        }
        
        return Grid(contents: contents)
    }
}

struct Polygon {
    
    let coordinates: [Coordinate]
    
    var shoelaceArea: Double {
        let sumArea = coordinates.adjacentPairs().map { Double(($0.1.y + $0.0.y) * ($0.1.x - $0.0.x)) }
        return abs(sumArea.reduce(0, +)) / 2
    }
    
    var perimeter: Double {
        return (0..<coordinates.count).map {
            let c1 = coordinates[$0]
            let c2 = coordinates[($0 + 1) % coordinates.count]
            return distance(from: c1, to: c2)
        }
        .reduce(0, +)
    }
    
    var solved: Int {
        let p = Int(self.perimeter)
        let a = Int(self.shoelaceArea)
        return (a - p / 2 + 1) + p
    }
    
    func distance(from: Coordinate, to: Coordinate) -> Double {
        let dX = Double(from.x - to.x)
        let dY = Double(from.y - to.y)
        return sqrt(dX * dX + dY * dY)
    }
}

measure(part: .one) { logger in
    /* Part One */
    
    var current = Coordinate.zero
    var coordinates: [Coordinate] = [.zero]
    
    for instruction in instructions {
        let new = instruction.coordinates(from: current)
        current = new.last!
        
        if !coordinates.contains(new.last!) {
            coordinates.append(new.last!)
        }
    }
    
    let poly = Polygon(coordinates: coordinates)
    return poly.solved
    
//    let grid = SparseGrid(coordinates: coordinates)
//    
//    var actualGrid = grid.grid
//    actualGrid.floodFill(with: .other, startingAt: .zero) { from, to in
//        return to.element == .ground
//    }
//    
//    var count = 0
//    for coord in actualGrid.allCoordinates {
//        if actualGrid[coord] == .ground || actualGrid[coord] == .trench {
//            count += 1
//        }
//    }
//    
//    return count
}

measure(part: .two) { logger in
    /* Part Two */
    var current = Coordinate.zero
    var coordinates: [Coordinate] = [.zero]
    
    for instruction in p2Instructions {
        let new = instruction.coordinates(from: current)
        current = new.last!
        coordinates.append(new.last!)
    }
    
    let poly = Polygon(coordinates: coordinates)
    return poly.solved
}
