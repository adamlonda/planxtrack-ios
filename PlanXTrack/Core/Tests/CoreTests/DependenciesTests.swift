//
//  DependenciesTests.swift
//  Core
//
//  Created by Adam Londa on 15.12.2024.
//

@testable import Core
import Foundation
import Testing

struct DependenciesTests {

    @Test func registeredDependencies() async {
        let dependencies = await Dependencies()
            .with(TestProtocol.self) { TestMock() }
            .withSingleton(AnotherTestProtocol.self) { AnotherTestMock() }

        let default1 = await dependencies.resolve(TestProtocol.self)
        let default2 = await dependencies.resolve(TestProtocol.self)

        let singleton1 = await dependencies.resolve(AnotherTestProtocol.self)
        let singleton2 = await dependencies.resolve(AnotherTestProtocol.self)

        #expect(default1.id != default2.id)
        #expect(singleton1.id == singleton2.id)
    }

    @Test func dependenciesOverride() async {
        let dependencies = await Dependencies()
            .withSingleton(TestProtocol.self) { TestMock() }
            .with(AnotherTestProtocol.self) { AnotherTestMock() }

        await dependencies
            .with(TestProtocol.self) { TestSpy() }
            .withSingleton(AnotherTestProtocol.self) { AnotherTestSpy() }

        let resolved = await dependencies.resolve(TestProtocol.self)
        let resolvedAnother = await dependencies.resolve(AnotherTestProtocol.self)

        #expect(resolved.id.starts(with: "SPY-") == true)
        #expect(resolvedAnother.id.starts(with: "SPY-") == true)
    }
}

// MARK: - Test Protocols

protocol TestProtocol: Sendable {
    var id: String { get }
}

final class TestMock: TestProtocol {
    let id = UUID().uuidString
}

final class TestSpy: TestProtocol {
    let id = "SPY-\(UUID().uuidString)"
}

protocol AnotherTestProtocol: Sendable {
    var id: String { get }
}

final class AnotherTestMock: AnotherTestProtocol {
    let id = UUID().uuidString
}

final class AnotherTestSpy: AnotherTestProtocol {
    let id = "SPY-\(UUID().uuidString)"
}
