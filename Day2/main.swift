//
//  main.swift
//  Day2
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Parsing

struct CubeCounts {
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    
    var power: Int {
        return red * green * blue
    }
    
    subscript(color: Grab.Element.Color) -> Int {
        get {
            switch color {
            case .blue: return blue
            case .red: return red
            case .green: return green
            }
        }
        set {
            switch color {
            case .blue: blue = newValue
            case .red: red = newValue
            case .green: green = newValue
            }
        }
    }
}

struct Grab {
    struct Element {
        enum Color: String, CaseIterable {
            case blue, red, green
        }
        
        let number: Int
        let color: Color
    }
    
    let elements: [Element]
}

struct Game {
    
    let id: Int
    let grabs: [Grab]
    
    func isPossible(givenCubeCounts cubeCounts: CubeCounts) -> Bool {
        return grabs.allSatisfy {
            $0.elements.allSatisfy { $0.number <= cubeCounts[$0.color] }
        }
    }
    
    func neededNumberOfCubesToPlay() -> CubeCounts {
        return grabs.reduce(CubeCounts()) {
            return $1.elements.reduce(into: $0) { $0[$1.color] = max($0[$1.color], $1.number) }
        }
    }
}

let elementParser = Parse(input: Substring.self, Grab.Element.init) { Int.parser(); " "; Grab.Element.Color.parser() }
let grabParser = Many { elementParser } separator: { ", " }.map(Grab.init)
let grabsParser = Many { grabParser } separator: { "; " }
let gameParser = Parse(Game.init) { "Game "; Int.parser(); ": "; grabsParser }
let gamesParser = Many { gameParser } separator: { "\n" }

let games = try gamesParser.parse(String.input)

measure(part: .one) {
    let possibleGamesSum = games
        .filter { $0.isPossible(givenCubeCounts: .init(red: 12, green: 13, blue: 14)) }
        .map(\.id)
        .reduce(0, +)
    
    return possibleGamesSum
}

measure(part: .two) {
    let possibleGamesSum = games
        .map { $0.neededNumberOfCubesToPlay() }
        .map(\.power)
        .reduce(0, +)
    
    return possibleGamesSum
}
