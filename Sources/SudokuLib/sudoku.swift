/// A sudoku grid.
public struct Grid: Equatable {
    /// The Error type thrown when the grid is unsolvable
    struct ConsistencyError: Error {
    }

    /// A single cell of the grid.
    struct Cell: Hashable {
        enum Value: Int, CaseIterable {
            case one = 1
            case two
            case three
            case four
            case five
            case six
            case seven
            case eight
            case nine
        }

        /// The set of values that could go in this cell by current reasoning.
        var possibleValues: Set<Value>

        /// True iff this cell has only one possible value.
        var isSettled: Bool {
            possibleValues.count == 1
        }
    }

    /// The 81 cells of the grid in left-to-right top-to-bottom order.
    var cells: Array<Cell>

    /// Indices of cells that have been constrained since the last prune.
    var newlyConstrainedCellIndices: Set<Int>

    /// Parse a string of digits and dots to load a grid.
    public static func parseFromString(gridString: String) -> Grid {
        assert(gridString.count == 81)

        var cells: Array<Cell> = []
        var newlyConstrainedCellIndices: Set<Int> = []
        for (index, char) in gridString.enumerated() {
            if let value = Int(String(char)).flatMap({ Grid.Cell.Value(rawValue: $0) }) {
                cells.append(Cell(possibleValues: [value]))
                newlyConstrainedCellIndices.insert(index)
            } else {
                cells.append(Cell(possibleValues: Set(Grid.Cell.Value.allCases)))
            }
        }

        return Grid(cells: cells, newlyConstrainedCellIndices: newlyConstrainedCellIndices)
    }

    /// Returns the row number of the given cell index.
    static func row(of index: Int) -> Int {
        index / 9
    }

    /// Returns the column number of the given cell index.
    static func column(of index: Int) -> Int {
        index % 9
    }

    /// Returns the box number of the given cell index.
    static func box(of index: Int) -> Int {
        row(of: index) / 3 * 3 + column(of: index) / 3
    }

    /// Indices of cells contained in the row number given.
    ///
    /// Row numbers start at 0 for the top row and go to 8 for the bottom row.
    static func indicesInRow(rowIndex: Int) -> Set<Int> {
        Set((0...8).map {
            9 * rowIndex + $0
        })
    }

    /// Indices of cells contained in the column number given.
    ///
    /// Column numbers start at 0 for the leftmost column and go to 8 for the rightmost.
    static func indicesInColumn(columnIndex: Int) -> Set<Int> {
        Set((0...8).map {
            columnIndex + 9 * $0
        })
    }

    /// Indices of cells contained in the box number given.
    ///
    /// Box numbers start at 0 for the top left and go to 8 for the bottom right.
    static func indicesInBox(boxIndex: Int) -> Set<Int> {
        let first_element_row = boxIndex / 3 * 3
        let first_element_col = boxIndex % 3 * 3
        let first_element_index = first_element_row * 9 + first_element_col
        let boxIndices = (0...2).flatMap { boxRow in
            (0...2).map { boxCol in
                first_element_index + boxRow * 9 + boxCol
            }
        }
        return Set(boxIndices)
    }

    /// The indices of all cells the share a unit with the given cell index, excluding the given cell index itself.
    static func indicesVisibleFrom(index: Int) -> Set<Int> {
        Set.union([
                Grid.indicesInRow(rowIndex: Grid.row(of: index)),
                Grid.indicesInColumn(columnIndex: Grid.column(of: index)),
                Grid.indicesInBox(boxIndex: Grid.box(of: index))
        ]).subtracting([index])
    }

    func allSettled() -> Bool {
        cells.allSatisfy(\.isSettled)
    }

    /// Check that the grid is solved.
    ///
    /// - Returns: True iff all cells are settled and all Sudoku rules are satisfied.
    /// - Throws: ConsistencyError if the cells are all settled but the rules are not met.
    func isSolved() throws -> Bool {
        guard allSettled() else {
            return false
        }

        for unitIndex in 0...8 {
            for indicesInUnit in [Grid.indicesInRow, Grid.indicesInColumn, Grid.indicesInBox] {
                let unitComplete = indicesInUnit(unitIndex)
                        .map {
                            cells[$0].possibleValues
                        }
                        .reduce(Set<Grid.Cell.Value>(), { $0.union($1) }).count == Grid.Cell.Value.allCases.count
                guard unitComplete else {
                    throw ConsistencyError()
                }
            }
        }

        return true
    }

