//
//  ConveniencePlugin.swift
//  Convenience
//
//  Created by Adam Londa on 07.12.2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ConveniencePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ReducerMacro.self
    ]
}
