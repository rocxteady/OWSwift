//
//  CurrentWeather.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

public struct CurrentWeather: Decodable {
    public struct Sys: Decodable {
        public let country: String?
        public let sunrise, sunset: Int

        let type, id: Int?
        let message: String?
    }
    
    public let coord: Coord
    public let conditions: [WeatherCondition]
    public let mainWeatherInfo: MainWeatherInfo
    public let visibility: Int
    public let wind: Wind
    public let rain: VolumeLast?
    public let snow: VolumeLast?
    public let clouds: Clouds
    public let dt: Date
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
