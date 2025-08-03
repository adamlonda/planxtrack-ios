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

fileprivate extension DeclGroupSyntax {
    var isClass: Bool {
        self.as(ClassDeclSyntax.self)?.classKeyword.tokenKind == .keyword(.class)
    }

    var isActor: Bool {
        self.as(ActorDeclSyntax.self)?.actorKeyword.tokenKind == .keyword(.actor)
    }
}

// periphery:ignore
public struct ReducerMacro {
    fileprivate static func checkClassOrActorKeyword(in declaration: some DeclGroupSyntax) throws {
        guard declaration.isClass || declaration.isActor else {
            throw MacroError.invalidUsage("`@Reducer` can only be applied to class or actor declarations.")
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
        try checkClassOrActorKeyword(in: declaration)

        let initializer: DeclSyntax = """
        public init() {
        }
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
        try checkClassOrActorKeyword(in: declaration)

        let reducerExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Reducer {}")
        let sendableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Sendable {}")

        return [
            reducerExtension,
            sendableExtension
        ]
    }
}
