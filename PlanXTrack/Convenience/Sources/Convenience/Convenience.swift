// The Swift Programming Language
// https://docs.swift.org/swift-book

import Core

@attached(accessor)
public macro Inject() = #externalMacro(
    module: "ConvenienceMacros",
    type: "InjectMacro"
)

@attached(member, names: named(dependencies), named(init))
@attached(extension, conformances: ReducerType, Sendable)
public macro Reducer() = #externalMacro(
    module: "ConvenienceMacros",
    type: "ReducerMacro"
)
