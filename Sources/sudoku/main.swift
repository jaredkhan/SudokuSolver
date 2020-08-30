//
//  main.swift
//  sudoku
//
//  Created by Jared Khan on 08/08/2020.
//

import Foundation
import SudokuLib

func solve(grid: Grid) {
    var grid = grid
    grid.printGrid()
    try! grid.solve(logger: Logger(verbosity: .verbose))
    grid.printGrid()
}

let start = DispatchTime.now()

for grid in exampleGrids {
    solve(grid: grid)
}

let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
let timeInterval = Double(nanoTime) / 1_000_000_000

print("Finished in \(timeInterval) seconds")
