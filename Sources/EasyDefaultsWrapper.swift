//
//  EasyDefaults.swift
//  EasyDefaults
//
//  Created by Júlio Andherson de Oliveira Silva on 10/06/25.
//

import Foundation

/**
 # EasyDefaults

 A property wrapper and helper class for simplified access to UserDefaults, supporting type inference for common types and Codable objects.

 ## Overview

 - `EasyDefaultsProperty` is a property wrapper that provides an instance of `EasyDefaultsWrapper`.
 - `EasyDefaultsWrapper` handles saving and retrieving values from `UserDefaults` with type inference for native types and support for custom `Codable` objects.
 - `AnyEncodable` is a type-erased wrapper to allow encoding of values of unknown concrete type.

 ## Usage

 Decorate a property with `@EasyDefaultsProperty` to access an instance of `EasyDefaultsWrapper`:

     @EasyDefaultsProperty
     var easyDefaults: EasyDefaultsWrapper

 Save and retrieve values without specifying the type explicitly:

     try? easyDefaults.save(key: "myStringKey", "Hello")
     let value: String = (try? easyDefaults.get(key: "myStringKey")) ?? ""

 You can also save and retrieve custom Codable objects:

     struct User: Codable { ... }
     let user = User(...)
     try? easyDefaults.save(key: "userKey", user)
     let loadedUser: User? = try? easyDefaults.get(key: "userKey")

 ## Supported Types

 - String
 - Int
 - Double
 - Bool
 - Data
 - Any object conforming to `Codable`

 ## Error Handling

 If you try to save a type that is not supported or not `Encodable`, an error is thrown.

 ## Implementation Details

 - The `save` method uses type inference to store supported types directly, or encodes `Codable` objects as JSON.
 - The `get` method infers the type from the generic parameter and decodes data for custom types.

 ## Example

     @EasyDefaultsProperty
     var easyDefaults: EasyDefaultsWrapper

     struct User: Codable {
         let name: String
     }

     let user = User(name: "Alice")
     try? easyDefaults.save(key: "userKey", user)
     let loadedUser: User? = try? easyDefaults.get(key: "userKey")

 */

/// Property wrapper that provides an instance of EasyDefaultsWrapper for UserDefaults access.
@propertyWrapper
public struct EasyDefaultsProperty {
    /// Returns an instance of EasyDefaultsWrapper.
    public var wrappedValue: EasyDefaultsWrapper {
        EasyDefaultsWrapper()
    }
    /// Initializes the property wrapper.
    public init() {}
}

/**
 A helper class for saving and retrieving values from UserDefaults with type inference and Codable support.
 */
public class EasyDefaultsWrapper {
    private let defaults = UserDefaults.standard

    /// Initializes the wrapper.
    public init() {}

    /**
     Saves a value to UserDefaults for the given key.

     - Parameters:
        - key: The key to associate with the value.
        - value: The value to save. Supported types: String, Int, Double, Bool, Data, or any Encodable object.
     - Throws: An error if the value is not supported or encoding fails.
     */
    public func save(key: String, _ value: Any) throws {
        switch value {
        case let v as String:
            defaults.set(v, forKey: key)
        case let v as Int:
            defaults.set(v, forKey: key)
        case let v as Double:
            defaults.set(v, forKey: key)
        case let v as Bool:
            defaults.set(v, forKey: key)
        case let v as Data:
            defaults.set(v, forKey: key)
        default:
            let encoder = JSONEncoder()
            guard let codableValue = value as? Encodable else {
                throw NSError(domain: "EasyDefaults", code: 1, userInfo: [NSLocalizedDescriptionKey: "Type not supported"])
            }
            let data = try encoder.encode(AnyEncodable(codableValue))
            defaults.set(data, forKey: key)
        }
    }

    /**
     Retrieves a value from UserDefaults for the given key.

     - Parameter key: The key associated with the value.
     - Returns: The value of type `T` if found, or `nil` if not found or decoding fails.
     - Throws: An error if decoding fails.
     */
    public func get<T: Decodable>(key: String) throws -> T? {
        if T.self == String.self {
            return defaults.string(forKey: key) as? T
        } else if T.self == Int.self {
            return defaults.integer(forKey: key) as? T
        } else if T.self == Double.self {
            return defaults.double(forKey: key) as? T
        } else if T.self == Bool.self {
            return defaults.bool(forKey: key) as? T
        } else if T.self == Data.self {
            return defaults.data(forKey: key) as? T
        } else {
            guard let data = defaults.data(forKey: key) else { return nil }
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
    }
}

/**
 A type-erased Encodable wrapper to allow encoding of values of unknown concrete type.
 */
public struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    /// Initializes with any Encodable value.
    public init(_ encodable: Encodable) {
        self.encodeFunc = encodable.encode
    }

    public func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
