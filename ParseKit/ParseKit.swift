//
//  ParseKit.swift
//  ParseKit
//
//  Copyright (c) 2017 Daniel Byon
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

private let _dateFormatter = DateFormatter()
private let _8601DateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

// MARK: - NSDictionary Extension
public extension NSDictionary {

    // MARK: General Parse Functions

    public func parse<T>(_ keyPath: String) throws -> T {
        guard let value = value(forKeyPath: keyPath) else {
            throw ParseError.keyPathNotFound(keyPath)
        }
        guard let typedValue = value as? T else {
            throw ParseError.valueNotExpectedType(keyPath: keyPath, expected: T.self, actual: type(of: value), value: value)
        }
        return typedValue
    }

    public func parse<T: Parsable>(_ keyPath: String) throws -> T {
        return try parseParsable(keyPath)
    }

    public func parse<T: Parsable>(_ keyPath: String) throws -> [T] {
        return try parseParsableList(keyPath)
    }

    public func parse<T: RawRepresentable>(_ keyPath: String) throws -> T {
        return try parseEnum(keyPath)
    }

    public func parse(_ keyPath: String, dateFormatter: DateFormatter? = nil) throws -> Date {
        return try parseDate(keyPath, dateFormatter: dateFormatter)
    }

    public func parse<T>(_ keyPath: String, parser: (Any) throws -> T) throws -> T {
        let value: Any = try parse(keyPath)
        return try parser(value)
    }

