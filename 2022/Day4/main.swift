//
//  main.swift
//  Day4
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation

extension ClosedRange where Bound == Int {

    init?(string: String) {
        let components = string.components(separatedBy: "-")
        guard let lower = Int(components[0]), let upper = Int(components[1]) else { return nil }

        self = lower...upper
    }
}

struct RangePair {

    let first: ClosedRange<Int>
    let second: ClosedRange<Int>

    init(_ ranges: [ClosedRange<Int>]) {
        self.first = ranges[0]
        self.second = ranges[1]
    }

    var firstIsSubsetOfSecond: Bool {
        return first.clamped(to: second) == first || second.clamped(to: first) == second
    }

    var overlap: Bool {
        return first.overlaps(second) || second.overlaps(first)
    }
}

func numberOfFullyContainedPairs(from input: String) -> Int {
    return input.components(separatedBy: .newlines)
        .map { $0.components(separatedBy: ",") }
        .map { $0.compactMap { ClosedRange<Int>(string: $0) } }
        .map { RangePair($0) }
        .filter { $0.firstIsSubsetOfSecond }.count
}

func numberOfOverlappingPairs(from input: String) -> Int {
    return input.components(separatedBy: .newlines)
        .map { $0.components(separatedBy: ",") }
        .map { $0.compactMap { ClosedRange<Int>(string: $0) } }
        .map { RangePair($0) }
        .filter { $0.overlap }.count
}

measure(part: .one) {
    return numberOfFullyContainedPairs(from: .input)
}

measure(part: .two) {
    return numberOfOverlappingPairs(from: .input)
}
