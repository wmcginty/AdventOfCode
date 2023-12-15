//
//  ContentView.swift
//  Day3Visualization
//
//  Created by Will McGinty on 12/3/23.
//

import AdventKit
import SwiftUI
import Parsing

struct ContentView: View {
    
    let input: String
    @State private var solver: Solver?
    @State private var isSolving: Bool = false
    
    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: false)) { context in
            if let solver {
                let elapsed = context.date.timeIntervalSince(solver.startDate)
                let solveStep = solver.solveStep(for: elapsed)
                view(for: solver.engineSchematic, solveStep: solveStep)
                    .animation(.default, value: solveStep)
                
            } else {
                VStack {
                    if !isSolving {
                        Button("Solve") {
                            withAnimation {
                                try? createEngineSchematic()
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: - Subviews
    func view(for schematic: EngineSchematic, solveStep: Solver.SolveStep) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                Text("Sum of Engine Parts: \(solveStep.answer.formatted())")
                    .contentTransition(.numericText())
                    .transaction { transaction in
                        transaction.animation = .default
                    }
                    .font(.largeTitle)
                    .padding(8)
                
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(schematic.grid.rows, id: \.self) { (row: Int) in
                        GridRow {
                            ForEach(schematic.grid.columns(forRow: row), id: \.self) { (column: Int) in
                                let coordinate = Coordinate(row: row, column: column)
                                Text(schematic.grid[coordinate].description)
                                    .font(.body.monospaced())
                                    .fixedSize()
                                    .background(solveStep.background(for: coordinate, isLastStep: solveStep == solver?.solveSteps.last))
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    func createEngineSchematic() throws {
        let content = Parse(input: Substring.self) {
            OneOf {
                Digits(1).map { EngineSchematic.Contents.digit(String($0)) }
                Parse { "." }.map { EngineSchematic.Contents.empty }
                Prefix(1, while: { $0 != "\n" }).map { EngineSchematic.Contents.symbol(String($0)) }
            }
        }
        
        let line = Parse(input: Substring.self) { Many { content } }
        let lines = Parse { Many { line } separator: { "\n" } }
        let engineSchematic = EngineSchematic(contents: try lines.parse(input))
        solver = Solver(engineSchematic: engineSchematic)
        solver?.solve()
    }
}

extension Solver.SolveStep {
    
    func background(for coordinate: Coordinate, isLastStep: Bool) -> Color {
        if coordinate == current {
            return .cyan
        } else if related.contains(coordinate) {
            return .cyan.opacity(0.25)
        } else if neighbors.contains(coordinate) {
            return neighborsContainsSymbol ? .green : .red
        } else if foundEngineParts.contains(coordinate) {
            return .green.opacity(isLastStep ? 1: 0.25)
        }
        
        return .clear
    }
}

#Preview {
    ContentView(input: String.testInput)
        .frame(minWidth: 350, minHeight: 350)
        .previewLayout(.sizeThatFits)
}
