//
//  main.swift
//  Day22
//
//  Created by Will McGinty on 12/21/22.
//

import AdventKit
import Foundation
import Parsing

enum Move {

    // MARK: - Move.Turn
    enum Turn: String {
        case clockwise = "R"
        case counterclockwise = "L"
    }

    case moveForward(Int)
    case turn(Turn)

    // Reduce large moves into smaller moves for path tracing
    func normalized() -> [Move] {
        switch self {
        case .turn(let turn): return [.turn(turn)]
        case .moveForward(let amount): return Array(repeating: .moveForward(1), count: amount)
        }
    }
}

struct Coordinate: Equatable, CustomStringConvertible {

    // MARK: - Properties
    let row: Int
    let col: Int

    // MARK: - Interface
    func line(to end: Coordinate) -> [Coordinate] {
        let dCol = (end.col - col).signum()
        let dRow = (end.row - row).signum()
        let range = max(abs(col - end.col), abs(row - end.row))
        return (0...range).map { Coordinate(row: row + dRow * $0, col: col + dCol * $0) }
    }

    func moved(by amount: Int, in direction: Player.Direction) -> Coordinate {
        switch direction {
        case .up: return Coordinate(row: row - amount, col: col)
        case .down: return Coordinate(row: row + amount, col: col)
        case .left: return Coordinate(row: row , col: col - amount)
        case .right: return Coordinate(row: row, col: col + amount)
        }
    }

    // MARK: - CustomStringConvertible
    var description: String {
        return "(\(col), \(row))"
    }
}

struct Player: CustomStringConvertible {

    // MARK: - Player.Direction
    enum Direction: CustomStringConvertible {
        case up, down, left, right

        // MARK: - Interface
        mutating func applying(turn: Move.Turn) {
            switch self {
            case .up: self = turn == .clockwise ? .right : .left
            case .down: self = turn == .clockwise ? .left : .right
            case .left: self = turn == .clockwise ? .up : .down
            case .right: self = turn == .clockwise ? .down : .up
            }
        }

        // MARK: - CustomStringConvertible
        var intValue: Int {
            switch self {
            case .up: return 3
            case .down: return 1
            case .left: return 2
            case .right: return 0
            }
        }

        var description: String {
            switch self {
            case .up: return "^"
            case .down: return "v"
            case .left: return "<"
            case .right: return ">"
            }
        }
    }

    // MARK: - Properties
    var coordinate: Coordinate
    var direction: Direction

    // MARK: - Interface
    mutating func applying(moveAmount: Int) {
        switch direction {
        case .right: coordinate = .init(row: coordinate.row + moveAmount, col: coordinate.col)
        case .left: coordinate = .init(row: coordinate.row - moveAmount, col: coordinate.col)
        case .up: coordinate = .init(row: coordinate.row, col: coordinate.col - moveAmount)
        case .down: coordinate = .init(row: coordinate.row, col: coordinate.col + moveAmount)
        }
    }

    var password: Int {
        return ((coordinate.row + 1) * 1000) + ((coordinate.col + 1) * 4) + direction.intValue
    }

    // MARK: - CustomStringConvertible
    var description: String {
        return direction.description
    }
}

// MARK: - [[Map.Contents]] + Convenience
extension [[Map.Contents]] {

    func squaredOff() -> [[Map.Contents]] {
        let maxColumns = self.map(\.count).max() ?? 0
        return self.indices.map { row in
            if self[row].count < maxColumns {
                var copy = self[row]
                for _ in 0..<(maxColumns - self[row].count) {
                    copy.append(.void)
                }

                return copy
            }

            return self[row]
        }
    }

    var startPosition: Coordinate {
        guard let column = self[0].firstIndex(where: { $0.isWalkable }) else { fatalError("There is nowhere to start on this map") }
        return Coordinate(row: 0, col: column)
    }
}

struct Map: CustomStringConvertible {

