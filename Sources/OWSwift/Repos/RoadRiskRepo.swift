//
//  RoadRiskRepo.swift
//
//
//  Created by Ulaş Sancak on 19.10.2023.
//

import Foundation
import Resting
import Combine

public struct RoadRiskRepo {
    public static func getRoadRisk(locations: [RoadRiskLocation]) async throws -> [RoadRisk] {
        try locations.validate()
        let restClient = RestClient.initialize()
        return try await restClient.fetch(with: createRequestConfiguration(with: try createURL(), locations: locations))
    }

    public static func getRoadRisk(locations: [RoadRiskLocation]) -> AnyPublisher<[RoadRisk], Error> {
        locations.validate_publisher()
            .tryMap {
                try createURL()
            }
            .tryMap { url in
                try createRequestConfiguration(with: url, locations: locations)
            }
            .flatMap { configuration in
                let restClient = RestClient.initialize()
                let publisher: AnyPublisher<[RoadRisk], Error> = restClient.publisher(with: configuration)
                return publisher.map { $0 }
            }
            .eraseToAnyPublisher()
    }
}

extension RoadRiskRepo {
    private static func createURL() throws -> String {
        Endpoint.roadRisk.fullURL + "?appId=\(try OWSwift.apiKey)"
    }

    private static func createRequestConfiguration(with url: String, locations: [RoadRiskLocation]) throws -> RequestConfiguration {
        let parameters = RoadRiskRequestParams(track: locations)
        let data = try OWSwift.jsonEncoder.encode(parameters)
        return .init(urlString: url, method: .post, body: data, encoding: .json)
    }
}
