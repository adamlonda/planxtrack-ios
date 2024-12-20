//
//  TestMacros.swift
//  Convenience
//
//  Created by Adam Londa on 07.12.2024.
//

import SwiftSyntaxMacros

#if canImport(ConvenienceMacros)
import ConvenienceMacros

let testMacros: [String: Macro.Type] = [
    "Inject": InjectMacro.self,
    "Reducer": ReducerMacro.self
]
#endif
