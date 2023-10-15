//
//  ParameterTests.swift
//  
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift

final class ParameterTests: XCTestCase {

    override func setUpWithError() throws {
        OWSwift.initialize(with: "hjdf87238jfhjhsh838hsjjdf83ıjdha")
    }

    override func tearDownWithError() throws {
        OWSwift.deIitialize()
    }

    func testCreatingParaqmeters() throws {
        let parameters: Parameters = ["lat": 41, "lon": 29]
        let createdParameters = try parameters.createParameters()
        XCTAssertEqual(parameters["lat"] as? Double, createdParameters["lat"] as? Double, "Parameter don't match!")
        XCTAssertEqual(parameters["lon"] as? Double, createdParameters["lon"] as? Double, "Parameter don't match!")
        XCTAssertTrue(!((createdParameters["appId"] as? String)?.isEmpty ?? true), "OWSwift might not be initialized!")
        XCTAssertEqual(createdParameters["units"] as? String, "metric", "Parameter don't match!")
    }

    func testCreatingParametersWithOverriding() throws {
        let parameters: Parameters = ["lat": 41, "lon": 29, "units": "imperial"]
        let createdParameters = try parameters.createParameters()
        XCTAssertEqual(createdParameters["units"] as? String, "imperial", "Parameter don't match!")
    }

    func testCreatingParametersWithPublisherFailure() throws {
        let parameters: Parameters = ["lat": 41, "lon": 29, "units": "imperial"]
        let createdParameters = try parameters.createParameters()
        XCTAssertEqual(createdParameters["units"] as? String, "imperial", "Parameter don't match!")
    }

}
