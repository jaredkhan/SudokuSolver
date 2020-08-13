//
//  helpers.swift
//  sudoku
//
//  Created by Jared Khan on 09/08/2020.
//

import Foundation


extension Set {
    /// Returns the union of all sets in a set of sets.
    static func union(_ sets: Set<Set<Element>>) -> Set<Element> {
        var result = Set<Element>()
        for set in sets {
            result.formUnion(set)
        }
        return result
    }

    /// Returns the intersection of all sets in a set of sets.
    static func intersection(_ sets: Set<Set<Element>>) -> Set<Element> {
        guard let first = sets.first else { fatalError("Cannot take the intersection of an empty set of sets.") }
        var result = first
        for set in sets {
            result = result.intersection(set)
        }
        return result
    }

    /// Inserts the given elements into all sets in a set of sets.
    func insertingIntoAll<InnerElement>(_ elementToAdd: InnerElement) -> Self where Element == Set<InnerElement> {
        Self(map { $0.union([elementToAdd]) })
    }

    /// Gets all subsets of self which are of the given size.
    func subsets(size: Int) -> Set<Self> {
        guard (0...count).contains(size) else { return [] }

        if size == 0 { return [[]] }
        if size == count { return [self] }

        // size > 0 and self.count >= size so self.count > 0
        assert(self.count > 0)

        let first = self.first!
        let tail = Set(self.dropFirst())

        return tail.subsets(size: size - 1).insertingIntoAll(first).union(tail.subsets(size: size))
    }
}
