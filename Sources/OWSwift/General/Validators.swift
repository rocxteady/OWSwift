//
//  Validators.swift
//
//
//  Created by Ulaş Sancak on 20.10.2023.
//

import Foundation
import ThrowPublisher
import Combine

enum ValidationError: LocalizedError {
    case latitude
    case longitude
    case zoomLeveLAndTiles
    case opacity
    case colorPalettes

    var errorDescription: String? {
        switch self {
        case .latitude:
            return NSLocalizedString("ValidationError.latitude", bundle: .module, comment: "")
        case .longitude:
            return NSLocalizedString("ValidationError.longitude", bundle: .module, comment: "")
        case .zoomLeveLAndTiles:
            return NSLocalizedString("ValidationError.zoomLeveLAndTiles", bundle: .module, comment: "")
        case .opacity:
            return NSLocalizedString("ValidationError.opacity", bundle: .module, comment: "")
        case .colorPalettes:
            return NSLocalizedString("ValidationError.colorPalettes", bundle: .module, comment: "")
        }
    }
}

struct Validators {
    @ThrowPublisher
    static func validateLatLon(lat: Double, lon: Double) throws {
        guard (-90...90).contains(lat) else {
            throw ValidationError.latitude
        }
        guard (-180...180).contains(lon) else {
            throw ValidationError.longitude
        }
    }

    static func validateZoomLevelAndTiles(zoomLevel: Int, xTile: Int, yTile: Int) throws {
        if zoomLevel == 0 {
            if xTile != 1 || yTile != 1 {
                throw ValidationError.zoomLeveLAndTiles
            }
        } else if zoomLevel < 10 {
            let upperEndDouble: Double = pow(2.0, Double(zoomLevel))
            let upperEnd = Int(upperEndDouble)
            guard  0..<upperEnd ~= xTile,
                   0..<upperEnd ~= yTile else {
                throw ValidationError.zoomLeveLAndTiles
            }
        } else {
            throw ValidationError.zoomLeveLAndTiles
        }
    }

    static func validateOpacity(_ opacity: Double) throws {
        guard (0...1.0).contains(opacity) else {
            throw ValidationError.opacity
        }
    }

    static func validateColorPalettes(_ palettes: [ColorPalette]) throws {
        guard palettes.count > 1 else {
            throw ValidationError.colorPalettes
        }
    }
}
