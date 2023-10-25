//
//  GeocodingRepo.swift
//
//
//  Created by Ulaş Sancak on 25.10.2023.
//

import Foundation
import Resting
import Combine

public struct GeocodingRepo {
    public static func getLocations(cityName: String, state: String? = nil, country: String? = nil, limit: Int? = nil) async throws -> [GeoLocation] {
        let restClient = RestClient.initialize()
        let parameters = try createParameters(cityName: cityName, state: state, country: country, limit: limit)
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: GeocodingEndpoint.direct.fullURL, parameters: parameters))
    }

    public static func getLocations(cityName: String, state: String? = nil, country: String? = nil, limit: Int? = nil) -> AnyPublisher<[GeoLocation], Error> {
        return createParameters(cityName: cityName, state: state, country: country, limit: limit)
            .createParameters_publisher()
            .flatMap { (parameters: Parameters) in
                let restClient = RestClient.initialize()
                let publisher: AnyPublisher<[GeoLocation], Error> = restClient.publisher(with: .init(urlString: GeocodingEndpoint.direct.fullURL, parameters: parameters))
                return publisher.map { $0 }
            }
            .eraseToAnyPublisher()
    }

    public static func getLocation(zipCode: String) async throws -> GeoZipLocation {
        let restClient = RestClient.initialize()
        let parameters = try createParameters(zipCode: zipCode)
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: GeocodingEndpoint.zip.fullURL, parameters: parameters))
    }

    public static func getLocation(zipCode: String) -> AnyPublisher<GeoZipLocation, Error> {
        return createParameters(zipCode: zipCode)
            .createParameters_publisher()
            .flatMap { (parameters: Parameters) in
                let restClient = RestClient.initialize()
                let publisher: AnyPublisher<GeoZipLocation, Error> = restClient.publisher(with: .init(urlString: GeocodingEndpoint.zip.fullURL, parameters: parameters))
                return publisher.map { $0 }
            }
            .eraseToAnyPublisher()
    }

    public static func getLocations(lat: Double, lon: Double, limit: Int? = nil) async throws -> [GeoLocation] {
        try Validators.validateLatLon(lat: lat, lon: lon)
        let restClient = RestClient.initialize()
        let parameters = try createParameters(lat: lat, lon: lon, limit: limit)
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: GeocodingEndpoint.reverse.fullURL, parameters: parameters))
    }

    public static func getLocations(lat: Double, lon: Double, limit: Int? = nil) -> AnyPublisher<[GeoLocation], Error> {
        return Validators.validateLatLon_publisher(lat: lat, lon: lon)
            .tryMap {
                try createParameters(lat: lat, lon: lon, limit: limit)
                    .createParameters()
            }
            .flatMap { (parameters: Parameters) in
                let restClient = RestClient.initialize()
                let publisher: AnyPublisher<[GeoLocation], Error> = restClient.publisher(with: .init(urlString: GeocodingEndpoint.reverse.fullURL, parameters: parameters))
                return publisher.map { $0 }
            }
            .eraseToAnyPublisher()
    }
}

extension GeocodingRepo {
    private static func createParameters(cityName: String, state: String? = nil, country: String? = nil, limit: Int? = nil) -> OptinalParameters {
        let query = [cityName, state, country].compactMap { $0 }.joined(separator: ",")
        return ["q": query, "limit": limit]
    }

    private static func createParameters(zipCode: String) -> Parameters {
        return ["zip": zipCode]
    }

    private static func createParameters(lat: Double, lon: Double, limit: Int? = nil) -> OptinalParameters {
        return ["lat": lat, "lon": lon, "limit": limit]
    }
}
