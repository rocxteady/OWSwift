//
//  CurrentWeather.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

public struct CurrentWeather: Decodable {
    public let coord: Coord
    public let conditions: [WeatherCondition]
    public let mainWeatherInfo: MainWeatherInfo
    public let visibility: Int
    public let wind: Wind
    public let rain: VolumeLast?
    public let snow: VolumeLast?
    public let clouds: Clouds
    public let dt: Int
    public let sys: Sys
    public let timezone, cityId: Int
    public let cityName: String

    let base: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case coord
        case conditions = "weather"
        case mainWeatherInfo = "main"
        case visibility, wind, rain, snow, clouds
        case dt, sys, timezone
        case cityId = "id"
        case cityName = "name"
        case base, cod
    }
}

public struct Clouds: Codable {
    public let all: Int
}

public struct Coord: Codable {
    public let lon, lat: Double
}

public struct MainWeatherInfo: Codable {
    public let temp, feelsLike, tempMin, tempMax: Double
    public let pressure, humidity: Int
    public let seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

public struct VolumeLast: Codable {
    public let the1H: Double?
    public let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

public struct Sys: Codable {
    public let country: String?
    public let sunrise, sunset: Int

    let type, id: Int?
    let message: String?
}

public struct WeatherCondition: Codable {
    public let id: Int
    public let main, description, icon: String
    public var iconURL: String {
        WeatherIconURLCreator.create(with: icon)
    }
}

public struct Wind: Codable {
    public let speed: Double
    public let deg: Int
    public let gust: Double
}
