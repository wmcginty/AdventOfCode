//
//  main.swift
//  Day20
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Pulse {
    
    // MARK: - Pulse.Kind
    enum Kind: String {
        case low, high
    }
    
    // MARK: - Properties
    let kind: Kind
    let sender: String
    let destination: String
}

struct Module {

    // MARK: - Module.Kind
    enum Kind: String, CaseIterable {
        case flipFlop = "%"
        case conjunction = "&"
        case broadcaster
        case test
    }
    
    // MARK: - Properties
    let kind: Kind
    let name: String
    let destinations: [String]

    private var flipFlopOnOff = false
    private var conjunctionPulsesReceived: [String: Pulse.Kind] = [:]

    // MARK: - Initializer
    init(kind: Kind, name: String?, destinations: [String]) {
        self.kind = kind
        self.name = name ?? kind.rawValue
        self.destinations = destinations
    }

    // MARK: - Interface
    var inputs: [String] { return Array(conjunctionPulsesReceived.keys) }
    var lastReceivedAllHighPulses: Bool { return conjunctionPulsesReceived.values.allSatisfy { $0 == .high } }

    func send(pulse: Pulse.Kind) -> [Pulse] {
        return destinations.map { .init(kind: pulse, sender: name, destination: $0) }
    }
    
    mutating func connect(to inputs: [String]) {
        for input in inputs {
            conjunctionPulsesReceived[input] = .low
        }
    }

    mutating func handle(pulse: Pulse) -> [Pulse] {
        switch kind {
        case .test: return []
        case .broadcaster: return destinations.map { .init(kind: pulse.kind, sender: name, destination: $0) }
        case .flipFlop:
            guard pulse.kind == .low else { return [] }
            flipFlopOnOff.toggle()

            return destinations.map { .init(kind: flipFlopOnOff ? .high : .low, sender: name, destination: $0) }

        case .conjunction:
            conjunctionPulsesReceived[pulse.sender] = pulse.kind
            return destinations.map { .init(kind: lastReceivedAllHighPulses ? .low : .high, sender: name, destination: $0) }
        }
    }

    static let parser = Parse(input: Substring.self, Module.init) {
        Kind.parser()
        Optionally {
            Prefix(1...) { $0 != " " }.map(String.init)
        }
        " -> "
        Many { Prefix { $0 != "," && $0 != "\n" }.map(String.init) } separator: { ", " }
    }
}

struct Modules {

    // MARK: - Properties
    let list: [Module]
    var dictionary: [String: Module]

    // MARK: - Initializer
    init(list: [Module]) {
        self.list = list
        self.dictionary = Dictionary(uniqueKeysWithValues: list.map { ($0.name, $0) })

        connectModuleInputs()
    }

    var buttonPulse: Pulse { return Pulse(kind: .low, sender: "button", destination: "broadcaster") }

    mutating func connectModuleInputs() {
        let inputs: [String: [String]] = list.reduce(into: [:]) { partialResult, module in
            for destination in module.destinations {
                partialResult[destination, default: []].append(module.name)
            }
        }

        inputs.forEach { dictionary[$0]?.connect(to: $1) }
    }

    func inputs(toConjuctionModuleWithName name: String) -> [String] {
        return dictionary[name]?.inputs ?? []
    }
}

let inputParser = Many { Module.parser } separator: { Whitespace(.vertical) }.map(Modules.init)

try measure(part: .one) {
    /* Part One */
    var modules = try inputParser.parse(String.input)

    var buttonPushes = 1
    var lowPulsesSent = 1
    var highPulsesSent = 0
    let maxButtonPushes = 1000

    var deque = Deque<Pulse>([modules.buttonPulse])
    while let next = deque.popFirst() {
        // Find the module in the dictionary, if it doesn't exist create a new 'test' module to send pulses to
        var destination = modules.dictionary[next.destination] ?? Module(kind: .test, name: next.destination, destinations: [])

        // Instruct the destination to handle the pulse it has been sent, which will generate a new set of pulses.
        let nextPulses = destination.handle(pulse: next)
        lowPulsesSent += nextPulses.filter { $0.kind == .low }.count
        highPulsesSent  += nextPulses.filter { $0.kind == .high }.count
        
        // Update the module that just handled the pulse in storage
        modules.dictionary[next.destination] = destination

        // If we've hit the end of a button press cycle, press the button again if applicable
        if deque.isEmpty && nextPulses.isEmpty && buttonPushes < maxButtonPushes {
            buttonPushes += 1
            lowPulsesSent += 1
            deque.append(modules.buttonPulse)
        }
        
        // Enqueue the new pulses to be handled
        deque.append(contentsOf: nextPulses)
    }
    
    return lowPulsesSent * highPulsesSent
}

try measure(part: .two) {
    /* Part Two */
    var modules = try inputParser.parse(String.input)

    var buttonPushes = 1
    let watchedInputs: [String] = modules.inputs(toConjuctionModuleWithName: "dn")
    var lastHighPulse: [String: Int] = [:]
    var highPulseCycleLength: [String: Int] = [:]

    var deque = Deque<Pulse>([modules.buttonPulse])
    while let next = deque.popFirst() {
        // Find the module in the dictionary, if it doesn't exist create a new 'test' module to send pulses to
        var destination = modules.dictionary[next.destination] ?? Module(kind: .test, name: next.destination, destinations: [])

        // Instruct the destination to handle the pulse it has been sent, which will generate a new set of pulses.
        let nextPulses = destination.handle(pulse: next)
        
        /* This relies on the fact that 'rx' is fed by 1 conjunction module ('dn'), which is fed by 4 conjunction modules in independent small cycles.
         The idea is to figure out how many button presses it takes each of these cycles to repeat, then find the LCM of those 4 cycles.
         Each cycle is when these inputs to the input to 'rx' send a HIGH pulse, which means the input to 'rx' sends a LOW pulse to 'rx'.*/
        if watchedInputs.contains(where: { $0 == destination.name }), !destination.lastReceivedAllHighPulses {

            if let last = lastHighPulse[destination.name], highPulseCycleLength[destination.name] == nil {
                // Cycle detected in one of the 4 important input conjunction modules.
                highPulseCycleLength[destination.name] = buttonPushes - last
            } else {
                // First high pulse from one of the 4 important input conjunction modules.
                lastHighPulse[destination.name] = buttonPushes
            }
            
            // Now that all 4 have cycled, we can find the LCM - which should be our answer.
            if highPulseCycleLength.keys.count == 4 {
                return highPulseCycleLength.map(\.value).leastCommonMultiple ?? -1

            }
        }

        // Update the module that just handled the pulse in storage
        modules.dictionary[next.destination] = destination

        // If we've hit the end of a button press cycle, press the button again
        if deque.isEmpty && nextPulses.isEmpty {
            deque.append(modules.buttonPulse)
            buttonPushes += 1
        }
        
        deque.append(contentsOf: nextPulses)
    }

    return -1
}

