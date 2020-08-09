import XCTest
@testable import SudokuLib

final class helpersTests: XCTestCase {
    func testBigUnion() {
        let result = Set.union(Set([1, 2, 3]), Set([2, 3, 4]), Set([1, 5]))
        XCTAssertEqual(result, Set([1, 2, 3, 4, 5]))
    }

    func testSubsets() {
        let input = Set([1, 2, 3, 4])
        XCTAssertEqual(input.subsets(size: 3), [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]])
        XCTAssertEqual(input.subsets(size: -1), [])
        XCTAssertEqual(input.subsets(size: 0), [[]])
        XCTAssertEqual(input.subsets(size: 4), [[1, 2, 3, 4]])
    }
}