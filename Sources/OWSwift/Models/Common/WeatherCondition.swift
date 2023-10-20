//
//  WeatherCondition.swift
//
//
//  Created by Ulaş Sancak on 16.10.2023.
//

import Foundation

public struct WeatherCondition: Decodable {
    public let id: Int
    public let main, description, icon: String
    public var iconURL: String {
        WeatherIconURLCreator.create(with: icon)
    }
}
