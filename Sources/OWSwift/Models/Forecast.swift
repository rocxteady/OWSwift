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

    public let dt: Date
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
}
