//
//  InjectMacro.swift
//  Convenience
//
//  Created by Adam Londa on 07.12.2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

// periphery:ignore
public struct InjectMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let variableDeclaration = declaration.as(VariableDeclSyntax.self) else {
            throw MacroError.invalidUsage("Inject macro can only be applied to variable declarations")
        }

        guard variableDeclaration.bindingSpecifier.tokenKind == .keyword(.var) else {
            throw MacroError.invalidUsage("Inject macro can only be applied to var declarations")
        }

        guard let binding = variableDeclaration.bindings.first else {
            return []
        }

        guard binding.accessorBlock == nil else {
            throw MacroError.invalidUsage("Inject macro can't be applied to computed properties")
        }

        guard binding.initializer == nil else {
            throw MacroError.invalidUsage("Inject macro can't be applied to initialized properties")
        }

        guard let typeIdentifier = binding.typeAnnotation?
            .type
            .as(IdentifierTypeSyntax.self)?
            .name
        else {
            return []
        }

        let getter: AccessorDeclSyntax = """
        get async {
            await dependencies.resolve(\(raw: typeIdentifier.text).self)
        }
        """

        return [getter]
    }
}
