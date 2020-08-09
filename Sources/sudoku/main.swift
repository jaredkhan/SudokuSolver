//
//  main.swift
//  sudoku
//
//  Created by Jared Khan on 08/08/2020.
//

import Foundation
import SudokuLib


print("hello")
//var grid = sudoku.Grid.parseFromString(gridString: "4.78.5..9..37.1.5..1..4.7861.2....74.9843.....6.91.8.5.......4.3.9..86..2..3.4198")
var grid = SudokuLib.Grid.parseFromString(gridString: "5..2...4....6.3....3...9..7..3..7.....7..8...6......2..8......3...4..6.....1..5..")
grid.printGrid()
let solvedGrid = try grid.solve()
solvedGrid.printGrid()
