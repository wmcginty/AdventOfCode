//
//  main.swift
//  Day1
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

enum Digit: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine
    
    var intValue: Int {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        }
    }
}

extension String {
    
    // Part 1
    var firstAndLastDigitsCombined: Int? {
        let numString = [first(where: { $0.isNumber }), last(where: { $0.isNumber })]
            .compactMap { $0.map(String.init) }
            .joined()
        
        return Int(numString)
    }
    
    // Part 2
    func digitString(from range: Range<String.Index>) -> String {
        let contents = String(self[range])
        if let match = Digit(rawValue: contents) {
            return String(match.intValue)
        }
        
        return contents.first.map(String.init) ?? ""
    }
    
    var firstAndLastDigitsCombinedIncludingWords: Int? {
        let searchTerms = Digit.allCases.flatMap { [String($0.intValue), $0.rawValue ] }
        let searchResults = searchTerms.flatMap { self.ranges(of: $0) }.sorted(by: \.lowerBound)
        
        let firstDigit = searchResults.first.map { self.digitString(from: $0) } ?? ""
        let lastDigit = searchResults.last.map { self.digitString(from: $0) } ?? ""
        return [firstDigit, lastDigit].joined().firstAndLastDigitsCombined
    }
}

measure(part: .one) {
    return String.input.split(separator: "\n")
        .map(String.init)
        .compactMap { $0.firstAndLastDigitsCombined }
        .reduce(0, +)
}

measure(part: .two) {
    return String.input.split(separator: "\n")
        .map(String.init)
        .compactMap { $0.firstAndLastDigitsCombinedIncludingWords }
        .reduce(0, +)
}
