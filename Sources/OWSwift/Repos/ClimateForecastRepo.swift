//
//  ForecastRepo.swift
//
//
//  Created by Ulaş Sancak on 19.10.2023.
//

import Foundation
import Resting
import Combine

public struct ClimateForecastRepo {
    public static func getClimateForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) async throws -> ForecastResponse {
        let restClient = RestClient.initialize()
        let parameters = try createParameters(lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: ProEndpoint.climateForecast.fullURL, parameters: parameters))
    }

    public static func getClimateForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<ForecastResponse, Error> {
        return createParameters(lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
            .createParameters_publisher()
            .flatMap { parameters in
                let restClient = RestClient.initialize()
                let publisher: AnyPublisher<ForecastResponse, Error> = restClient.publisher(with: .init(urlString: ProEndpoint.climateForecast.fullURL, parameters: parameters))
                return publisher.map { $0 }
            }.eraseToAnyPublisher()
    }
}

extension ClimateForecastRepo {
    private static func createParameters(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> OptinalParameters {
        ["lat": lat, "lon": lon, "cnt": cnt, "units": units, "lang": locale.lang?.rawValue]
    }
}