    // MARK: - Map.Contents
    enum Contents: String {
        case void = " "
        case floor = "."
        case wall = "#"

        // MARK: - Initializer
        init?(character: Character) {
            self.init(rawValue: String(character))
        }

        // MARK: - Interface
        var isVoid: Bool {
            switch self {
            case .void: return true
            default: return false
            }
        }

        var isNotVoid: Bool {
            return !isVoid
        }

        var isWalkable: Bool {
            switch self {
            case .floor: return true
            default: return false
            }
        }
    }

    // MARK: - Map.Portal
    struct Portal {

        // MARK: - Properties
        let canGoThrough: (Player, Map) -> Bool
        let playerChanger: (Player, Map) -> Player

        // MARK: - Interface
        func canGoThrough(with player: Player, in map: Map) -> Bool {
            return canGoThrough(player, map)
        }

        func goThrough(with player: inout Player, in map: Map) {
            guard canGoThrough(player, map) else { return }

            let updatedPlayer = playerChanger(player, map)
            if map.contents(at: updatedPlayer.coordinate).isWalkable {
                player = updatedPlayer
            }
        }

        // MARK: - Preset
        static func from(source: Coordinate, to destination: Coordinate, startDirection: Player.Direction, endDirection: Player.Direction) -> Portal {
            return Portal { player, map in
                guard player.coordinate == source && player.direction == startDirection else { return false }

                let proposedNext = player.coordinate.moved(by: 1, in: player.direction)
                return !map.isCoordinateInBounds(proposedNext) || map.contents(at: proposedNext).isVoid

            } playerChanger: { player, map in
                return Player(coordinate: destination, direction: endDirection)
            }
        }
    }

    enum PortalCreationMode {
        case automatic2D
        case none

        func create(in map: Map) -> [Portal] {
            switch self {
            case .none: return []
            case .automatic2D:
                let oneBigWeirdlyEdgeShapedPortal = Portal { player, map in
                    let proposedNext = player.coordinate.moved(by: 1, in: player.direction)
                    return !map.isCoordinateInBounds(proposedNext) || map.contents(at: proposedNext).isVoid

                } playerChanger: { player, map in
                    switch player.direction {
                    case .up:
                        let firstInBounds = map.contents.indices.lastIndex(where: { map.contents[$0][player.coordinate.col].isNotVoid })!
                        return Player(coordinate: .init(row: firstInBounds, col: player.coordinate.col), direction: player.direction)

                    case .down:
                        let firstInBounds = map.contents.indices.firstIndex(where: { map.contents[$0][player.coordinate.col].isNotVoid })!
                        return Player(coordinate: .init(row: firstInBounds, col: player.coordinate.col), direction: player.direction)

                    case .left:
                        let firstInBounds = map.contents[player.coordinate.row].lastIndex(where: { $0.isNotVoid })!
                        return Player(coordinate: .init(row: player.coordinate.row, col: firstInBounds), direction: player.direction)

                    case .right:
                        let firstInBounds = map.contents[player.coordinate.row].firstIndex(where: { $0.isNotVoid })!
                        return Player(coordinate: .init(row: player.coordinate.row, col: firstInBounds), direction: player.direction)
                    }
                }

                return [oneBigWeirdlyEdgeShapedPortal]
            }
        }
    }

    // MARK: - Properties
    let contents: [[Contents]]
    var portals: [Portal] = []
    var player: Player

    // MARK: - Initializer
    init(mapContents: [[Contents]], portalCreationMode: PortalCreationMode) {
        self.contents = mapContents.squaredOff()
        self.player = .init(coordinate: mapContents.startPosition, direction: .right)
        self.portals = portalCreationMode.create(in: self)
    }

    // MARK: - Interface
    func contents(at coordinate: Coordinate) -> Contents {
        return contents[coordinate.row][coordinate.col]
    }

