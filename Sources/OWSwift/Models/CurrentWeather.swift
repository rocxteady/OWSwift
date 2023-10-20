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
    public let dt: Int
    public let date: Date
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        coord = try container.decode(Coord.self, forKey: .coord)
        conditions = try container.decode([WeatherCondition].self, forKey: .conditions)
        mainWeatherInfo = try container.decode(MainWeatherInfo.self, forKey: .mainWeatherInfo)
        visibility = try container.decode(Int.self, forKey: .visibility)
        wind = try container.decode(Wind.self, forKey: .wind)
        rain = try container.decodeIfPresent(VolumeLast.self, forKey: .rain)
        snow = try container.decodeIfPresent(VolumeLast.self, forKey: .snow)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        dt = try container.decode(Int.self, forKey: .dt)
        sys = try container.decode(Sys.self, forKey: .sys)
        timezone = try container.decode(Int.self, forKey: .timezone)
        cityId = try container.decode(Int.self, forKey: .cityId)
        cityName = try container.decode(String.self, forKey: .cityName)
        base = try container.decode(String.self, forKey: .base)
        cod = try container.decode(Int.self, forKey: .cod)

        self.date = dt.date
    }
}
