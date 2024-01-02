//
//  main.swift
//  Day10
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation
import Parsing

enum Command {
    case noOp
    case addX(Int)
}

let parser = Many {
    OneOf {
        "noop".map { Command.noOp }
        Parse {
            "addx "
            Int.parser()
        }.map { Command.addX($0) }
    }
} separator: { "\n" }

class CPU {

    struct Cycle {
        let valueDuring: Int
        let valueEnd: Int
    }

    private(set) var registerValue: Int = 1
    private(set) var cycles: [Cycle] = []

    init() { }

    func process(commands: [Command]) {
        commands.forEach(process)
    }

    func process(command: Command) {
        switch command {
        case .noOp:
            cycles.append(Cycle(valueDuring: registerValue, valueEnd: registerValue))
        case .addX(let value):
            cycles.append(contentsOf: [Cycle(valueDuring: registerValue, valueEnd: registerValue),
                                       Cycle(valueDuring: registerValue, valueEnd: registerValue + value)])
            registerValue += value
        }
    }

    func registerValue(duringCycleNumber num: Int) -> Int {
        return cycles[num - 1].valueDuring
    }

    func signalStrength(duringCycleNumber num: Int) -> Int {
        return registerValue(duringCycleNumber: num) * num
    }
}

let commands = try parser.parse(String.input)

measure(part: .one) {
    let cpu = CPU()
    cpu.process(commands: commands)
    let interestingCycleNumbers = [20, 60, 100, 140, 180, 220]
    return interestingCycleNumbers.map { cpu.signalStrength(duringCycleNumber: $0) }.reduce(0, +)
}

class CRT {
    let width, height: Int

    let lit: String = "#"
    let dim: String = "."

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    func draw(with cpu: CPU) -> String {
        var result = ""

        for index in 1...(width * height) {
            let registerValue = cpu.registerValue(duringCycleNumber: index)
            let adjustedIndex = (index - 1) % width
            if adjustedIndex >= registerValue - 1 && adjustedIndex  <= registerValue + 1 {
                result += lit
            } else {
                result += dim
            }

            if index % width == 0 {
                result += "\n"
            }
        }

        return result
    }
}

measure(part: .two, splitAnswerToNewline: true) {
    let cpu = CPU()
    cpu.process(commands: commands)

    let crt = CRT(width: 40, height: 6)
    return crt.draw(with: cpu)
}

