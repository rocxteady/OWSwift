//
//  ForecastRepo.swift
//
//
//  Created by Ulaş Sancak on 17.10.2023.
//

import Foundation
import Resting
import Combine

public struct ForecastRepo {
    public static func get5DayForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) async throws -> ForecastResponse {
        try await getForecast(endpoint: .forecast, lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
    }

    public static func get5DayForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<ForecastResponse, Error> {
        return getForecast(endpoint: .forecast, lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
    }

    public static func getDailyForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) async throws -> ForecastResponse {
        try await getForecast(endpoint: .dailyForecast, lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
    }

    public static func getDailyForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<ForecastResponse, Error> {
        return getForecast(endpoint: .dailyForecast, lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
    }

    public static func getHourlyForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) async throws -> ForecastResponse {
        try await getForecast(endpoint: .hourlyForecast, lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
    }

    public static func getHourlyForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<ForecastResponse, Error> {
        return getForecast(endpoint: .hourlyForecast, lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
    }
}

extension ForecastRepo {
    private static func createParameters(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> [String: Any?] {
        return ["lat": lat, "lon": lon, "cnt": cnt, "units": units, "lang": locale.lang?.rawValue]
    }

    private static func getForecast(endpoint: Endpoint, lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) async throws -> ForecastResponse {
        let restClient = RestClient.initialize()
        let parameters = try createParameters(lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
            .compactMapValues { $0 }
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: endpoint.fullURL, parameters: parameters))
    }

    private static func getForecast(endpoint: Endpoint, lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<ForecastResponse, Error> {
        return createParameters(lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
            .compactMapValues { $0 }
            .createParametersWithPublisher()
            .map { parameters -> AnyPublisher<ForecastResponse, Error> in
                let restClient = RestClient.initialize()
                return restClient.publisher(with: .init(urlString: endpoint.fullURL, parameters: parameters))
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
