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

    public static func initialize(with apiKey: String) {
        Self._apiKey = apiKey
    }

    static let sessionConfiguration = URLSessionConfiguration.default

    static func deIitialize() {
        Self._apiKey = nil
    }

    static private var _apiKey: String?
}
