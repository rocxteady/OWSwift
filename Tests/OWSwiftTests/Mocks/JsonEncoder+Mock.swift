//
//  JsonEncoder+Mock.swift
//
//
//  Created by Ulaş Sancak on 22.10.2023.
//

import Foundation

class FailingEncoder: JSONEncoder {
    override func encode<T>(_ value: T) throws -> Data where T : Encodable {
        throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "This encoder always fails"))
    }
}
