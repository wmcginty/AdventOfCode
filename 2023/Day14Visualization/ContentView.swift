//
//  ContentView.swift
//  Day14Visualization
//
//  Created by Will McGinty on 12/14/23.
//

import AdventKit
import SwiftUI
import Pow

struct ContentView: View {

    let input: String
    @State private var solver: Solver?
    @State private var isSolving: Bool = false

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.33, paused: false)) { context in
            if let solver, let state = solver.displayState(at: context.date) {
                view(for: state)
                    .animation(.easeInOut, value: state.direction)
                    .animation(.easeInOut, value: state.cycle)
            }  else {
                VStack {
                    if !isSolving {
                        Button("Solve") {
                            withAnimation {
                                try? createGrid()
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
    @ViewBuilder
    func view(for state: Solver.State) -> some View {
        let grid = state.grid
        let cycle = state.cycle
        let delta = state.delta

        VStack {
            HStack {
                Text("Cycle")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Text(cycle.formatted())
                    .font(.largeTitle)
                    .contentTransition(.numericText())
                    .transaction { $0.animation = .default }
                    .changeEffect(.rise(origin: UnitPoint(x: 0.5, y: 0.5), {
                        if let delta {
                            switch delta {
                            case .increment:
                                Text("+1")
                                    .font(.caption2)
                                    .foregroundStyle(.green)

                            case .cycle(let jump):
                                Text("+Cycle of \(jump)")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                            }
                        }

                    }), value: cycle)

            }
            .padding(.bottom, 8)

            Color.clear
                .overlay {
                    GeometryReader { proxy in
                        let dimension = min(proxy.size.width, proxy.size.height)
                        let gridSize = CGFloat(max(grid.rowCount, grid.columnCount(for: 0)))
                        let itemDimension = dimension / gridSize
                        let spacing = (proxy.size.width - dimension) / 2

                        ForEach(grid.locatedContents) {
                            Text($0.element.kind.imageName)
                                .font(.body.monospaced())
                                .id($0.id)
                                .frame(width: ceil(itemDimension), height: ceil(itemDimension), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .position(x: spacing + itemDimension * CGFloat($0.coordinate.column),
                                          y: itemDimension * CGFloat($0.coordinate.row) + (itemDimension * 0.5))
                        }
                    }
                }

        }
    }

    // MARK: - Helper
    func createGrid() throws {
        solver = try Solver(input: input, cycles: 1_000_000_000)
    }
}

#Preview {
    ContentView(input: String.testInput)
        .frame(minWidth: 300, minHeight: 300)
        .previewLayout(.sizeThatFits)
}
