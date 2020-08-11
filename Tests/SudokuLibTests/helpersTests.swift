import XCTest
@testable import SudokuLib

final class helpersTests: XCTestCase {
    func testBigUnion() {
        let result = Set.union([Set([1, 2, 3]), Set([2, 3, 4]), Set([1, 5])])
        XCTAssertEqual(result, Set([1, 2, 3, 4, 5]))
    }

    func testBigIntersection() {
        let result = Set.intersection([Set([1, 2, 3]), Set([2, 3, 4]), Set([3, 4, 5])])
        XCTAssertEqual(result, Set([3]))
    }

    func testSubsets() {
        let input = Set([1, 2, 3, 4])
        XCTAssertEqual(input.subsets(size: 3), [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]])
        XCTAssertEqual(input.subsets(size: -1), [])
        XCTAssertEqual(input.subsets(size: 0), [[]])
        XCTAssertEqual(input.subsets(size: 4), [[1, 2, 3, 4]])
    }

    func testInsertIntoAll() {
        let input: Set<Set<Int>> = [[], [1], [2]]
        let expectedOutput: Set<Set<Int>> = [[42], [1, 42], [2, 42]]
        XCTAssertEqual(input.insertingIntoAll(42), expectedOutput)
    }
}