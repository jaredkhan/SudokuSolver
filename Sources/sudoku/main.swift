//
//  main.swift
//  sudoku
//
//  Created by Jared Khan on 08/08/2020.
//

import Foundation
import SudokuLib
import ArgumentParser

struct SudokuSolver: ParsableCommand {
    @Option(name: .customLong("grid"))
    var gridStrings: [String] = exampleGridStrings
    @Flag var verbose = false

    mutating func run() throws {
        let grids = gridStrings.map(Grid.parseFromString)
        let start = DispatchTime.now()

        func solve(grid: Grid) {
            var grid = grid
            grid.printGrid()
            try! grid.solve(logger: Logger(verbose: verbose))
            grid.printGrid()
        }

        for grid in grids {
            solve(grid: grid)
        }

        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000

        print("Finished in \(timeInterval) seconds")
    }
}

SudokuSolver.main()
