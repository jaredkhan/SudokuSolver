//
//  helpers.swift
//  sudoku
//
//  Created by Jared Khan on 09/08/2020.
//

import Foundation


extension Set {
  static func union(_ sets: Set<Element>...) -> Set<Element> {
    var result = Set<Element>()
    for set in sets {
      result.formUnion(set)
    }
    return result
  }
  
  func subsets(size: Int) -> Array<Self> {
    guard (0...self.count).contains(size) else { return [] }
    
    if size == 0 { return [[]] }
    
    // size > 0 and self.count >= size so self.count > 0
    assert(self.count > 0)
    
    let first = self.first!
    let tail = Set(self.dropFirst())
    
    return (
      tail.subsets(size: size - 1).map { $0.union([first]) } +
      tail.subsets(size: size)
    )
  }
}
