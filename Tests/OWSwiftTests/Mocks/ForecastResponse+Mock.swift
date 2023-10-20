//
//  ForecastResponse+Mock.swift
//
//
//  Created by Ulaş Sancak on 17.10.2023.
//

import Foundation
@testable import OWSwift

extension ForecastResponse {
    static var mockData: Data {
        get throws {
            guard let url = Bundle.module.url(forResource: "ForecastResponse", withExtension: "json") else {
                throw MockError.fileNotFound("ForecastResponse.json")
            }
            let data = try Data(contentsOf: url)
            return data
        }
    }
}
