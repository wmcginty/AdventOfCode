//
//  main.swift
//  Day9
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation
import Parsing

enum Direction: String {
    case left = "L"
    case right = "R"
    case up = "U"
    case down = "D"
}

struct Move {
    let direction: Direction
    let amount: Int

    func adjustedCoordinate(from coord: Coordinate) -> Coordinate {
        switch direction {
        case .up: return .init(x: coord.x, y: coord.y + amount)
        case .down: return .init(x: coord.x, y: coord.y - amount)
        case .left: return .init(x: coord.x - amount, y: coord.y)
        case .right: return .init(x: coord.x + amount, y: coord.y)
        }
    }

    func normalized() -> [Move] {
        return Array(repeating: Move(direction: direction, amount: 1), count: amount)
    }
}

extension Coordinate {

    mutating func update(for point: Coordinate) {
        if isAdjacent(to: point) {
            return
        }

        self = .init(x: x + (point.x - x).signum(), y: y + (point.y - y).signum())
    }
}

class Node<T> {
    var value: T
    var next: Node<T>?

    init(value: T) {
        self.value = value
    }
}

class LinkedList {

    var head: Node<Coordinate>
    private var tail: Node<Coordinate>
    private(set) var tailVisitedPositions: Set<Coordinate>

    init(value: Coordinate) {
        self.head = Node(value: value)
        self.tail = head
        self.tailVisitedPositions = [tail.value]
    }

    convenience init(nodes: Int, ofValue value: Coordinate) {
        self.init(value: value)

        for _ in 0..<nodes - 1 {
            self.append(value)
        }
    }

    func append(_ value: Coordinate) {
        let node = Node(value: value)

        tail.next = node
        tail = node
    }

    func process(moves: [Move]) {
        moves.flatMap { $0.normalized() }.forEach { process(move: $0) }
    }

    func process(move: Move) {
        head.value = move.adjustedCoordinate(from: head.value)

        var current = head
        while let next = current.next {
            next.value.update(for: current.value)
            current = next
        }

        tailVisitedPositions.insert(tail.value)
    }
}

let moveParse = Parse(input: Substring.self) {
    Prefix { $0 != " " }
    " "
    Int.parser()
}.map { Move(direction: Direction(rawValue: String($0))!, amount: $1) }

let moves = try Many { moveParse } separator: { "\n" }.parse(String.input)

measure(part: .one) {
    let listTwo = LinkedList(nodes: 2, ofValue: .init(x: 0, y: 0))
    listTwo.process(moves: moves)

    return listTwo.tailVisitedPositions.count
}

measure(part: .two) {
    let listTen = LinkedList(nodes: 10, ofValue: .init(x: 0, y: 0))
    listTen.process(moves: moves)

    return listTen.tailVisitedPositions.count
}