    public func parseOptional<T>(_ keyPath: String) throws -> T? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: T = try parse(keyPath)
        return parsed
    }

    public func parseOptional<T: Parsable>(_ keyPath: String) throws -> T? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: T = try parseParsable(keyPath)
        return parsed
    }

    public func parseOptional<T: Parsable>(_ keyPath: String) throws -> [T]? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: [T] = try parseParsableList(keyPath)
        return parsed
    }

    public func parseOptional<T: RawRepresentable>(_ keyPath: String) throws -> T? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: T = try parseEnum(keyPath)
        return parsed
    }

    public func parseOptional(_ keyPath: String, dateFormatter: DateFormatter? = nil) throws -> Date? {
        return try parseOptionalDate(keyPath, dateFormatter: dateFormatter)
    }

    public func parseOptional<T>(_ keyPath: String, parser: (Any) throws -> T) throws -> T? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        return try parser(value)
    }

    // MARK: Type-Specific Parse Functions

    public func parseInt(_ keyPath: String) throws -> Int {
        do {
            let parsed: Int = try parse(keyPath)
            return parsed
        } catch {
            // This allows some flexibility in case the value is returned as a String
            let string: String = try parse(keyPath)
            guard let parsed = Int(string) else {
                throw ParseError.valueNotExpectedType(keyPath: keyPath, expected: Int.self, actual: String.self, value: string)
            }
            return parsed
        }
    }

    public func parseString(_ keyPath: String) throws -> String {
        let parsed: String = try parse(keyPath)
        return parsed
    }

    public func parseDouble(_ keyPath: String) throws -> Double {
        do {
            let parsed: Double = try parse(keyPath)
            return parsed
        } catch {
            // This allows some flexibility in case the value is returned as a String
            let string: String = try parse(keyPath)
            guard let parsed = Double(string) else {
                throw ParseError.valueNotExpectedType(keyPath: keyPath, expected: Double.self, actual: String.self, value: string)
            }
            return parsed
        }
    }

    public func parseBool(_ keyPath: String) throws -> Bool {
        do {
            let parsed: Bool = try parse(keyPath)
            return parsed
        } catch {
            // This allows some flexibility in case the value is returned as a String
            let string: String = try parse(keyPath)
            guard let parsed = Bool(fuzzyString: string) else {
                throw ParseError.valueNotExpectedType(keyPath: keyPath, expected: Bool.self, actual: String.self, value: string)
            }
            return parsed
        }
    }

    public func parseDate(_ keyPath: String, dateFormatter: DateFormatter? = nil) throws -> Date {
        let dateString = try parseString(keyPath)
        if let dateFormatter = dateFormatter {
            guard let parsed = dateFormatter.date(from: dateString) else {
                throw ParseError.valueNotParseable(keyPath: keyPath, type: Date.self)
            }
            return parsed
        } else {
            _dateFormatter.dateFormat = _8601DateFormat
            guard let parsed = _dateFormatter.date(from: dateString) else {
                throw ParseError.valueNotParseable(keyPath: keyPath, type: Date.self)
            }
            return parsed
        }
    }

    public func parseEnum<T: RawRepresentable>(_ keyPath: String) throws -> T {
        let rawValue: T.RawValue = try parse(keyPath)
        guard let parsed = T(rawValue: rawValue) else {
            throw ParseError.valueNotExpectedType(keyPath: keyPath, expected: URL.self, actual: String.self, value: rawValue)
        }
        return parsed
    }

    public func parseURL(_ keyPath: String) throws -> URL {
        let string = try parseString(keyPath)
        guard let parsed = URL(string: string) else {
            throw ParseError.valueNotParseable(keyPath: keyPath, type: URL.self)
        }
        return parsed
    }

    public func parseParsable<T: Parsable>(_ keyPath: String) throws -> T {
        let dict: NSDictionary = try parse(keyPath)
        let parsed = try T(json: dict)
        return parsed
    }

    public func parseParsableList<T: Parsable>(_ keyPath: String) throws -> [T] {
        let dicts: [NSDictionary] = try parse(keyPath)
        return try dicts.map { try T(json: $0) }
    }

    public func parseOptionalInt(_ keyPath: String) throws -> Int? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed = try parseInt(keyPath)
        return parsed
    }

    public func parseOptionalString(_ keyPath: String) throws -> String? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed = try parseString(keyPath)
        return parsed
    }

    public func parseOptionalDouble(_ keyPath: String) throws -> Double? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed = try parseDouble(keyPath)
        return parsed
    }

    public func parseOptionalBool(_ keyPath: String) throws -> Bool? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed = try parseBool(keyPath)
        return parsed
    }

    public func parseOptionalDate(_ keyPath: String, dateFormatter: DateFormatter? = nil) throws -> Date? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed = try parseDate(keyPath, dateFormatter: dateFormatter)
        return parsed
    }

    public func parseOptionalEnum<T: RawRepresentable>(_ keyPath: String) throws -> T? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: T = try parseEnum(keyPath)
        return parsed
    }

    public func parseOptionalURL(_ keyPath: String) throws -> URL? {
        guard let string = try parseOptionalString(keyPath) else { return nil }
        guard let parsed = URL(string: string) else {
            throw ParseError.valueNotParseable(keyPath: keyPath, type: URL.self)
        }
        return parsed
    }

    public func parseOptionalParsable<T: Parsable>(_ keyPath: String) throws -> T? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: T = try parseParsable(keyPath)
        return parsed
    }

    public func parseOptionalParsableList<T: Parsable>(_ keyPath: String) throws -> [T]? {
        guard let value = value(forKeyPath: keyPath), !(value is NSNull) else { return nil }
        let parsed: [T] = try parseParsableList(keyPath)
        return parsed
    }

}

// MARK: - Parsable
public protocol Parsable {

    init(json: NSDictionary) throws

}

// MARK: - ParseError
public enum ParseError: Error {
    case keyPathNotFound(String)
    case valueNotExpectedType(keyPath: String, expected: Any, actual: Any, value: Any)
    case valueNotParseable(keyPath: String, type: Any)
}

extension ParseError: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        switch self {
        case .keyPathNotFound(let keyPath):
            return "Key path not found: \(keyPath)"
        case .valueNotExpectedType(let keyPath, let expected, let actual, let value):
            return "Key path '\(keyPath)', expected type \(expected), actual type \(actual), value \(value)"
        case .valueNotParseable(let keyPath, let type):
            return "Key path '\(keyPath)' not parseable to type \(type)"
        }
    }

    public var debugDescription: String {
        return description
    }

}

private extension Bool {

    init?(fuzzyString: String) {
        switch fuzzyString.lowercased() {
        case "true", "yes", "1", "y":
            self = true
        case "false", "no", "0", "n":
            self = false
        default:
            return nil
        }
    }
    
}
