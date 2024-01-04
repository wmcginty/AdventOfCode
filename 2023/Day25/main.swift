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

let inputParser = Many { componentParser } separator: { Whitespace(.vertical) }
let components = try inputParser.parse(String.input)

var graph = UnweightedGraph<String>()
for component in components {
    let left = String(component.0)
    for subcomponent in component.1 {
        graph.addEdge(.undirected, from: left, to: String(subcomponent))
    }
}

measure(part: .one) {
    // This works. It takes FOREVER on the real input - 8m 17s - but it does get the correct answer. Definitely would stick with NetworkX in the future (see Python solution).
    let minCut = graph.kargersMinimumCut(iterations: 100)
    let subsets = minCut.distinctSubsets(of: graph)
    let product = subsets.map(\.count).reduce(1, *)
    return product
}
