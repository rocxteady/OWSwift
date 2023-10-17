//
//  Endpoint.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

enum Endpoint: String {
    case currentWeather = "/weather"
    case forecast = "/forecast"
    case dailyForecast = "/forecast/daily"
    case hourlyForecast = "/forecast/hourly"

    var fullURL: String {
        return Constants.API.fullBaseAPIURL + rawValue
    }
}
