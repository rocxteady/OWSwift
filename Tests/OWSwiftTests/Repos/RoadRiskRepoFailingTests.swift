//
//  RoadRiskRepoFailingTests.swift
//  
//
//  Created by Ulaş Sancak on 22.10.2023.
//

import XCTest
@testable import OWSwift

final class RoadRiskRepoFailingTests: XCTestCase {
    private let configuration = URLSessionConfiguration.default

    override func setUpWithError() throws {
        OWSwift.sessionConfiguration.protocolClasses = [MockedURLService.self]
        OWSwift.initialize(with: "hjdf87238jfhjhsh838hsjjdf83ıjdha", jsonEncoder: FailingEncoder())
    }

    override func tearDownWithError() throws {
        OWSwift.deIitialize()
        OWSwift.sessionConfiguration.protocolClasses = nil
    }
    func testGettingRoadRiskWithEncodingFailure() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: "Endpoint.roadRisk.fullURL")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try RoadRisk.mockData)
        }
        do {
            _ =  try await RoadRiskRepo.getRoadRisk(locations: [.init(lat: 7.27, lon: 44.04, dt: Date(timeIntervalSince1970: 1602702000))])
            XCTFail("Encoding should have been failed!")
        } catch is EncodingError {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
