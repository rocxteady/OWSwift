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

public struct AdvancedWeatherMapRepo {
    public static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) async throws -> Data {
        try validate(zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, opacity: opacity, colorPalettes: colorPalettes)
        let restClient = RestClient.initialize()
        let url = createURL(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        let parameters = try createParameters(date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
            .createParameters()
        return try await restClient.fetch(with: .init(urlString: url, parameters: parameters))
    }

    public static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) -> AnyPublisher<Data, Error> {
        validate_publisher(zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, opacity: opacity, colorPalettes: colorPalettes)
            .tryMap {
                try createParameters(date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
                    .createParameters()
            }
            .flatMap { parameters in
                let restClient = RestClient.initialize()
                let url = createURL(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
                return restClient.publisher(with: .init(urlString: url, parameters: parameters))
                    .map { $0 }
            }
            .eraseToAnyPublisher()
    }
}

#if canImport(UIKit)

extension AdvancedWeatherMapRepo {
    @MainActor
    static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) async throws -> UIImage {
        let data: Data = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
        guard let image = UIImage(data: data) else {
            throw WeatherMapError.imageDecoding
        }
        return image
    }

    static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) -> AnyPublisher<UIImage, Error> {
        return getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
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

extension AdvancedWeatherMapRepo {
    @MainActor
    static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) async throws -> NSImage {
        let data: Data = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
        guard let image = NSImage(data: data) else {
            throw WeatherMapError.imageDecoding
        }
        return image
    }

    static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) -> AnyPublisher<NSImage, Error> {
        return getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
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

extension AdvancedWeatherMapRepo {
    @MainActor
    static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) async throws -> Image {
        #if canImport(UIKit)
        let image: UIImage = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
        return Image(uiImage: image)
        #elseif canImport(AppKit)
        let image: NSImage = try await getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
        return Image(nsImage: image)
        #endif
    }

    static func getMap(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int, date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) -> AnyPublisher<Image, Error> {
        #if canImport(UIKit)
        let publisher: AnyPublisher<UIImage, Error> =  getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
        let imagePublisher = publisher.tryMap {
            Image(uiImage: $0)
        }
        #elseif canImport(AppKit)
        let publisher: AnyPublisher<NSImage, Error> =  getMap(layer: layer, zoomLevel: zoomLevel, xTile: xTile, yTile: yTile, date: date, opacity: opacity, colorPalettes: colorPalettes, fillBound: fillBound, arrowStep: arrowStep, useNorm: useNorm)
        let imagePublisher = publisher.tryMap {
            Image(nsImage: $0)
        }
        #endif
        return imagePublisher.eraseToAnyPublisher()
    }
}

extension AdvancedWeatherMapRepo {
    private static func createURL(layer: AdvancedMapLayerType, zoomLevel: Int, xTile: Int, yTile: Int) -> String {
        return "\(Constants.API.AdvancedMap.url)/\(layer.rawValue)/\(zoomLevel)/\(xTile)/\(yTile)"
    }

    private static func createParameters(date: Int? = nil, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil, fillBound: Bool? = nil, arrowStep: Int? = nil, useNorm: Bool? = nil) -> OptinalParameters {
        ["date": date, "opacity": opacity, "pallet": colorPalettes?.asParameter, "fill_bound": fillBound, "arrow_step": arrowStep, "use_norm": useNorm]
    }

    @ThrowPublisher
    fileprivate static func validate(zoomLevel: Int, xTile: Int, yTile: Int, opacity: Double? = nil, colorPalettes: [ColorPalette]? = nil) throws {
        try Validators.validateZoomLevelAndTiles(zoomLevel: zoomLevel, xTile: xTile, yTile: yTile)
        if let opacity {
            try Validators.validateOpacity(opacity)
        }
        if let colorPalettes {
            try Validators.validateColorPalettes(colorPalettes)
        }
    }
}
