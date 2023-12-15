//
//  Input.swift
//  Day14
//
//  Created by Will McGinty on 12/24/22.
//

import Foundation

extension String {

    static let testInput = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

    static let input = """
    O.O#....O.O...O..OO#OO##..O..##...#..........OO..#.OO...................O..O##.#OOO...O#.#.#.O.O#OO.
    .O..OO..O.O..O......OO.#....#O#.#.#.#.#.O.OO...#.O#.OOO.#.#.#.OO..#.#O...O.O.O.O#.#.O.O....#..O#O...
    O....#..O..O.OO..#OO.O.....O#OOO..#.#......O...#..#..O......#O.#.O.#.O...#.#.#.........O#.......#OO.
    ......O.O##......###OO#..O#.#...O...O.....##.........#.OO.#........#OO.O....###...#.##..O........O.#
    #.OO.....OOO....O.....OO.OOO..#O.OO...#...O......OO###........O..#.#.O..O......O#...O.....#.#...##..
    #..O.#..OO.OO.O.OOO#O...O......O..#O..O#.O.O.O#....O.#O.O.....#..#..O.O.#O..O....O#.O..#....O#......
    #..O#...O.O.O..O...#.O.#.O..........O.#.#.........O.......##...#..O.OO#......#.......O.#.#..#.OO##O.
    O.O..O..#......#....#O....O..O#.OOO..#..O#.OO#.........O..##...O..#.........O##...O....O..O.O.O..O..
    O.O#.O...OO....O....##O.O......O.O..O....#...O...O##........#.......#....O..O.......O...#O.....#....
    ..O.#..#..OO.O..#...#..O#OOO..#.O.#O#OOO....#..OOO.#O..O..#.OOOO.........O#..O..O...O.##..O......#..
    ##..#..#.....O..OO###.........##..##..OO...#..#O.#......#O...O.....#........#....OO.#OO.#.O....#.O#O
    .O.....O.O.O....#OO..O.##OO#..O.....O..#..O..#....O..O#....O..#.OO..O....OO..O.O..O#.....O.O.#O..OO.
    O#O.##O#..................O.OO...#...#..#O....O..O..OO#.O#...##.O...##.OO#.....O.#.#...##..O.OO..O..
    O.....OO..OO..#OO#.....O.O.#....OO.#...###.......O#...##....##.O..##......#......O#O..OO.OO....O....
    .......O.O.#..O..O.#.O..O.O#O.#....##.OO.#...#.OO#..O...#..O...O...#.#...O#.....O#O........O...##.#O
    #....O..O..OOO...#....#.##.#....O.............##O#...#..O.O.##..#.O..O.#...#.O.##O..##.#...O......##
    .O...##.O.....#OO.O..O..#O.#.#...O....#...#...O..#O...........##..OO##...#...#..O#O.........O..#..#O
    O...O...O..#..#OO.....OOO.#.........O..O.......#.#.#...OO##..O...O.....O#.#..O........#.#.O.O..##.#.
    .###...#.....#..#O.O.......O.....O#.OO....##.OO.........O#...OO.OO#.#....#O#OO.O..#.OOOOO.....O...O.
    O#.#..#..OO...O..OO.#...#..........#OO#.#..O.#...##O...#..O.O....#.O....#..##.#.#.#O.#...#..#...O#..
    .#..#OO.....O..O....O........O#.O.OO....##....OO....O##O..##.#O..O#O##.O.O.O#..OO.....O#.#.........#
    O.O.#..#O...O..O..O....O.....#OOO.O.......O#.OO..O.....#O...O#...O...O......#.#.#....#..#OO.#OOO...#
    .O.....O..#O.##OO..#OOOO..#O.O.#O....OO#OOO....O....OO...O........#..O...O...O....#.O#O.O.#O.#.O.O..
    ........O.O.......O...OO...###..OO.O.....OO.O..#...#OO..#....O#......##.........#.#...#.O.O....#....
    .O.....##..O..#OO#OO.##...#O..#.OO..#..O.#O......#O..............O.....O.O.#O.O..#O.O...O.OO.O#..#O.
    O..#.#......O#..OO..#......O.O.OOO.O...O.#....#....O#...O....##..#.....O..#....O#OOO....O.O..O......
    .....O.O.....O.#..O...#O#.O..O#O..#O..##...O.#..O........O.#.O.O......OO.#....O.#.#.O..O....O#....#.
    ..#......#OO.O.#.#..OO...#.#..O.#....O#.#O.OOO....O###......#....O.##..O..#.O.#.#.O......O#.OO....#O
    #..O...OOO..O....OO.O..#..O.OO.#OO.OOO#....OO#......OO.O....O.OO..##.O.#..O...#.#.......O.....#..O..
    #..#O..O.O...#......O##.O.#......#..O##....#O####OO.#.##.O#.O.#.#...#.OO....O...#O....OO#O#.###.....
    ..##.#..O..####.#.#..O..O.#O.O#.###O...#.##O.#.#.O.O..#..O#.O.OO.#.O#.O.OO.#.O..#......#...#..O##O..
    .#.#..O...#..O.O.O.O#O..###O.O..#O..##..#.#...#OO.........O#.....##....#O..#...O...#...#...OO...O..O
    ..OOO..O..#OOO.O.#..#......#....OO.........O.#.O...O#......O.O...##.#..#.OO#O.....O......#........#.
    O.#O....O..O..O.......O..........#..OO#OO.O...#.O#.O....O..........O.....#.##..#..##.O#O....O.O...#.
    .#.OO##......O#.O..#...O..O...##..##O..#O....#..#...O...O...#.##...#.OO##O..........#O....O....#.O.O
    ..O#....OOO...O#...#.....OO##..#.O.O.O..O...OOO....#.#...........OO.O#.O.#O..#..O#O#O....#..#.O.....
    ....#.#O.#OO..#.....#.OO.#.O..O.O.###O.O..#.#O...O..#...#..O......O...#....#..OO..........##........
    ......O.O..O.O..O.#.......OO.OO..##.O...........O#OO.O#.#OO.OO.......#.OO#..###O.O.........#.#O#.O.#
    .OOO..#.O#O....O..#.......O...#..#.....OO...O............#O...OO........#O##.#.O.#.#.O....O#.O.OOOO.
    ..O..O.###OO..O.........OO.OO...#O..#...#OO.#..OO....O..O.O...O.O.....OO........#.##..#.......OO....
    ..OO..#O...O.O..O...O.O.O....#.O##....#..O.O..OO..#.O#..O........O.#..#......OO#O.O.O..#......##....
    ...O.....OO..O.OOO........O.#..OO...#........#.#...O.##O.O.O.#.#O.O...O.OOO..OO......O...#.#..O#O#..
    O#...OO...O...O....O..#....#O..#...........O..........O.O..##....O..#OO.O.#........#.OO..##....OO..O
    ...#....#.....OOOO..#O..#...O...OO.#...OO#...##..#.#....O...O#.OO...##..O.O#...O.....#..O.OO...O..O.
    #..#.O.##.O..O.O...OOO.......###..#...O.OO....#O#.....#O#O.OO..O.....#.##.#..O.#...O.OOO...O#O..O...
    .OO#.......O.....##.##..#...##O..OO#O.OO.O..O...O...OO#O...#..#...O...#..#...#O..#......OO.O.....O..
    O....#..OO.#...#......O.......O..OO#..O##....OO.#.#.#......#O..OO.O..O...#..#.O..O.OO##.O....O#..O..
    #...#.#..#....OO...O.#..OO..O..#..#..#.O.O....#.O.O.OO.O.#.O..#.....#.#..O...#.#...#O...OO.O#.O....O
    ...O.#.O.....#O.OO..O..##....#O...OO........#..O..#O...O...#...#..O..O....OO..#.O.O..OO...OO...OOO#.
    ........#...#.##O.#..#..#......O...........O..O#.O..OO..#..O.O..#OO#......O...#.....#.##O..#....O...
    .......OO#...O.O..OOO.O#O..#..#...O.O..#..#O.O.O.#..........#..#.OO...#OOOO..OO#O.O....#.O...O....O.
    ..OO.O..O#.O.##...O..#O....O...O.#....#O#.O..OOO.O.O.O...O.O.#.O....#.....#.O...........O...O....#..
    #....OOO....O...OO#..#..O......O#...O..O#.##.#O...O.O#..........O.#.##...........#O....OO.O#O...#.##
    .#......OO.O.OO#.#.#O.#O.......O..O..#......OO..#.O.O......O..O.O.O.......#O..OO....O..#.......OO.#.
    ...####OO...O..O..#.....#..O....O........##.O....#...#.O.OO##..#......OO.O.#....##...#..O...O.O..O#.
    .....O....O.#..O.OO##...OOO#....#O#.....O#...O.O.#.O...OOO#.O.......O......OO.#..............O.#O#..
    ...........O..#...#OOOO....OO.##....O.O.....O..O....O...O#.....#.O.O..O....O#..#..........#O.O....O.
    .#O.O...#..#......O...........#.O.....##O...OO.O.OOO..OO...O.OO#.....OO#.OO.....#O#..#O#.O.O.#..#O..
    #...O..#..#.O.....O.O.#.#..#...O#..#..#O..#.....OO#.#.OO#.....O#...O.OO.............O#OOO..O.O..O.O.
    .......O#O.O.#....#...........O.............O..#..OO#......OO.O...O..........OO.#..OO#O#.O##O#..O.O.
    #.#......O.....OOOOO.O#O#...#.O....#...#..O#.#O....O.O#OO....#..O.O.#.#...##.OO.#.OO#.###O.....#..O.
    OO...O.#............#.#.#...#..OO......#..O.#......##..OO....OO.#.OO...O..........O.#..O.#O###.O...O
    ##O###.OO.#.......O.O####....O.O..O.O#..#O.O.##O#......#O.##...O..#.#O..###..#.....#...#...O#....OO.
    .#....O.##...O......O###........O....#.O#....#.O.#..........#.O.O.OOOO.......###...O....O......O....
    ...O..#...#..O.#O......#O#..O.....O....O..#...##.OOOO.OOOO#..O.#..#.......#.#O#..#..#.OO#..#.#....O#
    ..OO.......O#.OOOO....O..#...O.#O#....##.........#O#OO#O#..#.##.......O.O......#.....#..O.O.#O.....#
    #.O........O..O.#..#.O#O...#O#........O#.O#O..O.............#OO#..O#OOO..#O###..OOO...#.O........##.
    ....OO.......#.O..O.O........O#.#..O.O..OO.....O....O...O#.#....O.#O#.........#....OO#O#.#OO...#.#O.
    .O.O..O.......#.OO..#...O.O#.O.#.O......#.O...OOO......O.O.O.#.OO#O.O.O...O#..#.O#.#..##.O.O...O....
    O..#O#O.O#.#...#..O............#O.OO...O..O...OOO##.O..O#...#.O..O#..O.O...##O.OO##O..#..OO#.OO..#OO
    ...#.O.......O.#.O..O.O.......O...##O...OO.#....O..O.........O.O...#.O..OO...O.O.O....O...#..#.#.OO.
    OO.#...OO.#.O.....O....O..##O#O..O.OO#O....O..O.O..#.O.OO..O.O#.#.......O..O.....O.##....O.O..#.O...
    #..O.#OO......##..#O.#...#...........O.##...#O...O.#..#..O..O..#...........O...OO.O...O#.........OO#
    ...O..OO....##.##O..O.##......#O.O#.OO..O#..OOO.OO.##OOO.#O..O.....O....O......#O...O.#.O........OO.
    O.O.......OO#..O..#..O.###O...O.#...#O#O..#.#O#O.O..#O#...#.OO...O.....#.#.#O#..O.O#....O.O#..#O..O#
    .#...O.###....#.......O....#...OO.....O.#.#.#.....O.#.......O..#.##.O..O#O..OO..OO..#O#......#O.#.#.
    O.#.O..#O.......#.....#O#.....O.O#.......O#O.O#..##..OO.O.#..O.O..O....O...#O.O...#...##..O........O
    ...O........#.....O.###..O.O.O..#......O.#.....#O.O.#...O#..O#......#.O...#OO#....#O.O#......O..O#.#
    O...O...OO.##.#.OO#.#OOO.#.O.O.##.O#....#..O.O#O.#..#.....OO..#O...O.O.........O...#.O...O.#...O..OO
    ..#...OO.#..##.O.O..O.O...O##....#.O..O.OO#...OO.O.....O...#.O.##OO.O.O.OO....#.O.O###..O#..#...O..#
    ..#..O.O.....O..O.....O.....OO...##.#...#..##.#..O#O.....##...O.#O...O.O.#O..#....#...OO..#..O...#O#
    ......#.O....O.........O..O...#.##....OO.O...#........#...#..O.O#....#.##.#.O##.O.#.......OO.....O#.
    .O....O.....O.O..O..#...O......##..#.OO.#.........#...O.#.#.....O..O..O..O..OO...O..O#.##O...#.O....
    ....O.#.#.#.#.........O.#...#......#...#.#O#.O.O#....#...O#....O.O#O.......O#.......#O...O..O..#.O#O
    ...O......OO.......#O.O.#...OO.......O.........##O.......O.......#..##....##.#.#O.#O....##....#....O
    ....O...#OO..O..O...#.....O.#O..OO#......O#OO..#....O....OOO.O.O....#..O.#...O#........O...O.#.#O...
    .O....O....OO...O......##...#O.....#...O......O....O.##OO.......#....O....O....O.O...##O...#.OO.....
    #OO.O..#..O.O##...#..#.O.O..O#O.#.......O.#O..O..O.....O.......O#...O...O.........##..OO#..O.O#.##..
    O.#O####...#O.O#.#OO..#O..O....OO.#O#....O........O..#.#OO.....O...O...O.......#.O#..O..#.#O.O..#.O.
    O.#.....#.#.....#........O#...##O....#....O..O.O.....O#O.OO..........O..##O.O...O...#.....#....O.O..
    ....#OO#.#O...O###.O.#..#...O....O.........O.#...OO#.....#....O..##...O..##O......OO.O#..........OO.
    O....O...O#O...#.#O...#.OO...O.....#O#.O..OOO#.OO.....#...#O#....O#..O##..O.O.#O#O###.OO....O...O#..
    #...O..O##..#O.O#OO....#O...#.O#...##...O#......O.#...#....O#....O.....OOO#....O..#O#.O#O....O.#O...
    #.O....##O.#.OOO..O#.O..##O#O.#O#..#.....O....##...#..O........#.O....O..#.....##.#.......#OO...#O..
    ...O.....#.....#.#....O.........O.....#O....O..OO.....#O.#....#...#.#O.O...#OO#.............O.O#..O#
    ..#O..#..#.......#....#.#.......#O..#O#....O.#O.#......#.#...#O........O.....O.#..##..O#.##...#OO...
    .O.#...#.O.O......OOOOO..O.#O...O#O.#####...#..O#....O....#...O.##..#O......O..###O.#........#.O....
    ....##.#..O........O#O.#O#..#.....O#O.O#.....#.....#........OO.....#....O..#.O....O.#O.O.O...#.##..#
    ..#..O.#O#..O...O.O.............O.....#..OOO...#O#..O...#..##...O...O........#....#..O.O...##.OO..##
    ..OO#.O..O.....O...O.##...OO.O...O....#..O.#O.......#.#O#.OO.......#.#...O..#......O..##..##.O..O#O.
    """
}
