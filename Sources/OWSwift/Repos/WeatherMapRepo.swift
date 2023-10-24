//
//  WeatherMapRepo.swift
//
//
//  Created by Ulaş Sancak on 18.10.2023.
//

import Foundation
import Resting
import Combine
import ThrowPublisher
#if canImport(UIKit)
import UIKit.UIImage
#elseif canImport(AppKit)
import AppKit.NSImage
#endif

public enum WeatherMapError: LocalizedError {
    case imageDecoding

    public var errorDescription: String? {
        switch self {
        case .imageDecoding:
            return NSLocalizedString("WeatherMapError.imageDecoding", bundle: .module, comment: "")
        }
    }
}

public struct WeatherMapRepo {
    public static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> Data {
        try validate(zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        let restClient = RestClient.initialize()
        let url = createURL(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        return try await restClient.fetch(with: .init(urlString: url, parameters: .init().createParameters()))
    }

    public static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> AnyPublisher<Data, Error> {
        validate_publisher(zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
            .tryMap {
                try Parameters()
                    .createParameters()
            }
            .flatMap { parameters in
                let restClient = RestClient.initialize()
                let url = createURL(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
                return restClient.publisher(with: .init(urlString: url, parameters: parameters)).map { $0 }
            }
            .eraseToAnyPublisher()
    }
}

#if canImport(UIKit)

public extension WeatherMapRepo {
    @MainActor
    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> UIImage {
        let data: Data = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        guard let image = UIImage(data: data) else {
            throw WeatherMapError.imageDecoding
        }
        return image
    }

    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> AnyPublisher<UIImage, Error> {
        return getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
            .tryMap {
                guard let image = UIImage(data: $0) else {
                    throw WeatherMapError.imageDecoding
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
#endif

#if canImport(AppKit)

public extension WeatherMapRepo {
    @MainActor
    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> NSImage {
        let data: Data = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        guard let image = NSImage(data: data) else {
            throw WeatherMapError.imageDecoding
        }
        return image
    }

    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> AnyPublisher<NSImage, Error> {
        return getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
            .tryMap {
                guard let image = NSImage(data: $0) else {
                    throw WeatherMapError.imageDecoding
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
#endif

import SwiftUI

public extension WeatherMapRepo {
    @MainActor
    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> Image {
        #if canImport(UIKit)
        let image: UIImage = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        return Image(uiImage: image)
        #elseif canImport(AppKit)
        let image: NSImage = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        return Image(nsImage: image)
        #endif
    }

    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> AnyPublisher<Image, Error> {
        #if canImport(UIKit)
        let publisher: AnyPublisher<UIImage, Error> =  getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        let imagePublisher = publisher.tryMap {
            Image(uiImage: $0)
        }
        #elseif canImport(AppKit)
        let publisher: AnyPublisher<NSImage, Error> =  getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        let imagePublisher = publisher.tryMap {
            Image(nsImage: $0)
        }
        #endif
        return imagePublisher.eraseToAnyPublisher()
    }
}

extension WeatherMapRepo {
    private static func createURL(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> String {
        return "\(Constants.API.Map.url)/\(layer.rawValue)/\(zoomLevel)/\(xTile)/\(yTile)"
    }

    @ThrowPublisher
    fileprivate static func validate(zoomLevel: Int, xTile: Int, yTile: Int) throws {
        try Validators.validateZoomLevelAndTiles(zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
    }
}
