//
//  main.swift
//  Day1
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Algorithms
import Foundation

func highestTotalGroup(from input: String) -> Int {
    let elements: [Int?] = input.components(separatedBy: "\n").map { $0.isEmpty ? nil : Int($0) }
    let groups: [Int] = elements.reduce(into: [0]) { partialResult, element in
        guard let element else {
            return partialResult.append(0)
        }

        partialResult[partialResult.endIndex - 1] += element
    }

    return groups.max() ?? 0
}

func highestThreeGroupsTotal(from input: String) -> Int {
    let elements: [Int?] = input.components(separatedBy: "\n").map { $0.isEmpty ? nil : Int($0) }
    let groups: [Int] = elements.reduce(into: [0]) { partialResult, element in
        guard let element else { return partialResult.append(0) }

        partialResult[partialResult.endIndex - 1] += element
    }

    return groups.max(count: 3).reduce(0, +)
}

measure(part: .one) {
    return highestTotalGroup(from: .input)
}

measure(part: .two) {
    return highestThreeGroupsTotal(from: .input)
}
