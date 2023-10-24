// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum OWSwiftError: Error {
    case notInitialized

    var errorDescription: String {
        switch self {
        case .notInitialized:
            return NSLocalizedString("OWSwiftError.notInitialized", comment: "")
        }
    }
}

public struct OWSwift {
    public static var apiKey: String {
        get throws {
            guard let _apiKey, !_apiKey.isEmpty else {
                throw OWSwiftError.notInitialized
            }
            return _apiKey
        }
    }

    public static func initialize(with apiKey: String, jsonEncoder: JSONEncoder? = nil) {
        Self._apiKey = apiKey
        if let jsonEncoder {
            Self.jsonEncoder = jsonEncoder
        } else {
            Self.jsonEncoder = .initialize()
        }
    }

    static let sessionConfiguration = URLSessionConfiguration.default

    static private(set) var jsonEncoder: JSONEncoder = .initialize()

    static func deIitialize() {
        Self._apiKey = nil
    }

    static private var _apiKey: String?
}
