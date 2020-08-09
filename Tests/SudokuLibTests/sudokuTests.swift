import XCTest
@testable import SudokuLib

let examples = [
  "5..2...4....6.3....3...9..7..3..7.....7..8...6......2..8......3...4..6.....1..5..",
  "1..4..7...2..5..8...3..6..9.1..4..7...2..5..89..3..6..7....8..28..2..9...9..7..1.",
  "8...6...9.2..4..8....1.9.....1...4..46......5..5.9.6....95.68...7..2..9.2...1...7",
]

final class sudokuTests: XCTestCase {
  func testParse() {
    let allValues = Set(SudokuLib.CellValue.allCases)
    let unconstrainedCell = SudokuLib.Cell(possibleValues: allValues)
    let expectedGrid = SudokuLib.Grid(cells: [
      SudokuLib.Cell(possibleValues: [.five]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.two]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.four]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.six]),
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.nine]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.seven]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.seven]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.seven]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.eight]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.six]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.two]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.eight]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.three]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.four]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.six]),
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.one]),
      unconstrainedCell,
      unconstrainedCell,
      SudokuLib.Cell(possibleValues: [.five]),
      unconstrainedCell,
      unconstrainedCell,
    ])
    
    XCTAssertEqual(SudokuLib.Grid.parseFromString(gridString: examples[0]), expectedGrid)
  }
  
  func testSolved() {
    XCTAssertTrue(
      try SudokuLib.Grid.parseFromString(
        gridString: "598271346742653891136849257813527964427968135659314728285796413971435682364182579"
      ).isSolved()
    )
    XCTAssertThrowsError(
      try SudokuLib.Grid.parseFromString(
        gridString: "558271346742653891136849257813527964427968135659314728285796413971435682364182579"
      ).isSolved()
    )
  }
  
  func testSolve() {
    XCTAssertEqual(
      try? SudokuLib.Grid.parseFromString(gridString: examples[0]).solve(),
      SudokuLib.Grid.parseFromString(gridString: "598271346742653891136849257813527964427968135659314728285796413971435682364182579")
    )
  }
}

final class helpersTests: XCTestCase {
  func testBigUnion() {
    let result = Set.union(Set([1, 2, 3]), Set([2, 3, 4]), Set([1, 5]))
    XCTAssertEqual(result, Set([1, 2, 3, 4, 5]))
  }
}
