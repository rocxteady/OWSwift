//
//  RoadRisk.swift
//  
//
//  Created by Ulaş Sancak on 19.10.2023.
//

import Foundation

public struct RoadRisk: Decodable {    
    public struct Weather: Decodable {
        public let temp, windSpeed: Double
        public let windDeg: Int
        public let precipitationIntensity: Double?
        public let visibility: Int
        public let dewPoint: Double

        enum CodingKeys: String, CodingKey {
            case temp
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case precipitationIntensity = "precipitation_intensity"
            case visibility
            case dewPoint = "dew_point"
        }
    }

    public struct Road: Decodable {
        public enum State: Int, Decodable {
            case noReport
            case dry
            case moist
            case moistChemicallyTreated
            case wet
            case wetChemicallyTreated
            case ice
            case frost
            case snow
            case snowIceWatch
            case snowIceWarning
            case wetAboveFreezing
            case wetBelowFreezing
            case absorption
            case absorptionAtDewpoint
            case dew
            case blackIceWarning
            case other
            case slush
        }
        public let state: State?
        public let temp: Double?
    }

    public struct Alert: Decodable {
        public enum EventLEvel: Int, Decodable {
            case unknown
            case green
            case yellow
            case orange
            case red
        }
        public let senderName, event: String
        public let eventLevel: EventLEvel

        enum CodingKeys: String, CodingKey {
            case senderName = "sender_name"
            case event
            case eventLevel = "event_level"
        }
    }

    public let dt: Date
    public let coord: [Double]
    public let weather: Weather
    public let road: Road?
    public let alerts: [Alert]
}
