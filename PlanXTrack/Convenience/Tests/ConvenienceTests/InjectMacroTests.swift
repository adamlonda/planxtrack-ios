//
//  InjectMacroTests.swift
//  Convenience
//
//  Created by Adam Londa on 08.12.2024.
//

@testable import Convenience
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectMacroTests: XCTestCase {
    func testInjectMacroWithValidVariable() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            struct MyStruct {
                @Inject var myService: MyService
            }
            """,
            expandedSource: """
            struct MyStruct {
                var myService: MyService {
                    get async {
                        await dependencies.resolve(MyService.self)
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithComputedProperty() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            struct MyStruct {
                @Inject var myService: MyService {
                    return MyService()
                }
            }
            """,
            expandedSource: """
            struct MyStruct {
                var myService: MyService {
                    return MyService()
                }
            }
            """,
            diagnostics: [
                .init(message: "Inject macro can't be applied to computed properties", line: 2, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithInitializedProperty() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            struct MyStruct {
                @Inject var myService: MyService = MyService()
            }
            """,
            expandedSource: """
            struct MyStruct {
                var myService: MyService = MyService()
            }
            """,
            diagnostics: [
                .init(message: "Inject macro can't be applied to initialized properties", line: 2, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithLet() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            struct MyStruct {
                @Inject let myService: MyService
            }
            """,
            expandedSource: """
            struct MyStruct {
                let myService: MyService
            }
            """,
            diagnostics: [
                .init(message: "Inject macro can only be applied to var declarations", line: 2, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithStructDeclaration() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            @Inject struct MyStruct {}
            """,
            expandedSource: """
            struct MyStruct {}
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithClassDeclaration() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            @Inject class MyClass {}
            """,
            expandedSource: """
            class MyClass {}
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithFunctionDeclaration() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            struct MyStruct {
                @Inject func doSomething() {}
            }
            """,
            expandedSource: """
            struct MyStruct {
                func doSomething() {}
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInjectMacroWithProtocolDeclaration() throws {
        #if canImport(ConvenienceMacros)
        assertMacroExpansion(
            """
            @Inject protocol MyProtocol {}
            """,
            expandedSource: """
            protocol MyProtocol {}
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
