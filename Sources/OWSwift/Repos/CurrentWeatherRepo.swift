//
//  OWCurrentWeather.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation
import Resting
import Combine

struct CurrentWeatherRepo {
    private static func createParameters(lat: Double, lon: Double, units: Units? = nil, locale: Locale = .current) -> [String: Any?] {
        return ["lat": lat, "lon": lon, "units": units, "lang": locale.lang?.rawValue]
    }

    static func getCurrentWeather(lat: Double, lon: Double, units: Units? = nil, locale: Locale = .current) async throws -> CurrentWeather {
        let restClient = RestClient.initialize()
        let parameters = try createParameters(lat: lat, lon: lon, units: units, locale: locale)
            .compactMapValues { $0 }
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: Endpoint.currentWeather.fullURL, parameters: parameters))
    }

    static func getCurrentWeather(lat: Double, lon: Double, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<CurrentWeather, Error> {
        return createParameters(lat: lat, lon: lon, units: units, locale: locale)
            .compactMapValues { $0 }
            .createParametersWithPublisher()
            .map { parameters -> AnyPublisher<CurrentWeather, Error> in
                let restClient = RestClient.initialize()
                return restClient.publisher(with: .init(urlString: Endpoint.currentWeather.fullURL, parameters: parameters))
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
