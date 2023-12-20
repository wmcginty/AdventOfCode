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
    
    enum Kind: String {
        case low, high
    }
    
    let kind: Kind
    let sender: String
    let destination: String
}

struct Module {
    enum Kind: String, CaseIterable {
        
        /// Flip-flop modules (prefix %) are either on or off; they are initially off. If a flip-flop module receives a high pulse, it is ignored and nothing happens. However, if a flip-flop module receives a low pulse, it flips between on and off. If it was off, it turns on and sends a high pulse. If it was on, it turns off and sends a low pulse.
        case flipFlop = "%"
        
        /// Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected input modules; they initially default to remembering a low pulse for each input. When a pulse is received, the conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.
        case conjunction = "&"
        
        /// There is a single broadcast module (named broadcaster). When it receives a pulse, it sends the same pulse to all of its destination modules.
        case broadcaster
        case test
    }
    
    let kind: Kind
    let name: String
    let destinations: [String]
    
    init(kind: Kind, name: String?, destinations: [String]) {
        self.kind = kind
        self.name = name ?? kind.rawValue
        self.destinations = destinations
    }
    
    private var flipFlopOnOff = false
    private var conjunctionPulsesReceived: [String: Pulse.Kind] = [:]
    
    func send(pulse: Pulse.Kind) -> [Pulse] {
        return destinations.map { .init(kind: pulse, sender: name, destination: $0) }
    }
    
    mutating func connect(inputs: [String]) {
        for input in inputs {
            conjunctionPulsesReceived[input] = .low
        }
    }
    
    
    
    mutating func handle(pulse: Pulse) -> [Pulse] {
//        debugPrint("\(String(describing: pulse.sender)) -\(pulse.kind.rawValue)-> \(pulse.destination)")
        
        switch kind {
        case .test: return []
        case .broadcaster: return destinations.map { .init(kind: pulse.kind, sender: name, destination: $0) }
        case .flipFlop:
            if pulse.kind == .high {
                return []
            } else {
                flipFlopOnOff.toggle()
            }
            
            let pulseToSend: Pulse.Kind = flipFlopOnOff ? .high : .low
            return destinations.map { .init(kind: pulseToSend, sender: name, destination: $0) }
            
        case .conjunction:
            conjunctionPulsesReceived[pulse.sender] = pulse.kind
            
            let pulseToSend: Pulse.Kind = conjunctionPulsesReceived.values.allSatisfy { $0 == .high } ? .low : .high
            return destinations.map { .init(kind: pulseToSend, sender: name, destination: $0) }
        }
    }
    
    var allHighStoredReceived: Bool {
        return conjunctionPulsesReceived.values.allSatisfy { $0 == .high }
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

let inputParser = Many { Module.parser } separator: { Whitespace(.vertical) }
let modules = try inputParser.parse(String.input)

//measure(part: .one) { logger in
//    /* Part One */
//    
//    var moduleDictionary = Dictionary(uniqueKeysWithValues: modules.map { ($0.name, $0) })
//
//    var inputs: [String: [String]] = [:]
//    for module in modules {
//        for destination in module.destinations {
//            inputs[destination, default: []].append(module.name)
//        }
//    }
//
//    for (module, inputList) in inputs {
//        moduleDictionary[module]?.connect(inputs: inputList)
//    }
//
//    
//    let maxButtonPushes = 1000
//    var buttonPushes = 1
//    
//    var lowPulsesSent = 1
//    var highPulsesSent = 0
//    
//    let initialPulse = Pulse(kind: .low, sender: "button", destination: "broadcaster")
//    
//    var deque = Deque<Pulse>([initialPulse])
//    while let next = deque.popFirst() {
//        var destination = moduleDictionary[next.destination] ?? Module(kind: .test, name: next.destination, destinations: [])
//        
//        // get a record of the pulses the destination eneds to send in response
//        let nextPulses = destination.handle(pulse: next)
//        lowPulsesSent += nextPulses.filter { $0.kind == .low }.count
//        highPulsesSent  += nextPulses.filter { $0.kind == .high }.count
//        
//        //update the dictionary with the module thta just handled the pulse
//        moduleDictionary[next.destination] = destination
//        
//        if deque.isEmpty && nextPulses.isEmpty && buttonPushes < maxButtonPushes {
//            buttonPushes += 1
//            lowPulsesSent += 1
//            deque.append(initialPulse)
//        }
//        
//        deque.append(contentsOf: nextPulses)
//    }
//    
//    return lowPulsesSent * highPulsesSent
//}

measure(part: .two) { logger in
    /* Part Two */
    
    var moduleDictionary = Dictionary(uniqueKeysWithValues: modules.map { ($0.name, $0) })

    var inputs: [String: [String]] = [:]
    for module in modules {
        for destination in module.destinations {
            inputs[destination, default: []].append(module.name)
        }
    }

    for (module, inputList) in inputs {
        moduleDictionary[module]?.connect(inputs: inputList)
    }
    
//    let maxButtonPushes = 1000
    var buttonPushes = 1
    
    var lowPulsesSent = 1
    var highPulsesSent = 0
    
    let initialPulse = Pulse(kind: .low, sender: "button", destination: "broadcaster")
    
    let importantInputs: [String] = inputs["dn"] ?? []
    var lastHigh: [String: Int] = [:]
    var cycleLength: [String: Int] = [:]
    
    var deque = Deque<Pulse>([initialPulse])
    while let next = deque.popFirst() {
        var destination = moduleDictionary[next.destination] ?? Module(kind: .test, name: next.destination, destinations: [])
        
        // get a record of the pulses the destination eneds to send in response
        let nextPulses = destination.handle(pulse: next)
        
        // if all the inputs to the conjunction input to rx receive 1+ lows, they will send a high. which then cause the input to RX to send a low
        if importantInputs.contains(where: { $0 == destination.name }), !destination.allHighStoredReceived {
            
            if let last = lastHigh[destination.name], cycleLength[destination.name] == nil {
                cycleLength[destination.name] = buttonPushes - last
                print(cycleLength.keys.count, cycleLength.keys)
            } else {
                lastHigh[destination.name] = buttonPushes
            }
            
            if cycleLength.keys.count == 4 {
                let values = cycleLength.map { $0.value }
                return values.leastCommonMultiple ?? -1
               
            }
        }
                
        lowPulsesSent += nextPulses.filter { $0.kind == .low }.count
        highPulsesSent  += nextPulses.filter { $0.kind == .high }.count
        
        if nextPulses.contains(where: { $0.destination == "rx" && $0.kind == .low }) {
            return buttonPushes
        }
        
        //update the dictionary with the module thta just handled the pulse
        moduleDictionary[next.destination] = destination
        
        if deque.isEmpty && nextPulses.isEmpty {
            buttonPushes += 1
            lowPulsesSent += 1
            deque.append(initialPulse)
        }
        
        deque.append(contentsOf: nextPulses)
    }
    
    return 0
//    return lowPulsesSent * highPulsesSent
}

