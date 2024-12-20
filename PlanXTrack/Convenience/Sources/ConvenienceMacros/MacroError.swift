//
//  MacroError.swift
//  Convenience
//
//  Created by Adam Londa on 07.12.2024.
//

import Foundation

enum MacroError: Error, CustomStringConvertible {
    case invalidUsage(String)

    var description: String {
        switch self {
        case .invalidUsage(let message):
            return message
        }
    }
}
