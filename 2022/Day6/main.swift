//
//  main.swift
//  Day6
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation
import Algorithms

func indexOfFirstUniqueWindow(ofLength length: Int, from input: String) -> Int? {
    return input.windows(ofCount: length)
        .enumerated()
        .first { Set($0.element).count == $0.element.count }
        .map { $0.offset + length }
}

measure(part: .one) {
    return indexOfFirstUniqueWindow(ofLength: 4, from: .input)
}

measure(part: .two) {
    indexOfFirstUniqueWindow(ofLength: 14, from: .input)
}