    // Is this coordinate even allowed to be queried?
    func isCoordinateInBounds(_ coordinate: Coordinate) -> Bool {
        if coordinate.row < 0 || coordinate.row >= contents.count { return false }
        if coordinate.col < 0 || coordinate.col >= contents[coordinate.row].count { return false }

        return true
    }

    mutating func processPlayer(moves: some Sequence<Move>, visualize: Bool = false) {
        for move in moves {
            processPlayer(move: move)

            if visualize {
                print(description)
                Thread.sleep(forTimeInterval: 2)
            }
        }
    }

    mutating func processPlayer(move: Move) {
        switch move {
        case .turn(let turn): player.direction.applying(turn: turn)
        case .moveForward(let amount):

            // Move forward until you either hit a wall, or an edge of the map
            let (distance, walkableCoordinate) = walkableDestinationCoordinate(for: player, movingMaximumAmount: amount)
            player.coordinate = walkableCoordinate

            // If there is still distance you could still walk forward, check for portals
            if distance < amount {
                if let travellablePortal = portals.first(where: { $0.canGoThrough(with: player, in: self) }) {
                    // If there is a portal you can travel through, travel through it
                    travellablePortal.goThrough(with: &player, in: self)

                    // If there's still distance you can walk, start walking again
                    let (_, walkableCoordinate) = walkableDestinationCoordinate(for: player, movingMaximumAmount: amount - distance - 1)
                    player.coordinate = walkableCoordinate
                }
            }
        }
    }

    // Determines the furthest the player can walk in a given direction before hitting a wall or the edge of the map.
    func walkableDestinationCoordinate(for player: Player, movingMaximumAmount max: Int) -> ( distance: Int, newCoordinate: Coordinate) {
        if max < 1 {
            return (0, player.coordinate)
        }

        var counter = 0
        var proposedCoordinate = player.coordinate
        repeat {
            counter += 1
            proposedCoordinate = player.coordinate.moved(by: counter, in: player.direction)
            if !isCoordinateInBounds(proposedCoordinate) { break }
        } while (contents(at: proposedCoordinate).isWalkable && counter <= max)

        return (counter - 1, player.coordinate.moved(by: counter - 1, in: player.direction))
    }

    // MARK: - CustomStringConvertible
    var description: String {
        var result = ""
        for row in contents.indices {
            result += "\(row.formatted(.number.precision(.integerLength(3)))) "

            for col in contents[row].indices {
                if player.coordinate.row == row && player.coordinate.col == col {
                    result += player.description
                } else {
                    result += contents[row][col].rawValue
                }
            }

            result += "\n"
        }

        return result
    }
}

// MARK: - Parsing
let forwardParser = Parse(input: Substring.self) {
    Int.parser().map { Move.moveForward($0) }
}
let moveParser = Parse(input: Substring.self) {
    OneOf {
        forwardParser
        OneOf {
            "L".map { Move.turn(.counterclockwise) }
            "R".map { Move.turn(.clockwise) }
        }
    }
}
let movesParser = Many { moveParser } terminator: { Whitespace() }

// MARK: - Helper
func prepareMapAndMoves(from input: String, with portalCreationMode: Map.PortalCreationMode) throws -> (Map, [Move]) {
    let inputs = input.split(separator: "\n\n")
    let mapContents = inputs[0].components(separatedBy: .newlines).map { $0.compactMap(Map.Contents.init) }
    let instructions = try movesParser.parse(inputs[1])

    return (Map(mapContents: mapContents, portalCreationMode: portalCreationMode), instructions)
}

func finalPassword(from input: String) throws -> Int {
    var (map, moves) = try prepareMapAndMoves(from: input, with: .automatic2D)
    map.processPlayer(moves: moves, visualize: false)
    return map.player.password
}

try measure(part: .one) {
    try finalPassword(from: .input)
}

// MARK: - Part 2

// Yeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa. I will not be taking questions.

