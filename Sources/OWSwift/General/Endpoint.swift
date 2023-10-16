//
//  Endpoint.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

enum Endpoint: String {
    case currentWeather = "/weather"

    var fullURL: String {
        switch self {
        case .currentWeather:
            return Constants.API.fullBaseAPIURL + rawValue
        }
    }
}
