//
//  RoadRiskRequestParams.swift
//
//
//  Created by Ulaş Sancak on 19.10.2023.
//

import Foundation

struct RoadRiskRequestParams: Encodable {
    let track: [RoadRiskLocation]
}

public struct RoadRiskLocation: Encodable {
    public let lat: Double
    public let lon: Double
    public let dt: Int
}
