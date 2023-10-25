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
    case roadRisk = "/roadrisk"

    var fullURL: String {
        return Constants.API.fullBaseAPIURL + rawValue
    }
}

enum ProEndpoint: String {
    case climateForecast = "/forecast/climate"

    var fullURL: String {
        return Constants.API.proBaseAPIURL + rawValue
    }
}

enum GeocodingEndpoint: String {
    case direct = "/direct"
    case zip = "/zip"
    case reverse = "/reverse"

    var fullURL: String {
        return Constants.API.Geocoding.fullBaseAPIURL + rawValue
    }
}
