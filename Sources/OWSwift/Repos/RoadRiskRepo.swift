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
        let restClient = RestClient.initialize()
        return try await restClient.fetch(with: createRequestConfiguration(with: try createURL(), locations: locations))
    }

    public static func getRoadRisk(locations: [RoadRiskLocation]) -> AnyPublisher<[RoadRisk], Error> {
        Future<String, Error> { promise in
            do {
                promise(.success(try createURL()))
            } catch {
                promise(.failure(error))
            }
        }
        .tryMap { url -> AnyPublisher<[RoadRisk], Error> in
            let restClient = RestClient.initialize()
            return restClient.publisher(with: try createRequestConfiguration(with: url, locations: locations))
        }
        .switchToLatest()
        .eraseToAnyPublisher()
    }
}

extension RoadRiskRepo {
    private static func createURL() throws -> String {
        Endpoint.roadRisk.fullURL + "?appId=\(try OWSwift.apiKey)"
    }
    private static func createRequestConfiguration(with url: String, locations: [RoadRiskLocation]) throws -> RequestConfiguration {
        let parameters = RoadRiskRequestParams(track: locations)
        let data = try JSONEncoder().encode(parameters)
        return .init(urlString: url, method: .post, body: data, encoding: .json)
    }
}