struct Edges {
    let topRow: [Coordinate]
    let leftColumn: [Coordinate]
    let rightColumn: [Coordinate]
    let bottomRow: [Coordinate]

    static func from(topLeft: Coordinate, topRight: Coordinate, bottomLeft: Coordinate, bottomRight: Coordinate) -> Edges {
        return Edges(topRow: topLeft.line(to: topRight),
                     leftColumn: topLeft.line(to: bottomLeft),
                     rightColumn: topRight.line(to: bottomRight),
                     bottomRow: bottomLeft.line(to: bottomRight))
    }
}

// MARK: - Example Data

//let oneEdges = Edges.from(topLeft: .init(row: 0, col: 8),
//                          topRight: .init(row: 0, col: 11),
//                          bottomLeft: .init(row: 3, col: 8),
//                          bottomRight: .init(row: 3, col: 11))
//
//let twoEdges = Edges.from(topLeft: .init(row: 4, col: 0),
//                          topRight: .init(row: 4, col: 3),
//                          bottomLeft: .init(row: 7, col: 0),
//                          bottomRight: .init(row: 7, col: 3))
//
//let threeEdges = Edges.from(topLeft: .init(row: 4, col: 4),
//                          topRight: .init(row: 4, col: 7),
//                          bottomLeft: .init(row: 7, col: 4),
//                          bottomRight: .init(row: 7, col: 7))
//
//
//let fourEdges = Edges.from(topLeft: .init(row: 4, col: 8),
//                          topRight: .init(row: 4, col: 11),
//                          bottomLeft: .init(row: 7, col: 8),
//                          bottomRight: .init(row: 7, col: 11))
//
//let fiveEdges = Edges.from(topLeft: .init(row: 8, col: 8),
//                           topRight: .init(row: 8, col: 11),
//                           bottomLeft: .init(row: 11, col: 8),
//                           bottomRight: .init(row: 11, col: 11))
//
//
//let sixEdges = Edges.from(topLeft: .init(row: 8, col: 12),
//                           topRight: .init(row: 8, col: 15),
//                           bottomLeft: .init(row: 11, col: 12),
//                           bottomRight: .init(row: 11, col: 15))
//
//// Input Form
////     1
//// 2 3 4
////     5 6
//
//// Cube Form
//// 1
//// Off Top --> Top of 2, facing D
//// Off Bottom --> Top of 4, facing D
//// Off Left --> Top of 3, facing D
//// Off Right --> Right of 6, facing L
//
//func onePortals() -> [Map.Portal] {
//    let topPortals = zip(oneEdges.topRow, twoEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .down) }
//    let bottomPortals = zip(oneEdges.bottomRow, fourEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .down) }
//    let leftPortals = zip(oneEdges.leftColumn, threeEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .down) }
//    let rightPortals = zip(oneEdges.rightColumn, sixEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .left) }
//
//    return topPortals + bottomPortals + leftPortals + rightPortals
//}
//
//// 2
//// Off Top --> top of 1, facing D
//// Off Bottom --> bottom of 5, facing U
//// Off Left --> bottom of 6, facing U
//// Off Right --> left of 3, facing R
//
//func twoPortals() -> [Map.Portal] {
//    let topPortals = zip(twoEdges.topRow, oneEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .down) }
//    let bottomPortals = zip(twoEdges.bottomRow, fiveEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .up) }
//    let leftPortals = zip(twoEdges.leftColumn, sixEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .up) }
//    let rightPortals = zip(twoEdges.rightColumn, threeEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .right) }
//
//    return topPortals + bottomPortals + leftPortals + rightPortals
//}
//
//// 3
//// Off Top --> left of 1, facing R
//// Off Bottom --> left of 5, facing R
//// Off Left --> right of 2, facing L
//// Off Right --> left of 4, facing R
//
//func threePortals() -> [Map.Portal] {
//    let topPortals = zip(threeEdges.topRow, oneEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .right) }
//    let bottomPortals = zip(threeEdges.bottomRow, fiveEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .right) }
//    let leftPortals = zip(threeEdges.leftColumn, twoEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .left) }
//    let rightPortals = zip(threeEdges.rightColumn, fourEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .right) }
//
//    return topPortals + bottomPortals + leftPortals + rightPortals
//}
//
//// 4
//// Off Top --> bottom of 1, facing U
//// Off Bottom --> top of 5, facing D
//// Off Left --> righ of 3, facing L
//// Off Right --> top of 6, facing D
//
//func fourPortals() -> [Map.Portal] {
//    let topPortals = zip(fourEdges.topRow, oneEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .up) }
//    let bottomPortals = zip(fourEdges.bottomRow, fiveEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .down) }
//    let leftPortals = zip(fourEdges.leftColumn, threeEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .left) }
//    let rightPortals = zip(fourEdges.rightColumn, sixEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .down) }
//
//    return topPortals + bottomPortals + leftPortals + rightPortals
//}
//
//// 5
//// Off Top --> bottom of 4, facing U
//// Off Bottom --> bottom of 2,facing U
//// Off Left --> bottom of 3, facing U
//// Off Right --> left of 6, facing R
//
//func fivePortals() -> [Map.Portal] {
//    let topPortals = zip(fiveEdges.topRow, fourEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .up) }
//    let bottomPortals = zip(fiveEdges.bottomRow, twoEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .up) }
//    let leftPortals = zip(fiveEdges.leftColumn, threeEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .up) }
//    let rightPortals = zip(fiveEdges.rightColumn, sixEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .right) }
//
//    return topPortals + bottomPortals + leftPortals + rightPortals
//}
//
//// 6
//// Off Top --> right of 4, facing L
//// Off Bottom --> left of 2, facing R
//// Off Left --> right of 5, facing L
//// Off Right --> right of 1, facing L
//
//func sixPortals() -> [Map.Portal] {
//    let topPortals = zip(sixEdges.topRow, fourEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .left) }
//    let bottomPortals = zip(sixEdges.bottomRow, twoEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .right) }
//    let leftPortals = zip(sixEdges.leftColumn, fiveEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .left) }
//    let rightPortals = zip(sixEdges.rightColumn, oneEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, endDirection: .left) }
//
//    return topPortals + bottomPortals + leftPortals + rightPortals
//}
//
////                    COLUMNS
////    0 ------ 3 ------- 7 ------- 11 ------- 15
////    |        |         |         |          |
////    |        |         |         |          |
////    |        |         |    1    |          |
////    |        |         |         |          |
////    |        |         |         |          |
////    3 ------ -- ------ -- ------ --- ------ 3
////    |        |         |         |          |
////    |        |         |         |          |
////    |   2    |    3    |   4     |          | ROWS
////    |        |         |         |          |
////    |        |         |         |          |
////    7 ------ -- ------ -- ------ --- ------ 7
////    |        |         |         |          |
////    |        |         |         |          |
////    |        |         |    5    |     6    |
////    |        |         |         |          |
////    |        |         |         |          |
////   11 ------ -- ------ -- ------ --- ------ 11


