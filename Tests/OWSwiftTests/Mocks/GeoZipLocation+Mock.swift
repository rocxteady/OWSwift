//
//  GeoLocation+Mock.swift
//
//
//  Created by Ulaş Sancak on 25.10.2023.
//

import Foundation
@testable import OWSwift

extension [GeoLocation] {
    static var mockData: Data {
        get throws {
            guard let url = Bundle.module.url(forResource: "Locations", withExtension: "json") else {
                throw MockError.fileNotFound("Locations.json")
            }
            let data = try Data(contentsOf: url)
            return data
        }
    }
}