    /// Makes logical deductions to eliminate candidate values from cells.
    ///
    /// - Throws: ConsistencyError if during deduction it is discovered that the grid cannot be solved.
    mutating func prune() throws {
        // Attempt to find groups of cells in the unit whose set of possible values is the same size as the group of cells.
        //
        // For example:
        // if 3 cells can only contain 3 possible values between them,
        // then any other cell which is visible to all 3 cells
        // cannot possibly contain any of those 3 values.
        //
        // This lets us notice cells that can only take one value (a group of size 1 with 1 possible value)
        // as well as digits which can only go in one place in a unit (the other cells, a group of 8 cells, that have 8 possible values)
        // and everything in between.

        prune: while !newlyConstrainedCellIndices.isEmpty {
            let index = newlyConstrainedCellIndices.removeFirst()

            let units = [
                Grid.indicesInRow(rowIndex: Grid.row(of: index)),
                Grid.indicesInColumn(columnIndex: Grid.column(of: index)),
                Grid.indicesInBox(boxIndex: Grid.box(of: index)),
            ]
            for unit in units {
                let filteredUnit = unit.filter { !cells[$0].isSettled || $0 == index }
                for groupSize in 1 ..< filteredUnit.count {
                    let groupsWithIndex = filteredUnit
                            .filter({ cells[$0].possibleValues.count <= groupSize })
                            .subtracting([index])
                            .subsets(size: groupSize - 1)
                            .insertingIntoAll(index)
                    for group in groupsWithIndex {
                        let possibleGroupValues = group.map { cells[$0].possibleValues }.reduce(Set(), { $0.union($1) })
                        guard possibleGroupValues.count >= groupSize else { throw ConsistencyError() }
                        if possibleGroupValues.count == groupSize {
                            print("Found that cells [\(group.map { String($0) }.joined(separator: ", "))] must contain digits [\(possibleGroupValues.map { String($0.rawValue) }.joined(separator: ", "))]")
                            let commonVisible = Set.intersection(Set(group.map { Grid.indicesVisibleFrom(index: $0) }))
                            for visibleIndex in commonVisible {
                                if !cells[visibleIndex].possibleValues.intersection(possibleGroupValues).isEmpty {
                                    cells[visibleIndex].possibleValues.subtract(possibleGroupValues)
                                    newlyConstrainedCellIndices.insert(visibleIndex)
                                }
                            }
                            continue prune
                        }
                    }
                }
            }
        }
    }

    /// Solve the grid in-place.
    ///
    /// This involves making as many logical deductions as possible and then trying all possibilities when getting stuck.
    /// Assumes there is no more than one solution.
    ///
    /// - Throws: ConsistencyError If the grid cannot be solved.
    mutating public func solve() throws {
        try prune()
        if try isSolved() {
            return
        }
        // Choose the most constrained unsettled cell
        let (index, cell) = cells.enumerated().filter({ !$0.element.isSettled }).min(by: { $0.element.possibleValues.count < $1.element.possibleValues.count })!
        for value in cell.possibleValues {
            var possibleGrid = self
            print("Guessing that cell \(index) is \(value)")
            possibleGrid.cells[index].possibleValues = [value]
            possibleGrid.newlyConstrainedCellIndices.insert(index)
            do {
                try possibleGrid.solve()
                self = possibleGrid
                return
            } catch is ConsistencyError {
                print("The guess that cell \(index) is \(value) was incorrect")
                continue
            }
        }
        throw ConsistencyError()
        printGrid()
    }

    /// Print the grid using Unicode box-drawing characters.
    public func printGrid() {
        print("┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓")
        for row in 0...8 {
            var rowString = "┃"
            for col in 0...8 {
                let cell = self.cells[row * 9 + col]
                rowString += " "
                if cell.isSettled {
                    rowString += String(cell.possibleValues.first!.rawValue)
                } else {
                    rowString += " "
                }
                rowString += " "
                if col % 3 == 2 {
                    rowString += "┃"
                } else {
                    rowString += "│"
                }
            }
            print(rowString)
            if row == 8 {
                print("┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛")
            } else if row % 3 == 2 {
                print("┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫")
            } else {
                print("┠───┼───┼───╂───┼───┼───╂───┼───┼───┨")
            }
        }
    }
}
