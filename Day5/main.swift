//
//  main.swift
//  Day5
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Foundation
import Parsing

struct Mapping {
    struct Conversion {
        
        // MARK: - Properties
        let destinationRangeStart: Int
        let sourceRangeStart: Int
        let rangeLength: Int
        
        // MARK: - Interface
        var sourceRange: Range<Int> { return sourceRangeStart..<sourceRangeStart + rangeLength }
        var destinationRange: Range<Int> { return destinationRangeStart..<destinationRangeStart + rangeLength }
        
        func output(for input: Int) -> Int? {
            guard sourceRange.contains(input) else { return nil }
            return destinationRangeStart + (input - sourceRangeStart)
        }
        
        func input(for output: Int) -> Int? {
            guard destinationRange.contains(output) else { return nil }
            return sourceRangeStart + (output - destinationRangeStart)
        }
    }
    
    // MARK: - Properties
    let conversions: [Conversion]
    
    // MARK: - Interface
    func output(for input: Int) -> Int {
        return conversions.compactMap { $0.output(for: input) }.first ?? input
    }
    
    func input(for output: Int) -> Int {
        return conversions.compactMap { $0.input(for: output) }.first ?? output
    }
}

struct Almanac {
    
    // MARK: - Properties
    let seedsToBePlanted: [Int]
    let seedToSoilMapping: Mapping
    let soilToFertilizerMapping: Mapping
    let fertilizerToWaterMapping: Mapping
    let waterToLightMapping: Mapping
    let lightToTemperatureMapping: Mapping
    let temperatureToHumidityMapping: Mapping
    let humidityToLocationMapping: Mapping
    
    // MARK: - Interface
    var forwardMaps: [Mapping] {
        return [seedToSoilMapping, soilToFertilizerMapping, fertilizerToWaterMapping, waterToLightMapping,
                lightToTemperatureMapping, temperatureToHumidityMapping, humidityToLocationMapping]
    }
    
    var seedRangesToBePlanted: [Range<Int>] {
        return seedsToBePlanted.chunks(ofCount: 2).compactMap {
            guard let first = $0.first, let last = $0.last else { return nil }
            return first..<first + last
        }
    }
    
    func isInputValidSeedNumber(_ input: Int?) -> Bool {
        return input.map { input in seedRangesToBePlanted.contains { $0.contains(input) } } ?? false
    }

    func location(for seed: Int) -> Int {
        return forwardMaps.reduce(seed) { $1.output(for: $0) }
    }
    
    func seed(for location: Int) -> Int {
        return forwardMaps.reversed().reduce(location) { $1.input(for: $0) }
    }
}

let seedsToBePlanted = Parse(input: Substring.self) {
    "seeds: "
    Many { Int.parser() } separator: { Whitespace() }
}

let converter = Parse(input: Substring.self, Mapping.Conversion.init) {
    Int.parser()
    Whitespace(1, .horizontal)
    Int.parser()
    Whitespace(1, .horizontal)
    Int.parser()
}
    
let mapping = Parse(input: Substring.self, Mapping.init) {
    Skip { Prefix { $0 != "\n" } }
    Whitespace(1, .vertical)
    Many { converter } separator: { Whitespace(1, .vertical) }
}

let almanac = Parse(Almanac.init) {
    seedsToBePlanted
    Whitespace(2, .vertical)
    mapping //seed-to-soil
    Whitespace(2, .vertical)
    mapping //soil-to-fertilizer
    Whitespace(2, .vertical)
    mapping //fertilizer-to-water
    Whitespace(2, .vertical)
    mapping //water-to-light
    Whitespace(2, .vertical)
    mapping //light-to-temperature
    Whitespace(2, .vertical)
    mapping //temperature-to-humidity
    Whitespace(2, .vertical)
    mapping //humidity-to-location
}

let parsedAlmanac = try almanac.parse(String.input)

measure(part: .one) {
    /* Part One */
    
    return parsedAlmanac.seedsToBePlanted
        .map { parsedAlmanac.location(for: $0) }
        .min() ?? 0
}

measure(part: .two) {
    /* Part Two */

    var location: Int = 0
    var potentialSeed: Int? = nil
    repeat {
        potentialSeed = parsedAlmanac.seed(for: location)
        location += 1
        
    } while !parsedAlmanac.isInputValidSeedNumber(potentialSeed)
    
    // Subtract one to account for the last +1 before the check
    return location - 1
}
