//
//  JSONEncoder+Init.swift
//
//
//  Created by Ulaş Sancak on 22.10.2023.
//

import Foundation

extension JSONEncoder {
    static func initialize() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            let roundedInteger = Int(date.timeIntervalSince1970.rounded())
            var container = encoder.singleValueContainer()
            try container.encode(roundedInteger)
        })
        return encoder
    }
}

extension JSONDecoder {
    static func initialize() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let integerValue = try container.decode(Int.self)
            return Date(timeIntervalSince1970: TimeInterval(integerValue))
        })
        return decoder
    }
}