// MARK: - Real Data

//                    COLUMNS
//    0 ------ 49 ------ 99 ------ 149 ------ 199
//    |        |         |         |          |
//    |        |         |         |          |
//    |        |   1(T)  |    2    |          |
//    |        |         |         |          |
//    |        |         |         |          |
//   49 ------ -- ------ -- ------ --- ------ 49
//    |        |         |         |          |
//    |        |         |         |          |
//    |        |    3    |         |          |
//    |        |         |         |          |
//    |        |         |         |          |
//   99 ------ -- ------ -- ------ --- ------ 99 ROWS
//    |        |         |         |          |
//    |        |         |         |          |
//    |   4    |   5(B)  |         |          |
//    |        |         |         |          |
//    |        |         |         |          |
//  149 ------ -- ------ -- ------ --- ------ 149
//    |        |         |         |          |
//    |        |         |         |          |
//    |   6    |         |         |          |
//    |        |         |         |          |
//    |        |         |         |          |
//  199 ------ 49 ------ 99 ------ 149 ------ 199

let oneEdges = Edges.from(topLeft: .init(row: 0, col: 50),
                          topRight: .init(row: 0, col: 99),
                          bottomLeft: .init(row: 49, col: 50),
                          bottomRight: .init(row: 49, col: 99))


