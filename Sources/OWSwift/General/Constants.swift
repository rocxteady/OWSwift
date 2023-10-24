//
//  Constants.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

struct Constants {
    static let baseURL = "https://openweathermap.org"

    struct API {
        static let baseAPIURL = "https://api.openweathermap.org/data"
        static let proBaseAPIURL = "https://pro.openweathermap.org/data"
        static let version = "2.5"
        static let fullBaseAPIURL = Self.baseAPIURL + "/" + Self.version
        struct Map {
            static let url = "https://tile.openweathermap.org/map"
        }
        struct AdvancedMap {
            static let url = "http://maps.openweathermap.org/maps/2.0/weather"
        }
        struct Image {
            static let fullBaseIMGURL = Constants.baseURL + "/img/wn"
        }
    }
}

extension Constants {
    static var defaultParameters: Parameters {
        get throws {
            [
                "appId": try OWSwift.apiKey,
                "units": Units.metric.rawValue
            ]
        }
    }
}
