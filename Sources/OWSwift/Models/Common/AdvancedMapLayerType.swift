//
//  AdvancedMapLayerType.swift
//
//
//  Created by Ulaş Sancak on 20.10.2023.
//

import Foundation

public enum AdvancedMapLayerType: String {
    case convectivePrec = "PAC0"
    case prepIntensity = "PR0"
    case accumulatedPrecGeneral = "PA0"
    case accumulatedPrecRain = "PAR0"
    case accumulatedPrecSnow = "PAS0"
    case depthOfSnow = "SD0"
    case windSpeedAt10 = "WS10"
    case wind = "WND"
    case pressure = "APM"
    case tempAt2 = "TA2"
    case tempOfDewPoint = "TD2"
    case soilTemp = "TS0"
    case soilTempAbove10 = "TS10"
    case humidity = "HRD0"
    case cloud = "CL"
}
