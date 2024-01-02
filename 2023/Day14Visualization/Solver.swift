//
//  Solver.swift
//  Day14Visualization
//
//  Created by Will McGinty on 12/14/23.
//

import AdventKit
import Foundation
import Collections
import Parsing

@Observable
class Solver {

    struct State {
        enum Delta {
            case increment
            case cycle(Int)
        }

        let cycle: Int
        let delta: Delta?
        let direction: Coordinate.Direction?
        let grid: Grid<Content>
    }

    // MARK: - Properties
    var solveStates: Deque<State>

    @ObservationIgnored
    private let directionCycle: [Coordinate.Direction] = [.north, .west, .south, .east]

    @ObservationIgnored
    private var grid: Grid<Content>
    
    @ObservationIgnored
    private var lastStep: Date?

    // MARK: - Initializer
    init(input: String, cycles: Int) throws {
        let lineParser = Many(1...) {
            Content.Kind.parser(of: Substring.self)
                .map { Content(id: .init(), kind: $0) }
        } terminator: {
            OneOf {
                Whitespace(1, .vertical)
                End()
            }
        }

        let inputParser = Many { lineParser }.map(Grid.init)
        let grid = try inputParser.parse(input)
        self.grid = grid
        self.solveStates = Deque([.init(cycle: 0, delta: nil, direction: nil, grid: grid)])

        tiltCycles(ofCount: cycles)
    }

    // MARK: - Interface
    func displayState(at date: Date) -> State? {
        guard let lastStep else {
            self.lastStep = date
            return solveStates.first
        }

        let interval = date.timeIntervalSince(lastStep) * 1000
        if interval >= 333 {
            self.lastStep = date
            if solveStates.count > 1 {
                let next = solveStates.popFirst()
                return next
            }
        }

        return solveStates.first
    }

    func tiltCycles(ofCount count: Int) {
        var cycle = 0
        var seen: [Grid<Content.Kind>: Int] = [:]

        while cycle < count {
            let mapped = grid.map(\.kind)
            if let previous = seen[mapped] {
                let difference = cycle - previous
                let remainingIterations = count  - cycle
                let jump = remainingIterations - (remainingIterations % difference)
                cycle += jump
                solveStates.append(.init(cycle: cycle, delta: .cycle(difference), direction: directionCycle.last!, grid: grid))

                if jump > 0 {
                    continue
                }
            }

            seen[mapped] = cycle
            directionCycle.forEach {
                grid.tilt(to: $0)
                solveStates.append(.init(cycle: cycle, delta: nil, direction: $0, grid: grid))
            }

            cycle += 1
            solveStates.append(.init(cycle: cycle, delta: .increment, direction: directionCycle.last!, grid: grid))
        }
    }
}