let twoEdges = Edges.from(topLeft: .init(row: 0, col: 100),
                          topRight: .init(row: 0, col: 149),
                          bottomLeft: .init(row: 49, col: 100),
                          bottomRight: .init(row: 49, col: 149))


let threeEdges = Edges.from(topLeft: .init(row: 50, col: 50),
                            topRight: .init(row: 50, col: 99),
                            bottomLeft: .init(row: 99, col: 50),
                            bottomRight: .init(row: 99, col: 99))


let fourEdges = Edges.from(topLeft: .init(row: 100, col: 0),
                           topRight: .init(row: 100, col: 49),
                           bottomLeft: .init(row: 149, col: 0),
                           bottomRight: .init(row: 149, col: 49))


let fiveEdges = Edges.from(topLeft: .init(row: 100, col: 50),
                           topRight: .init(row: 100, col: 99),
                           bottomLeft: .init(row: 149, col: 50),
                           bottomRight: .init(row: 149, col: 99))


let sixEdges = Edges.from(topLeft: .init(row: 150, col: 0),
                          topRight: .init(row: 150, col: 49),
                          bottomLeft: .init(row: 199, col: 0),
                          bottomRight: .init(row: 199, col: 49))

// Input Form
//  1 2
//  3
//4 5
//6

// Cube Form
// 1
// Off Top --> Left of 6, facing R
// Off Bottom --> Top of 3, facing D
// Off Left --> Left of 4, facing R
// Off Right --> Left of 2, facing R

func onePortals() -> [Map.Portal] {
    let topPortals = zip(oneEdges.topRow, sixEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .up, endDirection: .right) }
    let bottomPortals = zip(oneEdges.bottomRow, threeEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .down, endDirection: .down) }
    let leftPortals = zip(oneEdges.leftColumn, fourEdges.leftColumn.reversed()).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .left, endDirection: .right) }
    let rightPortals = zip(oneEdges.rightColumn, twoEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .right, endDirection: .right) }

    return topPortals + bottomPortals + leftPortals + rightPortals
}

// 2
// Off Top --> Bottom of 6, facing U
// Off Bottom --> Right of 3, facing L
// Off Left --> Right of 1, facing L
// Off Right --> Right of 5, facing L

func twoPortals() -> [Map.Portal] {
    let topPortals = zip(twoEdges.topRow, sixEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .up, endDirection: .up) }
    let bottomPortals = zip(twoEdges.bottomRow, threeEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .down, endDirection: .left) }
    let leftPortals = zip(twoEdges.leftColumn, oneEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .left, endDirection: .left) }
    let rightPortals = zip(twoEdges.rightColumn, fiveEdges.rightColumn.reversed()).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .right, endDirection: .left) }

    return topPortals + bottomPortals + leftPortals + rightPortals
}

// 3
// Off Top --> Bottom of 1, facing U
// Off Bottom --> Top of 5, facing D
// Off Left --> Top of 4, facing D
// Off Right --> Bottom of 2, facing U

func threePortals() -> [Map.Portal] {
    let topPortals = zip(threeEdges.topRow, oneEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .up, endDirection: .up) }
    let bottomPortals = zip(threeEdges.bottomRow, fiveEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .down, endDirection: .down) }
    let leftPortals = zip(threeEdges.leftColumn, fourEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .left, endDirection: .down) }
    let rightPortals = zip(threeEdges.rightColumn, twoEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .right, endDirection: .up) }

    return topPortals + bottomPortals + leftPortals + rightPortals
}

