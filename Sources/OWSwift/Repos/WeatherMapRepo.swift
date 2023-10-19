//
//  WeatherMapRepo.swift
//
//
//  Created by Ulaş Sancak on 18.10.2023.
//

import Foundation
import Resting
import Combine
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

struct WeatherMapRepo {
    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> Data {
        let restClient = RestClient.initialize()
        let url = createURL(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        return try await restClient.fetch(with: .init(urlString: url, parameters: .init().createParameters()))
    }

    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> AnyPublisher<Data, Error> {
        return [String: Any]()
            .createParametersWithPublisher()
            .map { parameters -> AnyPublisher<Data, Error> in
                let restClient = RestClient.initialize()
                let url = createURL(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
                return restClient.publisher(with: .init(urlString: url, parameters: parameters))
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

#if canImport(UIKit)

extension WeatherMapRepo {
    @MainActor
    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> UIImage {
        guard let image = try await UIImage(data: getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)) else {
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

extension WeatherMapRepo {
    @MainActor
    static func getMap(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) async throws -> NSImage {
        guard let image = try await NSImage(data: getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)) else {
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

extension WeatherMapRepo {
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
        #elseif canImport(AppKit)
        let publisher: AnyPublisher<NSImage, Error> =  getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        #endif
        return publisher.tryMap {
            #if canImport(UIKit)
            return Image(uiImage: $0)
            #elseif canImport(AppKit)
            return Image(nsImage: $0)
            #endif
        }
        .eraseToAnyPublisher()
    }
}

extension WeatherMapRepo {
    private static func createURL(layer: MapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> String {
        return "\(Constants.API.Map.url)/\(layer.rawValue)/\(zoomLevel)/\(xTile)/\(yTile)"
    }
}
