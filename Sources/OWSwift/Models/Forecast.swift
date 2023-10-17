//
//  Forecast.swift
//
//
//  Created by Ulaş Sancak on 16.10.2023.
//

import Foundation

public struct ForecastResponse: Decodable {
    public let cnt: Int
    public let list: [Forecast]
    public let city: City

    let cod: String
    let message: Int
}

public struct Forecast: Decodable {
    public struct Sys: Decodable {
        let pod: PartOfDay
    }

    public let dt: Int
    public let date: Date
    public let mainWeatherInfo: MainWeatherInfo
    public let conditions: [WeatherCondition]
    public let clouds: Clouds
    public let wind: Wind
    public let visibility: Int
    public let pop: Double
    public let rain: VolumeLast?
    public let snow: VolumeLast?
    public let sys: Sys
    public let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt
        case mainWeatherInfo = "main"
        case conditions = "weather"
        case clouds, wind, visibility, pop, rain, snow, sys
        case dtTxt = "dt_txt"
    }

    public init(dt: Int, mainWeatherInfo: MainWeatherInfo, conditions: [WeatherCondition], clouds: Clouds, wind: Wind, visibility: Int, pop: Double, rain: VolumeLast? = nil, snow: VolumeLast? = nil, sys: Forecast.Sys, dtTxt: String) {
        self.dt = dt
        self.mainWeatherInfo = mainWeatherInfo
        self.conditions = conditions
        self.clouds = clouds
        self.wind = wind
        self.visibility = visibility
        self.pop = pop
        self.rain = rain
        self.snow = snow
        self.sys = sys
        self.dtTxt = dtTxt

        self.date = dt.date
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dt = try container.decode(Int.self, forKey: .dt)
        mainWeatherInfo = try container.decode(MainWeatherInfo.self, forKey: .mainWeatherInfo)
        conditions = try container.decode([WeatherCondition].self, forKey: .conditions)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        wind = try container.decode(Wind.self, forKey: .wind)
        visibility = try container.decode(Int.self, forKey: .visibility)
        pop = try container.decode(Double.self, forKey: .pop)
        rain = try container.decodeIfPresent(VolumeLast.self, forKey: .rain)
        snow = try container.decodeIfPresent(VolumeLast.self, forKey: .snow)
        sys = try container.decode(Sys.self, forKey: .sys)
        dtTxt = try container.decode(String.self, forKey: .dtTxt)

        date = dt.date
    }
}
