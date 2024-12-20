//
//  ReducerMacroTests.swift
//  Convenience
//
//  Created by Adam Londa on 07.12.2024.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ReducerMacroTests: XCTestCase {
    func testReducerMacroWithClass() throws {
        #if canImport(ConvenienceMacros)
        let source = """
        @Reducer class MyReducer {
        }
        """

        let expectedOutput = """
        class MyReducer {

            private let dependencies: Dependencies

            public init(dependencies: Dependencies) {
                self.dependencies = dependencies
            }
        }

        extension MyReducer: ReducerType {
        }

        extension MyReducer: Sendable {
        }
        """

        assertMacroExpansion(
            source,
            expandedSource: expectedOutput,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testReducerMacroWithStruct() throws {
        #if canImport(ConvenienceMacros)
        let source = """
        @Reducer struct InvalidUsage {
        }
        """

        let expectedOutput = """
        struct InvalidUsage {
        }
        """

        assertMacroExpansion(
            source,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    message: "`@Reducer` can only be applied to class declarations.",
                    line: 1,
                    column: 1
                ),
                DiagnosticSpec(
                    message: "`@Reducer` can only be applied to class declarations.",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testReducerMacroWithEnum() throws {
            #if canImport(ConvenienceMacros)
            let source = """
            @Reducer enum InvalidEnum {
            }
            """

            let expectedOutput = """
            enum InvalidEnum {
            }
            """

            assertMacroExpansion(
                source,
                expandedSource: expectedOutput,
                diagnostics: [
                    DiagnosticSpec(
                        message: "`@Reducer` can only be applied to class declarations.",
                        line: 1,
                        column: 1
                    ),
                    DiagnosticSpec(
                        message: "`@Reducer` can only be applied to class declarations.",
                        line: 1,
                        column: 1
                    )
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }

        func testReducerMacroWithProtocol() throws {
            #if canImport(ConvenienceMacros)
            let source = """
            @Reducer protocol InvalidProtocol {
            }
            """

            let expectedOutput = """
            protocol InvalidProtocol {
            }
            """

            assertMacroExpansion(
                source,
                expandedSource: expectedOutput,
                diagnostics: [
                    DiagnosticSpec(
                        message: "`@Reducer` can only be applied to class declarations.",
                        line: 1,
                        column: 1
                    ),
                    DiagnosticSpec(
                        message: "`@Reducer` can only be applied to class declarations.",
                        line: 1,
                        column: 1
                    )
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }

        func testReducerMacroWithExtension() throws {
            #if canImport(ConvenienceMacros)
            let source = """
            @Reducer extension SomeType {
            }
            """

            let expectedOutput = """
            extension SomeType {
            }
            """

            assertMacroExpansion(
                source,
                expandedSource: expectedOutput,
                diagnostics: [
                    DiagnosticSpec(
                        message: "`@Reducer` can only be applied to class declarations.",
                        line: 1,
                        column: 1
                    ),
                    DiagnosticSpec(
                        message: "`@Reducer` can only be applied to class declarations.",
                        line: 1,
                        column: 1
                    )
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }

        func testReducerMacroWithGlobalFunction() throws {
            #if canImport(ConvenienceMacros)
            let source = """
            @Reducer func invalidFunction() {
            }
            """

            let expectedOutput = """
            func invalidFunction() {
            }
            """

            assertMacroExpansion(
                source,
                expandedSource: expectedOutput,
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
}
