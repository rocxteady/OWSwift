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
            .compactMapValues { $0 }
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: ProEndpoint.climateForecast.fullURL, parameters: parameters))
    }

    public static func getClimateForecast(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> AnyPublisher<ForecastResponse, Error> {
        return createParameters(lat: lat, lon: lon, cnt: cnt, units: units, locale: locale)
            .compactMapValues { $0 }
            .createParametersWithPublisher()
            .map { parameters -> AnyPublisher<ForecastResponse, Error> in
                let restClient = RestClient.initialize()
                return restClient.publisher(with: .init(urlString: ProEndpoint.climateForecast.fullURL, parameters: parameters))
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

extension ClimateForecastRepo {
    private static func createParameters(lat: Double, lon: Double, cnt: Int? = nil, units: Units? = nil, locale: Locale = .current) -> [String: Any?] {
        return ["lat": lat, "lon": lon, "cnt": cnt, "units": units, "lang": locale.lang?.rawValue]
    }
}