// 4
// Off Top --> Left of 3, facing R
// Off Bottom --> Top of 6, facing D
// Off Left --> Left of 1, facing R
// Off Right --> Left of 5, facing R

func fourPortals() -> [Map.Portal] {
    let topPortals = zip(fourEdges.topRow, threeEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .up, endDirection: .right) }
    let bottomPortals = zip(fourEdges.bottomRow, sixEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .down, endDirection: .down) }
    let leftPortals = zip(fourEdges.leftColumn, oneEdges.leftColumn.reversed()).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .left, endDirection: .right) }
    let rightPortals = zip(fourEdges.rightColumn, fiveEdges.leftColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .right, endDirection: .right) }

    return topPortals + bottomPortals + leftPortals + rightPortals
}

// 5
// Off Top --> Bottom of 3, facing U
// Off Bottom --> Right of 6, facing L
// Off Left --> Right of 4, facing L
// Off Right --> Right of 2, facing L

func fivePortals() -> [Map.Portal] {
    let topPortals = zip(fiveEdges.topRow, threeEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .up, endDirection: .up) }
    let bottomPortals = zip(fiveEdges.bottomRow, sixEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .down, endDirection: .left) }
    let leftPortals = zip(fiveEdges.leftColumn, fourEdges.rightColumn).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .left, endDirection: .left) }
    let rightPortals = zip(fiveEdges.rightColumn, twoEdges.rightColumn.reversed()).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .right, endDirection: .left) }

    return topPortals + bottomPortals + leftPortals + rightPortals
}

// 6
// Off Top --> Bottom of 4, facing U
// Off Bottom --> Top of 2, facing D
// Off Left --> Top of 1, facing D
// Off Right --> Bottom of 5, facing U

func sixPortals() -> [Map.Portal] {
    let topPortals = zip(sixEdges.topRow, fourEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .up, endDirection: .up) }
    let bottomPortals = zip(sixEdges.bottomRow, twoEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .down, endDirection: .down) }
    let leftPortals = zip(sixEdges.leftColumn, oneEdges.topRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .left, endDirection: .down) }
    let rightPortals = zip(sixEdges.rightColumn, fiveEdges.bottomRow).map { Map.Portal.from(source: $0.0, to: $0.1, startDirection: .right, endDirection: .up) }

    return topPortals + bottomPortals + leftPortals + rightPortals
}

//                    COLUMNS
//    0 ------ 49 ------ 99 ------ 149 ------ 199
//    |        |         |         |          |
//    |        |         |         |          |
//    |        |   1(T)  |    2    |          |
//    |        |         |         |          |
//    |        |         |         |          |
//   49 ------ -- ------ -- ------ --- ------ 49
//    |        |         |         |          |
//    |        |         |         |          |
//    |        |    3    |         |          |
//    |        |         |         |          |
//    |        |         |         |          |
//   99 ------ -- ------ -- ------ --- ------ 99 ROWS
//    |        |         |         |          |
//    |        |         |         |          |
//    |   4    |   5(B)  |         |          |
//    |        |         |         |          |
//    |        |         |         |          |
//  149 ------ -- ------ -- ------ --- ------ 149
//    |        |         |         |          |
//    |        |         |         |          |
//    |   6    |         |         |          |
//    |        |         |         |          |
//    |        |         |         |          |
//  199 ------ 49 ------ 99 ------ 149 ------ 199

func finalPasswordFor3DCube(with input: String) throws -> Int {
    var (map, moves) = try prepareMapAndMoves(from: input, with: .none)
    map.portals = onePortals() + twoPortals() + threePortals() + fourPortals() + fivePortals() + sixPortals()

    map.processPlayer(moves: moves, visualize: false)
    return map.player.password
}

try measure(part: .two) {
    try finalPasswordFor3DCube(with: .input)
}
