//
//  EasyDefaultsTests.swift
//  EasyDefaultsTests
//
//  Created by Júlio Andherson de Oliveira Silva on 10/06/25.
//

import XCTest
@testable import EasyDefaults

final class EasyDefaultsTests: XCTestCase {
    @EasyDefaults
    var easyDefaults: EasyDefaultsWrapper

    var userObject: User!

    override func setUpWithError() throws {
        // Limpa UserDefaults antes de cada teste para evitar interferência
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        userObject = User(
            name: "Julio",
            lastName: "Silva",
            age: 35,
            address: Address(
                street: "Street Name",
                number: 100,
                city: "Recife"
            )
        )
    }

    // MARK: - Primitive Types

    func testSaveAndGetString() throws {
        let value = "test"
        try easyDefaults.save(key: "stringKey", value)
        let retrieved: String = try easyDefaults.get(key: "stringKey") ?? ""
        XCTAssertEqual(value, retrieved)
    }

    func testSaveAndGetInt() throws {
        let value = 9217489214
        try easyDefaults.save(key: "intKey", value)
        let retrieved: Int = try easyDefaults.get(key: "intKey") ?? 0
        XCTAssertEqual(value, retrieved)
    }

    func testSaveAndGetDouble() throws {
        let value = 3.14159265358979323846
        try easyDefaults.save(key: "doubleKey", value)
        let retrieved: Double = try easyDefaults.get(key: "doubleKey") ?? 0.0
        XCTAssertEqual(value, retrieved)
    }

    func testSaveAndGetBool() throws {
        let value = true
        try easyDefaults.save(key: "boolKey", value)
        let retrieved: Bool = try easyDefaults.get(key: "boolKey") ?? false
        XCTAssertEqual(value, retrieved)
    }

    func testSaveAndGetData() throws {
        let value = Data([1, 2, 3])
        try easyDefaults.save(key: "dataKey", value)
        let retrieved: Data = try easyDefaults.get(key: "dataKey") ?? Data()
        XCTAssertEqual(value, retrieved)
    }

    // MARK: - Objects

    func testSaveAndGetCodableObject() throws {
        try easyDefaults.save(key: "userKey", userObject!)
        let retrieved: User? = try easyDefaults.get(key: "userKey")
        XCTAssertEqual(userObject, retrieved)
    }

    func testGetObjectWithNotFoundKeyReturnsNil() throws {
        let retrieved: User? = try easyDefaults.get(key: "notSavedKey")
        XCTAssertNil(retrieved)
    }

    func testSaveThrowsForNonCodableObject() {
        let dog = Dog(name: "Memphis", age: 9)
        XCTAssertThrowsError(try easyDefaults.save(key: "invalidDogKey", dog)) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "EasyDefaults")
            XCTAssertEqual(nsError.code, 1)
        }
    }

    // MARK: - Performance

    func testPerformanceExample() throws {
        self.measure {
            for i in 0..<1000 {
                try? easyDefaults.save(key: "perfKey\(i)", i)
                _ = try? easyDefaults.get(key: "perfKey\(i)") as Int?
            }
        }
    }
}

// MARK: - Test Helper Types

struct User: Codable, Equatable {
    let name: String
    let lastName: String
    let age: Int
    let address: Address

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name &&
        lhs.lastName == rhs.lastName &&
        lhs.age == rhs.age &&
        lhs.address == rhs.address
    }
}

struct Address: Codable, Equatable {
    let street: String
    let number: Int
    let city: String
}

struct Dog {
    let name: String
    let age: Int
}
