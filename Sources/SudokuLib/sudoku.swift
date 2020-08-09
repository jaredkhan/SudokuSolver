

struct ConsistencyError: Error {}

enum CellValue: Int, CaseIterable {
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

struct Cell: Hashable {
  var possibleValues: Set<CellValue>
  
  var isSettled: Bool {
    return possibleValues.count == 1
  }
}

public struct Grid: Equatable {
  // The 81 cells of the grid in left-to-right top-to-bottom order
  var cells: Array<Cell>
  
  public static func parseFromString(gridString: String) -> Grid {
    assert(gridString.count == 81)
    
    return Grid(cells: gridString.enumerated().map { index, char in
      if let value = Int(String(char)).flatMap({ CellValue(rawValue: $0) }) {
        return Cell(possibleValues: [value])
      } else {
        return Cell(possibleValues: Set(CellValue.allCases))
      }
    })
  }
  
  static func row(of index: Int) -> Int {
    return index / 9
  }
  static func column(of index: Int) -> Int {
    return index % 9
  }
  static func box(of index: Int) -> Int {
    return row(of: index) / 3 * 3 + column(of: index) / 3
  }
  
  static func indicesInRow(rowIndex: Int) -> Set<Int> {
    return Set((0...8).map { 9 * rowIndex + $0 })
  }
  
  static func indicesInColumn(columnIndex: Int) -> Set<Int> {
    return Set((0...8).map { columnIndex + 9 * $0 })
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
  
  func allSettled() -> Bool {
    return cells.allSatisfy(\.isSettled)
  }
  
  func isSolved() throws -> Bool {
    guard allSettled() else {
      return false
    }
    
    for unitIndex in 0...8 {
      for indicesInUnit in [Grid.indicesInRow, Grid.indicesInColumn, Grid.indicesInBox] {
        let unitComplete = indicesInUnit(unitIndex)
          .map { cells[$0].possibleValues }
          .reduce(Set<CellValue>(), { $0.union($1) }).count == CellValue.allCases.count
        guard unitComplete else {
          throw ConsistencyError()
        }
      }
    }
    
    return true
  }
  
  mutating func prune() throws {
    // Propogate constraints for naked singles
    
    var newlySettledCells = cells.enumerated().filter { $0.element.isSettled }
    
    while let newlySettledCell = newlySettledCells.popLast() {
      let cell = newlySettledCell.element
      let index = newlySettledCell.offset
      let settledValue = cell.possibleValues.first!
      let visibleIndices = Set.union(
        Grid.indicesInRow(rowIndex: Grid.row(of: index)),
        Grid.indicesInColumn(columnIndex: Grid.column(of: index)),
        Grid.indicesInBox(boxIndex: Grid.box(of: index))
      ).subtracting([index])
      for visibleIndex in visibleIndices {
        if !cells[visibleIndex].isSettled {
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
  }
  
  public func solve() throws -> Grid {
    self.printGrid()
    var solvedGrid = self
    try solvedGrid.prune()
    if try solvedGrid.isSolved() {
      return solvedGrid
    }
    // Choose the most constrained unsettled cell
    let (index, cell) = solvedGrid.cells.enumerated().filter({!$0.element.isSettled}).min(by: {$0.element.possibleValues.count < $1.element.possibleValues.count})!
    for value in cell.possibleValues {
      var newGrid = solvedGrid
      newGrid.cells[index].possibleValues = [value]
      do {
        return try newGrid.solve()
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
