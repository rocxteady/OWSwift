//
//  CurrentWeather+Mock.swift
//  
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import Foundation
@testable import OWSwift

extension CurrentWeather {
    static var mockData: Data {
        get throws {
            guard let url = Bundle.module.url(forResource: "CurrentWeather", withExtension: "json") else {
                throw MockError.fileNotFound("CurrentWeather.json")
            }
            let data = try Data(contentsOf: url)
            return data
        }
    }
}
