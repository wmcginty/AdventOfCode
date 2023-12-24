//
//  Parse.swift
//  Day24
//
//  Created by Will McGinty on 12/24/23.
//

import Foundation
import Parsing

let hailstoneParser = ParsePrint(input: Substring.self, .memberwise(Hailstone.init)) {
    Int.parser()
    ","
    Whitespace()
    Int.parser()
    ","
    Whitespace()
    Int.parser()
    Whitespace()
    "@"
    Whitespace()
    Int.parser()
    ","
    Whitespace()
    Int.parser()
    ","
    Whitespace()
    Int.parser()
}

let inputParser = Many { hailstoneParser } separator: { Whitespace(.vertical) }
