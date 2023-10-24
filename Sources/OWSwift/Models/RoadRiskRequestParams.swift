//
//  RoadRiskRequestParams.swift
//
//
//  Created by Ulaş Sancak on 19.10.2023.
//

import Foundation
import ThrowPublisher
import Combine

struct RoadRiskRequestParams: Encodable {
    let track: [RoadRiskLocation]
}

public struct RoadRiskLocation: Encodable {
    public let lat: Double
    public let lon: Double
    public let dt: Date
}

extension RoadRiskLocation {
    func validate() throws {
        try Validators.validateLatLon(lat: lat, lon: lon)
    }
}

extension [RoadRiskLocation] {
    @ThrowPublisher
    func validate() throws {
        for location in self {
            try location.validate()
        }
    }
}
