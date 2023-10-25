//
//  GeoLocation.swift
//
//
//  Created by Ulaş Sancak on 25.10.2023.
//

import Foundation

public struct GeoLocation: Decodable {
    public let name: String
    public let localNames: [String: String]?
    public let lat: Double
    public let lon: Double
    public let country: String
    public let state: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

public struct GeoZipLocation: Decodable {
    public let zip: String
    public let name: String
    public let lat: Double
    public let lon: Double
    public let country: String
}
