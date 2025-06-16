# EasyDefaults

[![iOS 15.6+](https://img.shields.io/badge/iOS-15.6%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg)](https://swift.org)
[![Tests Passing](https://img.shields.io/badge/tests-passing-brightgreen.svg)](#)

EasyDefaults is a lightweight Swift library that simplifies access to `UserDefaults` using a property wrapper and type inference for common types and `Codable` objects.

## Features

- Property wrapper for easy access to UserDefaults
- Type inference for String, Int, Double, Bool, Data
- Support for custom `Codable` objects
- Throws errors for unsupported types

## Installation

### CocoaPods

Add the following line to your `Podfile`:

```
pod 'EasyDefaults', :git => 'https://github.com/julioandherson/EasyDefaults.git', :tag => '1.0.0'
```

Then run:

```sh
pod install
```

## Usage

### 1. Import EasyDefaults

```swift
import EasyDefaults
```

### 2. Add the Property Wrapper

```swift
@EasyDefaultsProperty
var easyDefaults: EasyDefaultsWrapper
```

### 3. Save and Retrieve Values

#### Primitive Types

```swift
try? easyDefaults.save(key: "myStringKey", "Hello, world!")
let value: String = (try? easyDefaults.get(key: "myStringKey")) ?? ""
```

#### Codable Objects

```swift
struct User: Codable {
    let name: String
    let age: Int
}

let user = User(name: "Alice", age: 30)
try? easyDefaults.save(key: "userKey", user)
let loadedUser: User? = try? easyDefaults.get(key: "userKey")
```

## Supported Types

- String
- Int
- Double
- Bool
- Data
- Any object conforming to `Codable`

## Error Handling

If you try to save a type that is not supported or not `Encodable`, an error is thrown.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
