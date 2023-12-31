//
//  main.swift
//  Day7
//
//  Created by Will McGinty on 12/19/22.
//

import AdventKit
import Foundation
import Parsing

enum Input {
    case command(Command)
    case contents(Contents)
}

enum Command {
    case changeDirectory(String)
    case listContents
}

enum Contents: Equatable {
    case directory(String)
    case file(String, UInt)
}

let changeDirectoryParse = Parse {
    "cd "
    Prefix(while: { $0 != "\n" })
}.map { Command.changeDirectory(String($0)) }

let commandParse = Parse {
    "$ "
    OneOf {
        changeDirectoryParse
        "ls".map { Command.listContents }
    }
}

let directoryContentParse = Parse {
    "dir "
    Prefix(while: { $0 != "\n" })
}.map { Contents.directory(String($0)) }

let fileContentParse = Parse(input: Substring.self) {
    UInt.parser()
    " "
    Prefix(while: { $0 != "\n" })
}.map { Contents.file(String($1), $0) }

let contentsParse = Parse {
    OneOf {
        directoryContentParse
        fileContentParse
    }
}

let inputParse = Parse {
    OneOf {
        commandParse.map { Input.command($0) }
        contentsParse.map { Input.contents($0) }
    }
}

let terminalInput = try Many { inputParse } separator: { "\n" }.parse(String.input)
let tree = TreeNode(terminalInput: terminalInput)

extension TreeNode where T == Contents {

    convenience init(terminalInput: [Input]) {
        self.init(.directory("/"))

        var currentNode: TreeNode<Contents> = self
        for input in terminalInput.dropFirst() {
            switch input {
            case .contents(let contents): currentNode.add(contents)
            case .command(let command):
                switch command {
                case .listContents: continue
                case .changeDirectory(let directory):
                    switch directory {
                    case "..":
                        guard let parent = currentNode.parent else { return }
                        currentNode = parent

                    default:
                        guard let matchingChild = currentNode.children.first(where: { $0.value == .directory(directory) }) else { return }
                        currentNode = matchingChild
                    }
                }
            }
        }
    }

    var fileSize: UInt {
        switch value {
        case .file(_, let size): return size
        case .directory(_): return children.map(\.fileSize).reduce(0,+)
        }
    }
}

func totalSizeOfAllDirectories(in tree: TreeNode<Contents>, over limit: UInt) -> UInt {
    var directories: [UInt] = []
    tree.depthFirstTraversal { treeNode in
        switch treeNode.value {
        case .directory: directories.append(treeNode.fileSize)
        default: break
        }
    }

    return directories.filter { $0 <= 100000 }.reduce(0, +)
}

func smallestDirectorySizeToDelete(in tree: TreeNode<Contents>, toFreeAtLeast requiredSize: UInt, withTotalSize totalSize: UInt) -> UInt {
    let occupiedSize = tree.fileSize
    let freeSize = totalSize - occupiedSize
    let requiredSizeToFree = requiredSize - freeSize

    var directory: (TreeNode<Contents>, UInt)? = nil
    tree.depthFirstTraversal { treeNode in
        switch treeNode.value {
        case .directory:
            let fileSize = treeNode.fileSize
            if fileSize >= requiredSizeToFree {
                if let existingSmallest = directory {
                    if fileSize < existingSmallest.1 {
                        directory = (treeNode, fileSize)
                    }
                } else {
                    directory = (treeNode, fileSize)
                }
            }
        default: break
        }
    }

    return directory?.1 ?? 0
}

measure(part: .one) {
    return totalSizeOfAllDirectories(in: tree, over: 100_000)
}

measure(part: .two) {
    return smallestDirectorySizeToDelete(in: tree, toFreeAtLeast: 30_000_000, withTotalSize: 700_000_00)
}
