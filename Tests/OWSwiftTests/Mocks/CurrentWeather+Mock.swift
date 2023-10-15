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
    static var mock: CurrentWeather {
        .init(
            coord: Coord(lon: 29, lat: 41),
            conditions: [
                WeatherCondition(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            ],
            mainWeatherInfo: MainWeatherInfo(temp: 21.19, feelsLike: 21.27, tempMin: 21.19, tempMax: 22.61, pressure: 1010, humidity: 73, seaLevel: 1010, grndLevel: 1009),
            visibility: 10000,
            wind: Wind(speed: 4.12, deg: 240, gust: 6.26),
            rain: VolumeLast(the1H: 0.1, the3H: 0.1),
            snow: VolumeLast(the1H: 0.1, the3H: 0.1),
            clouds: Clouds(all: 0),
            dt: 1697374381,
            sys: Sys(country: "TR", sunrise: 1697343277, sunset: 1697383489, type: 1, id: 6970, message: "Message"),
            timezone: 10800,
            cityId: 738329,
            cityName: "Uskudar",
            base: "stations",
            cod: 200
        )
    }
}
