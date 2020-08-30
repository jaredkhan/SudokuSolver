//
//  main.swift
//  sudoku
//
//  Created by Jared Khan on 08/08/2020.
//

import Foundation
import SudokuLib

func solve(grid: SudokuLib.Grid) {
    var grid = grid
    grid.printGrid()
    try! grid.solve()
    grid.printGrid()
}

for grid in SudokuLib.exampleGrids {
    solve(grid: grid)
}