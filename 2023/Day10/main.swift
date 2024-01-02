//
//  main.swift
//  Day10
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
    case vertical = "|"
    case horizontal = "-"
    case bottomLeftCorner = "L"
    case bottomRightCorner = "J"
    case topRightCorner = "7"
    case topLeftCorner = "F"
    case ground = "."
    
    // MARK: - Initializer
    init?(possibleConnections: [(Coordinate, Content)], at coordinate: Coordinate) {
        let validConnectionsForAllCoordinates = possibleConnections
            .map { ($0.0, $0.1.connections(at: $0.0)) }
            .filter { $0.1.contains(coordinate) }
        
        for kind in Content.allCases {
            if kind.connections(at: coordinate) == Set(validConnectionsForAllCoordinates.map({ $0.0 })) {
                self = kind; return
            }
        }
        
        fatalError("The start matches none of the possible pipe kinds")
    }
    
    // MARK: - Interface
    var description: String { return rawValue }
    var hasVerticalConnections: Bool {
        return self == .vertical || self == .bottomLeftCorner || self == .bottomRightCorner
    }
    
    func connections(at coordinate: Coordinate) -> Set<Coordinate> {
        switch self {
        case .start, .ground: return []
        case .vertical: return coordinate.neighbors(in: [.north, .south])
        case .horizontal: return coordinate.neighbors(in: [.east, .west])
        case .bottomLeftCorner: return coordinate.neighbors(in: [.north, .east])
        case .bottomRightCorner: return coordinate.neighbors(in: [.north, .west])
        case .topRightCorner: return coordinate.neighbors(in: [.south, .west])
        case .topLeftCorner: return coordinate.neighbors(in: [.south, .east])
        }
    }
}

let contentParser = Parse(input: Substring.self) { Content.parser() }
let lineParser = Many { contentParser } terminator: { Peek { Whitespace() } }
let gridParser = Many { lineParser } separator: { Whitespace(1, .vertical) }

extension Grid<Content> {

    var startContent: (Coordinate, Content?) {
        let start = dictionary.first(where: { $0.value == .start })!
        let startNeighbors = start.key.neighbors(in: .cardinal)
            .compactMap { coord in dictionary[coord].map { (coord, $0) } }
        let startContent = Content(possibleConnections: startNeighbors, at: start.key)
        
        return (start.key, startContent)
    }
}

struct PipeMap {
    
    // MARK: - Properties
    var grid: Grid<Content>
    let startCoordinate: Coordinate
    
    // MARK: - Initializer
    init?(grid: Grid<Content>) {
        self.grid = grid
        
        let (coordinate, content) = grid.startContent
        guard let content else {
            debugPrint("Could not determine what kind of pipe the start node is.")
            return nil
        }
                       
        self.startCoordinate = coordinate
        self.grid[coordinate] = content
    }
   
    // MARK: - Interface
    var loopCoordinates: Set<Coordinate> {
        var pipeCoordinates: Set<Coordinate> = []
        var currentCoordinate = startCoordinate
        
        repeat {
            pipeCoordinates.insert(currentCoordinate)
            
            let connections = grid.dictionary[currentCoordinate]?.connections(at: currentCoordinate)
            if let firstUnvisited = connections?.first(where: { !pipeCoordinates.contains($0) }) {
                currentCoordinate = firstUnvisited
            }
        } while !pipeCoordinates.contains(currentCoordinate)
        
        return pipeCoordinates
    }
    
    var loopEnclosedCoordinates: Set<Coordinate> {
        var loopEnclosed: Set<Coordinate> = []
        let loopCoordinates = self.loopCoordinates
        
        for coordinate in grid.allCoordinates {
            guard !loopCoordinates.contains(coordinate) else { continue }
            
            let coordinatesToLeft = (0..<coordinate.column).map { Coordinate(row: coordinate.row, column: $0) }
            let loopCoordinatesToLeft = loopCoordinates.intersection(coordinatesToLeft)
            let verticalLoopComponentsToLeft = loopCoordinatesToLeft.filter { grid[$0].hasVerticalConnections }.count
            
            // If we've seen an odd number of vertical loop components to the left of us, it's enclosed by the loop
            if verticalLoopComponentsToLeft.isMultiple(of: 2) == false {
                loopEnclosed.insert(coordinate)
            }
        }
        
        return loopEnclosed
    }
}

let contents = try gridParser.parse(String.input)
let grid = Grid(contents: contents)
let pipeMap = PipeMap(grid: grid)!

measure(part: .one) {
    /* Part One */
    return pipeMap.loopCoordinates.count / 2
}

measure(part: .one) {
    /* Part One - Flood Fill */
    return pipeMap.grid.floodFilled(startingAt: pipeMap.startCoordinate) {
        return $0.element.connections(at: $0.coordinate).contains($1.coordinate)
    }.count(where: { $0.isFilled }) / 2
}

measure(part: .two) {
    /* Part Two */
    return pipeMap.loopEnclosedCoordinates.count
}
