//
//  main.swift
//  Day15
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation
import Parsing

extension Coordinate {

    var tuningFrequency: Int {
        return (x * 4000000) + y
    }
}

struct Sensor {
    let coordinate: Coordinate
    let closestBeacon: Coordinate
    let distance: Int

    init(coordinate: Coordinate, closestBeacon: Coordinate) {
        self.coordinate = coordinate
        self.closestBeacon = closestBeacon
        self.distance = coordinate.manhattanDistance(to: closestBeacon)
    }

    func coordinatesOutsideSearchRange(forRow row: Int) -> Set<Coordinate> {
        let xRange = (coordinate.x - distance)...(coordinate.x + distance)
        return Set(xRange.compactMap {
            let coord = Coordinate(x: $0, y: row)
            return coordinate.manhattanDistance(to: coord) <= distance ? coord : nil
        })
    }
}

let coordinateParser = Parse(Coordinate.init(x:y:)) {
    "x="
    Int.parser()
    ", y="
    Int.parser()
}

let sensorParser = Parse(Sensor.init) {
    "Sensor at "
    coordinateParser
    ": closest beacon is at "
    coordinateParser
}

func positionsNotContainingABeacon(inRow row: Int, from input: String) throws -> Int {
    let sensors = try Many { sensorParser } separator: { "\n" }.parse(input)
    return sensors.map { $0.coordinatesOutsideSearchRange(forRow: row) }
        .reduce(Set<Coordinate>()) { $0.union($1) }
        .subtracting(sensors.flatMap { [$0.coordinate, $0.closestBeacon] })
        .count
}

func tuningFrequencyForBeacon(coordinateRange: ClosedRange<Int>, from input: String) throws -> Int {
    let sensors = try Many { sensorParser} separator: { "\n" }.parse(input)

    var distressBeacon: Coordinate?
    for x in coordinateRange {
        var y = 0

        // Loop down the rows until we either hit the end or find the beacon
        while y <= coordinateRange.upperBound && distressBeacon == nil {
            let coordinate = Coordinate(x: x, y: y)
            if let detectingSensor = sensors.first(where: { $0.coordinate.manhattanDistance(to: coordinate) <= $0.distance }) {
                // We have found a sensor that is within range of this coordinate, so the beacon isn't here
                let xDistance = abs(detectingSensor.coordinate.x - x)

                // We can skip to the square directly below the "diamond" detection area of this  sensor
                y = detectingSensor.coordinate.y + detectingSensor.distance - xDistance + 1

            } else {
                // There's no sensors in range here, so this has to be the distress beacon
                distressBeacon = coordinate
            }
        }
    }

    return distressBeacon?.tuningFrequency ?? 0
}

try measure(part: .one) {
    try positionsNotContainingABeacon(inRow: 2_000_000, from: .input)
}

try measure(part: .two) {
    try tuningFrequencyForBeacon(coordinateRange: 0...4_000_000, from: .input)
}
