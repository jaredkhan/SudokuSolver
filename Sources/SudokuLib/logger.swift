//
// Created by Jared Khan on 30/08/2020.
//

import Foundation

public struct Logger: Equatable {
    let verbose: Bool
    let indentLevel: Int

    public init(verbose: Bool, indentLevel: Int = 0) {
        self.verbose = verbose
        self.indentLevel = indentLevel
    }

    func log(_ message: String) {
        if verbose {
            print(String(repeating: " ", count: indentLevel * 2) + message)
        }
    }

    func increasingIndentLevel() -> Logger {
        Logger(verbose: verbose, indentLevel: indentLevel + 1)
    }
}
