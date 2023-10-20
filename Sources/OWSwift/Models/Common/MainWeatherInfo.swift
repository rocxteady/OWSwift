//
//  MainWeatherInfo.swift
//  
//
//  Created by Ulaş Sancak on 16.10.2023.
//

import Foundation

public struct MainWeatherInfo: Decodable {
    public let temp, feelsLike, tempMin, tempMax: Double
    public let pressure, humidity: Int
    public let seaLevel, grndLevel: Int?

    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}
