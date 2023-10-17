//
//  City.swift
//  
//
//  Created by Ulaş Sancak on 16.10.2023.
//

import Foundation

public struct City: Decodable {
    public let id: Int
    public let name: String
    public let coord: Coord
    public let country: String
    public let population, timezone, sunrise, sunset: Int
}
