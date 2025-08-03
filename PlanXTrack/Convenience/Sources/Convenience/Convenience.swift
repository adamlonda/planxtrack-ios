// The Swift Programming Language
// https://docs.swift.org/swift-book

// periphery:ignore
import Core

@attached(member, names: named(dependencies), named(init))
@attached(extension, conformances: Reducer, Sendable)
public macro Reducer() = #externalMacro(
    module: "ConvenienceMacros",
    type: "ReducerMacro"
)
