//
//  ValidatorTests.swift
//  
//
//  Created by Ulaş Sancak on 22.10.2023.
//

import XCTest
@testable import OWSwift

final class ValidatorTests: XCTestCase {
    func testLocation() throws {
        try Validators.validateLatLon(lat: 90, lon: -180)
    }

    func testLocationWithFailureWithLat() throws {
        do {
            try Validators.validateLatLon(lat: 91, lon: 180)
            XCTFail("Location validation should have been failed with latitude error.")
        } catch ValidationError.latitude {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testLocationWithFailureWithLon() throws {
        do {
            try Validators.validateLatLon(lat: -90, lon: 181)
            XCTFail("Location validation should have been failed with latitude error.")
        } catch ValidationError.longitude {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testZoomLevel() throws {
        try Validators.validateZoomLevelAndTiles(zoomLevel: 0, xTile: 1, yTile: 1)
    }

    func testZoomLevelWithFailureWithZero() throws {
        do {
            try Validators.validateZoomLevelAndTiles(zoomLevel: 0, xTile: 2, yTile: 2)
            XCTFail("Zoom validation should have been failed!")
        } catch ValidationError.zoomLeveLAndTiles {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testZoomLevelWithFailureWithBelow10() throws {
        do {
            try Validators.validateZoomLevelAndTiles(zoomLevel: 1, xTile: 2, yTile: 2)
            XCTFail("Zoom validation should have been failed!")
        } catch ValidationError.zoomLeveLAndTiles {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testZoomLevelWithFailureWithAbove9() throws {
        do {
            try Validators.validateZoomLevelAndTiles(zoomLevel: 10, xTile: 2, yTile: 2)
            XCTFail("Zoom validation should have been failed!")
        } catch ValidationError.zoomLeveLAndTiles {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testOpacity() throws {
        try Validators.validateOpacity(0)
        try Validators.validateOpacity(0.5)
        try Validators.validateOpacity(1)
    }

    func testOpacityWithFailureBelow0() throws {
        do {
            try Validators.validateOpacity(-1)
            XCTFail("Opacity validation should have been failed!")
        } catch ValidationError.opacity {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testOpacityWithFailureAbove1() throws {
        do {
            try Validators.validateOpacity(1.1)
            XCTFail("Opacity validation should have been failed!")
        } catch ValidationError.opacity {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testColorPalettes() throws {
        try Validators.validateColorPalettes([.init(value: "0", hex: "FF0000"), .init(value: "10", hex: "00FF00")])
    }

    func testColorPalettesWithFailureEmpty() throws {
        do {
            try Validators.validateColorPalettes([])
            XCTFail("Color palette validation should have been failed!")
        } catch ValidationError.colorPalettes {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testColorPalettesWithFailureBelow2() throws {
        do {
            try Validators.validateColorPalettes([.init(value: "0", hex: "FF0000")])
            XCTFail("Color palette validation should have been failed!")
        } catch ValidationError.colorPalettes {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testErrors() {
        let latitude = ValidationError.latitude
        XCTAssertNotNil(latitude.errorDescription, "ValidationError description should not be nil!")
        let longitude = ValidationError.longitude
        XCTAssertNotNil(longitude.errorDescription, "ValidationError description should not be nil!")
        let zoomLeveLAndTiles = ValidationError.zoomLeveLAndTiles
        XCTAssertNotNil(zoomLeveLAndTiles.errorDescription, "ValidationError description should not be nil!")
        let opacity = ValidationError.opacity
        XCTAssertNotNil(opacity.errorDescription, "ValidationError description should not be nil!")
        let colorPalettes = ValidationError.colorPalettes
        XCTAssertNotNil(colorPalettes.errorDescription, "ValidationError description should not be nil!")
    }
}
