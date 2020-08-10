import XCTest
@testable import SudokuLib
import struct SudokuLib.Grid

let examples = [
  "5..2...4....6.3....3...9..7..3..7.....7..8...6......2..8......3...4..6.....1..5..",
  "1..4..7...2..5..8...3..6..9.1..4..7...2..5..89..3..6..7....8..28..2..9...9..7..1.",
  "8...6...9.2..4..8....1.9.....1...4..46......5..5.9.6....95.68...7..2..9.2...1...7",
]

final class sudokuTests: XCTestCase {
  func testParse() {
    let allValues = Set(Grid.Cell.Value.allCases)
    let unconstrainedCell = Grid.Cell(possibleValues: allValues)
    let expectedGrid = Grid(cells: [
      Grid.Cell(possibleValues: [.five]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.two]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.four]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.six]),
      unconstrainedCell,
      Grid.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.nine]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.seven]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.seven]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.seven]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.eight]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.six]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.two]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.eight]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.four]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.six]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.one]),
      unconstrainedCell,
      unconstrainedCell,
      Grid.Cell(possibleValues: [.five]),
      unconstrainedCell,
      unconstrainedCell,
    ], newlyConstrainedCellIndices: [0, 3, 7, 12, 14, 19, 23, 26, 29, 32, 38, 41, 45, 52, 55, 62, 66, 69, 75, 78]
    )
    
    XCTAssertEqual(Grid.parseFromString(gridString: examples[0]), expectedGrid)
  }
  
  func testSolved() {
    XCTAssertTrue(
      try Grid.parseFromString(
        gridString: "598271346742653891136849257813527964427968135659314728285796413971435682364182579"
      ).isSolved()
    )
    XCTAssertThrowsError(
      try Grid.parseFromString(
        gridString: "558271346742653891136849257813527964427968135659314728285796413971435682364182579"
      ).isSolved()
    )
  }
  
  func testSolve() throws {
    var grid = Grid.parseFromString(gridString: examples[0])
    try grid.solve()
    XCTAssertEqual(
      grid.cells,
      Grid.parseFromString(gridString: "598271346742653891136849257813527964427968135659314728285796413971435682364182579").cells
    )
  }
}
