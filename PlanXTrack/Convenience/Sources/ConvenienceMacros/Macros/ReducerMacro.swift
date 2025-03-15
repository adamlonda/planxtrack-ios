//
//  ReducerMacro.swift
//  Convenience
//
//  Created by Adam Londa on 07.12.2024.
//

import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

// periphery:ignore
public struct ReducerMacro {
    fileprivate static func checkClassKeyword(in declaration: some DeclGroupSyntax) throws {
        guard declaration.as(ClassDeclSyntax.self)?.classKeyword.tokenKind == .keyword(.class) else {
            throw MacroError.invalidUsage("`@Reducer` can only be applied to class declarations.")
        }
    }
}

extension ReducerMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try checkClassKeyword(in: declaration)

        let initializer: DeclSyntax = """
        public init() {}
        """

        return [
            initializer
        ]
    }
}

extension ReducerMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        try checkClassKeyword(in: declaration)

        let reducerTypeExtension = try ExtensionDeclSyntax("extension \(type.trimmed): ReducerType {}")
        let sendableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Sendable {}")

        return [
            reducerTypeExtension,
            sendableExtension
        ]
    }
}
