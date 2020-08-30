//
// Created by Jared Khan on 30/08/2020.
//

import Foundation

public struct Logger: Equatable {
    public enum Verbosity {
        case silent
        case verbose
    }

    let verbosity: Verbosity
    let indentLevel: Int

    public init(verbosity: Verbosity, indentLevel: Int = 0) {
        self.verbosity = verbosity
        self.indentLevel = indentLevel
    }

    func log(_ message: String) {
        switch verbosity {
        case .verbose: print(String(repeating: " ", count: indentLevel * 2) + message)
        case .silent: break
        }
    }

    func increasingIndentLevel() -> Logger {
        Logger(verbosity: verbosity, indentLevel: indentLevel + 1)
    }
}
