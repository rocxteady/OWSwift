//
//  Constants.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

struct Constants {
    static let baseURL = "https://openweather.map.org"

    struct API {
        static let baseAPIURL = "https://api.openweathermap.org/data"
        static let version = "2.5"
        static let fullBaseAPIURL = Self.baseAPIURL + "/" + Self.version
    }
    struct Image {
        static let fullBaseIMGURL = Constants.baseURL + "/img/wn"
    }
}

extension Constants {
    static var defaultParameters: [String: Any] {
        get throws {
            [
                "appId": try OWSwift.apiKey,
                "units": Units.metric.rawValue
            ]
        }
    }
}
