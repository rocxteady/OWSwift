//
//  RestClient+Configuration.swift
//
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import Foundation
import Resting

extension RestClient {
    static func initialize() -> RestClient {
        .init(configuration: .init(sessionConfiguration: OWSwift.sessionConfiguration, jsonDecoder: .initialize()))
    }
}

