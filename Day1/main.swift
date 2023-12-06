//
//  main.swift
//  Day1
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit

enum Digit: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine
}

extension String {

    var firstAndLastDigitsCombined: Int? {
        return calibrationScore(fromDigitString: filter(\.isNumber))
    }

    var firstAndLastDigitsCombinedIncludingWords: Int? {
        let digits = indices.reduce(into: "") { accumulator, index in
            let character = self[index]

            if character.isNumber {
                accumulator.append(String(character))
            } else {
                for (offset, digit) in Digit.allCases.enumerated() {
                    if self[index...].starts(with: digit.rawValue) {
                        accumulator.append(String(offset + 1))
                    }
                }
            }
        }

        return calibrationScore(fromDigitString: digits)
    }

    private func calibrationScore(fromDigitString digits: String) -> Int? {
        guard let first = digits.first.map(String.init), let last = digits.last.map(String.init) else { return nil }
        return Int(first + last)
    }
}

measure(part: .one) {
    /* Part One */
    
    return String.input.lines()
        .compactMap { $0.firstAndLastDigitsCombined }
        .reduce(0, +)
}

measure(part: .two) {
    /* Part Two */
    
    return String.input.lines()
        .compactMap { $0.firstAndLastDigitsCombinedIncludingWords }
        .reduce(0, +)
}
