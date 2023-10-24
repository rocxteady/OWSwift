//
//  MapLayerType.swift
//
//
//  Created by Ulaş Sancak on 18.10.2023.
//

import Foundation

public enum MapLayerType: String, Decodable {
    case clouds = "clouds_new"
    case precipitation = "precipitation_new"
    case pressure = "pressure_new"
    case wind = "wind_new"
    case temp = "temp_new"
}
