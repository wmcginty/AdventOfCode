//
//  Parse.swift
//  Day22
//
//  Created by Will McGinty on 12/22/23.
//

import Parsing

extension Coordinate3D {

    static let parser = Parse(input: Substring.self, Coordinate3D.init) {
        Int.parser()
        ","
        Int.parser()
        ","
        Int.parser()
    }
}

let lineParser = Parse(input: Substring.self, BrickDescription.init) {
    Coordinate3D.parser
    "~"
    Coordinate3D.parser
}
let inputParser = Many { lineParser } separator: { "\n" }
