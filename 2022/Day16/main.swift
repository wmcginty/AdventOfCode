//
//  main.swift
//  Day16
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation
import Parsing

struct Valve {
    let name: String
    let flowRate: Int
    let connectedValveNames: [String]
}

let valveParser = Parse(Valve.init) {
    "Valve "
    Prefix(while: { $0 != " " }).map(String.init)
    " has flow rate="
    Int.parser()
    OneOf {
        "; tunnels lead to valves "
        "; tunnel leads to valve "
    }
    Many {
        Prefix(while: { $0 != "," && $0 != "\n" }).map(String.init)
    } separator: { ", " }
}

let valvesParser = Many { valveParser } separator: { "\n" }

class Solver {
    
    struct State: Hashable {

        // MARK: - Properties
        let position: String
        let opened: Set<String>
        let timeRemaining: Int
        let otherPlayers: Int

        // MARK: - Interface
        func startingNextPlayer(at valve: String, with time: Int) -> State {
            return .init(position: valve, opened: opened, timeRemaining: time, otherPlayers: otherPlayers - 1)
        }

        func moving(to valveName: String) -> State {
            return .init(position: valveName, opened: opened, timeRemaining: timeRemaining - 1, otherPlayers: otherPlayers)
        }

        func opening(valve: String) -> State {
            return .init(position: valve, opened: opened.union([valve]), timeRemaining: timeRemaining - 1, otherPlayers: otherPlayers)
        }
    }

    // MARK: - Properties
    let valveDict: [String: Valve]
    let maxTimeAllowed: Int
    private var cache: [State: Int] = [:]

    // MARK: - Initializer
    init(valveDict: [String: Valve], maxTimeAllowed: Int) {
        self.valveDict = valveDict
        self.maxTimeAllowed = maxTimeAllowed
    }

    func maxFlowReleasable(startingAt valve: String, otherPlayers: Int) -> Int {
        let initialState = State(position: valve, opened: [], timeRemaining: maxTimeAllowed, otherPlayers: otherPlayers)
        return maxFlowReleasable(at: initialState)
    }

    /* What is the maximum score I can achieve when I am at [valveName], after opening [opened] valves,
     with [timeRemaining] time remainining our of [maximumTime], with [otherPlayers] left to run?. */
    private func maxFlowReleasable(at state: State) -> Int {
        if state.timeRemaining == 0 {
            // If we have no time left, but other players left -> start running them
            if state.otherPlayers > 0 {
                return maxFlowReleasable(at: state.startingNextPlayer(at: "AA", with: maxTimeAllowed))
            }

            return 0
        }

        let valve = valveDict[state.position]!
        if let cached = cache[state] {
            // If we've previously seen this position, we already know the max score achievable from here
            return cached
        }

        var answer: Int = 0
        if !state.opened.contains(valve.name) && valve.flowRate > 0 {
            // If we haven't opened this valve, and we should, open it
            let futureFlow = ((state.timeRemaining - 1) * valve.flowRate) + maxFlowReleasable(at: state.opening(valve: valve.name))
            answer = max(answer, futureFlow)
        }

        // Traverse the neighbors
        for neighbor in valve.connectedValveNames {
            answer = max(answer, maxFlowReleasable(at: state.moving(to: neighbor)))
        }

        cache[state] = answer
        return answer
    }
}

let valves = try valvesParser.parse(String.input)
let valveDictionary = Dictionary(uniqueKeysWithValues: valves.map { ($0.name, $0) })

measure(part: .one) {
    let solver = Solver(valveDict: valveDictionary, maxTimeAllowed: 30)
    return solver.maxFlowReleasable(startingAt: "AA", otherPlayers: 0)
}

measure(part: .two) {
    let solver = Solver(valveDict: valveDictionary, maxTimeAllowed: 26)
    return solver.maxFlowReleasable(startingAt: "AA", otherPlayers: 1)
}
