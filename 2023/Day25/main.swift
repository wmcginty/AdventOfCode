//
//  main.swift
//  Day25
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

let componentParser = Parse(input: Substring.self) {
    Prefix(1...) { $0 != ":" && $0 != " " }
    ": "
    Many { Prefix(1...) { $0 != " " && $0 != "\n" } } separator: { Whitespace(.horizontal) }
}
let inputParser = Many { componentParser } separator: {
    Whitespace(1, .vertical)
}

let components = try inputParser.parse(String.testInput)
var componentDictionary: [String: Set<String>] = [:]

for component in components {
    
    let left = String(component.0)
    let right = component.1
    for c in right {
        componentDictionary[left, default: []].insert(String(c))
        componentDictionary[String(c), default: []].insert(left)
    }
}

for (key, value) in componentDictionary {
    print(key, value)
}

measure(part: .one) {
    /* Sigh. It was honestly easier to learn some more Python and use a library... */
}
