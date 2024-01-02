//
//  Model.swift
//  Day14Visualization
//
//  Created by Will McGinty on 12/14/23.
//

import AdventKit
import Foundation

struct Content: Hashable, Identifiable {

    enum Kind: String, CaseIterable {
        case roundRock = "O"
        case cubeRock = "#"
        case empty = "."

        var imageName: String {
            switch self {
            case .roundRock: "🟤"
            case .cubeRock: "🟫"
            case .empty: ""
            }
        }
    }

    let id: UUID
    let kind: Kind
}

extension Grid<Content> {

    func loadValue(at coordinate: Coordinate) -> Int {
        guard self[coordinate].kind == .roundRock else { return 0 }
        return rowCount - coordinate.y
    }

    var totalLoadOnNorthSupports: Int {
        return allCoordinates.map { loadValue(at: $0) }.reduce(0,+)
    }

    mutating func tilt(to direction: Coordinate.Direction) {
        for row in rows {
            let columns = columns(forRow: row)
            for col in columns {
                let coordinate = Coordinate(row: direction == .south ? rows.upperBound - 1 - row  : row,
                                            column: direction == .east ? columns.upperBound - 1 - col : col)
                let contents = self[coordinate]
                guard contents.kind == .roundRock else { continue }

                var nextCoordinate = coordinate.neighbor(in: direction)
                while rows.contains(nextCoordinate.row) && columns.contains(nextCoordinate.column) && self[nextCoordinate].kind == .empty {
                    nextCoordinate = nextCoordinate.neighbor(in: direction)
                }
                nextCoordinate = nextCoordinate.neighbor(in: direction.inverse)

                self[coordinate] = .init(id: .init(), kind: .empty)
                self[nextCoordinate] = contents
            }
        }
    }
}
