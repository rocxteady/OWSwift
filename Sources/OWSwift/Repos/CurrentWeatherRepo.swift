//
//  OWCurrentWeather.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation
import Resting
import Combine

public struct CurrentWeatherRepo {
    public static func getCurrentWeather(lat: Double, lon: Double, units: Units? = nil, locale: Locale = .current) async throws -> CurrentWeather {
        try Validators.validateLatLon(lat: lat, lon: lon)
        let restClient = RestClient.initialize()
        let parameters = try createParameters(lat: lat, lon: lon, units: units, locale: locale)
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: Endpoint.currentWeather.fullURL, parameters: parameters))
    }

    public static func getCurrentWeather(lat: Double, lon: Double, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<CurrentWeather, Error> {
        return Validators.validateLatLon_publisher(lat: lat, lon: lon)
            .tryMap {
                return try createParameters(lat: lat, lon: lon, units: units, locale: locale)
                    .createParameters()
            }
            .flatMap { (parameters: Parameters) in
                let restClient = RestClient.initialize()
                let publisher: AnyPublisher<CurrentWeather, Error> = restClient.publisher(with: .init(urlString: Endpoint.currentWeather.fullURL, parameters: parameters))
                return publisher.map { $0 }
            }
            .eraseToAnyPublisher()
    }
}

extension CurrentWeatherRepo {
    private static func createParameters(lat: Double, lon: Double, units: Units? = nil, locale: Locale = .current) -> OptinalParameters {
        ["lat": lat, "lon": lon, "units": units, "lang": locale.lang?.rawValue]
    }
}
