public struct Grid: Equatable {
    struct ConsistencyError: Error {
    }

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

        var possibleValues: Set<Value>

        var isSettled: Bool {
            possibleValues.count == 1
        }
    }

    // The 81 cells of the grid in left-to-right top-to-bottom order
    var cells: Array<Cell>

    public static func parseFromString(gridString: String) -> Grid {
        assert(gridString.count == 81)

        return Grid(cells: gridString.enumerated().map { index, char in
            if let value = Int(String(char)).flatMap({ Grid.Cell.Value(rawValue: $0) }) {
                return Cell(possibleValues: [value])
            } else {
                return Cell(possibleValues: Set(Grid.Cell.Value.allCases))
            }
        })
    }

    static func row(of index: Int) -> Int {
        index / 9
    }

    static func column(of index: Int) -> Int {
        index % 9
    }

    static func box(of index: Int) -> Int {
        row(of: index) / 3 * 3 + column(of: index) / 3
    }

    static func indicesInRow(rowIndex: Int) -> Set<Int> {
        Set((0...8).map {
            9 * rowIndex + $0
        })
    }

    static func indicesInColumn(columnIndex: Int) -> Set<Int> {
        Set((0...8).map {
            columnIndex + 9 * $0
        })
    }

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

    static func indicesVisibleFrom(index: Int) -> Set<Int> {
        Set.union(
                Grid.indicesInRow(rowIndex: Grid.row(of: index)),
                Grid.indicesInColumn(columnIndex: Grid.column(of: index)),
                Grid.indicesInBox(boxIndex: Grid.box(of: index))
        ).subtracting([index])
    }

    func allSettled() -> Bool {
        cells.allSatisfy(\.isSettled)
    }

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

    mutating func prune() throws {
        // Propogate constraints for naked singles

        var newlySettledCells = cells.enumerated().filter {
            $0.element.isSettled
        }

        while let newlySettledCell = newlySettledCells.popLast() {
            let cell = newlySettledCell.element
            let index = newlySettledCell.offset
            let settledValue = cell.possibleValues.first!
            let visibleUnsettledCellIndices = Grid.indicesVisibleFrom(index: index).filter({ !cells[$0].isSettled })
            for visibleIndex in visibleUnsettledCellIndices {
                cells[visibleIndex].possibleValues.remove(settledValue)
                if cells[visibleIndex].isSettled {
                    newlySettledCells.append((visibleIndex, cells[visibleIndex]))
                }
                if cells[visibleIndex].possibleValues.count == 0 {
                    throw ConsistencyError()
                }
            }
        }
    }

    mutating public func solve() throws {
        try prune()
        if try isSolved() {
            return
        }
        // Choose the most constrained unsettled cell
        let (index, cell) = cells.enumerated().filter({ !$0.element.isSettled }).min(by: { $0.element.possibleValues.count < $1.element.possibleValues.count })!
        for value in cell.possibleValues {
            var possibleGrid = self
            possibleGrid.cells[index].possibleValues = [value]
            do {
                try possibleGrid.solve()
                self = possibleGrid
                return
            } catch is ConsistencyError {
                continue
            }
        }
        throw ConsistencyError()
    }

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


// TODO: Only prune in places that have changed since last prune
// TODO: Define a pruning stage which finds doubles
