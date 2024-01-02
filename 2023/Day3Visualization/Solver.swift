//
//  Solver.swift
//  Day3Visualization
//
//  Created by Will McGinty on 12/3/23.
//

import AdventKit
import Foundation
import Observation

@Observable
class Solver {
    
    struct SolveStep: Equatable {
        let answer: Int
        let current: Coordinate?
        let related: Set<Coordinate>
        let neighbors: Set<Coordinate>
        let neighborsContainsSymbol: Bool
        let foundEngineParts: Set<Coordinate>
    }
    
    let engineSchematic: EngineSchematic
    let startDate: Date = .now
    var solveSteps: [SolveStep] = []
    
    var grid: Grid<EngineSchematic.Contents> { return engineSchematic.grid }
    
    init(engineSchematic: EngineSchematic) {
        self.engineSchematic = engineSchematic
    }
    
    func solve() {
        var answer = 0
        var solveSteps: [SolveStep] = []
        var foundEngineParts: Set<Coordinate> = []
        
        for row in grid.rows {
            var numString = ""
            for column in grid.columns(forRow: row) {
                let coordinate = Coordinate(row: row, column: column)
                let content = grid[coordinate]
                
                if content.isNumber {
                    numString += content.description
                    
                    // this is the last column, handle now
                    if column == grid.lastColumnIndex(forRow: row) {
                        let coordinates = engineSchematic.allCoordinates(forNumberString: numString, endingAtColumn: column, inRow: row)
                        let neighbors = Set(coordinates.flatMap { $0.neighbors() }.filter { !coordinates.contains($0) })
                        let isSymbolAdjacent = neighbors.contains { engineSchematic.symbols[$0] != nil }
                        if isSymbolAdjacent {
                            let number = Int(numString)!
                            answer += number
                            
                            coordinates.forEach { foundEngineParts.insert($0) }
                        }
                        
                        numString = ""
                        solveSteps.append(.init(answer: answer, current: coordinate, related: Set(coordinates.filter { $0 != coordinate }),
                                                neighbors: neighbors, neighborsContainsSymbol: isSymbolAdjacent, foundEngineParts: foundEngineParts))
                    } else {
                        solveSteps.append(.init(answer: answer, current: coordinate, related: [], neighbors: [], neighborsContainsSymbol: false, foundEngineParts: foundEngineParts))
                    }
                } else if !numString.isEmpty {
                    // a number has ended
                    
                    let coordinates = engineSchematic.allCoordinates(forNumberString: numString, endingAtColumn: column - 1, inRow: row)
                    let neighbors = Set(coordinates.flatMap { $0.neighbors() }.filter { !coordinates.contains($0) })
                    let isSymbolAdjacent = neighbors.contains { engineSchematic.symbols[$0] != nil }
                    if isSymbolAdjacent {
                        let number = Int(numString)!
                        answer += number
                        
                        coordinates.forEach { foundEngineParts.insert($0) }
                    }
                    
                    numString = ""
                    solveSteps.append(.init(answer: answer, current: coordinate, related: Set(coordinates.filter { $0 != coordinate }),
                                            neighbors: neighbors, neighborsContainsSymbol: isSymbolAdjacent, foundEngineParts: foundEngineParts))
                } else {
                    solveSteps.append(.init(answer: answer, current: coordinate, related: [], neighbors: [], neighborsContainsSymbol: false, foundEngineParts: foundEngineParts))
                }
            }
        }
        
        solveSteps.append(.init(answer: answer, current: nil, related: [], neighbors: [], neighborsContainsSymbol: false, foundEngineParts: foundEngineParts))
        
        self.solveSteps = solveSteps
    }
    
    func solveStep(for duration: TimeInterval) -> SolveStep {
        let index = Int(duration * 2)
        return solveSteps[min(index, solveSteps.endIndex - 1)]
    }
}
