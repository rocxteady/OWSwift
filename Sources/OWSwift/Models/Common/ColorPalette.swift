//
//  ColorPalette.swift
//
//
//  Created by Ulaş Sancak on 20.10.2023.
//

import Foundation

public struct ColorPalette {
    public let value: String
    public let hex: String
    let asParameter: String

    init(value: String, hex: String) {
        self.value = value
        self.hex = hex
        self.asParameter = "\(value):\(hex)"
    }
}

extension [ColorPalette] {
    var asParameter: String {
        map {
            $0.asParameter
        }
        .joined(separator: ";")
    }
}
