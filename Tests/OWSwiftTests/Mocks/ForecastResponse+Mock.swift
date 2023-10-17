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
    static var mock: ForecastResponse {
        .init(
            cnt: 40,
            list: [
                Forecast(
                    dt: 1661871600,
                    mainWeatherInfo: MainWeatherInfo(
                        temp: 296.76,
                        feelsLike: 296.98,
                        tempMin: 296.76,
                        tempMax: 297.87,
                        pressure: 1015,
                        humidity: 69,
                        seaLevel: 1015,
                        grndLevel: 933,
                        tempKf: -1.11
                    ),
                    conditions: [
                        WeatherCondition(
                            id: 500,
                            main: "Rain",
                            description: "light rain",
                            icon: "10d"
                        )
                    ],
                    clouds: Clouds(all: 100),
                    wind: Wind(
                        speed: 0.62,
                        deg: 349,
                        gust: 1.18
                    ),
                    visibility: 10000,
                    pop: 0.32,
                    rain: VolumeLast(the1H: 0.1, the3H: 0.26),
                    snow: VolumeLast(the1H: 0.2, the3H: 0.3),
                    sys: Forecast.Sys(pod: .day),
                    dtTxt: "2022-08-30 15:00:00"
                )
            ],
            city: City(
                id: 3163858,
                name: "Zocca",
                coord: Coord(lon: 10.99, lat: 44.34),
                country: "IT",
                population: 4593,
                timezone: 7200,
                sunrise: 1661834187,
                sunset: 1661882248
            ),
            cod: "200",
            message: 0
        )
    }
}
