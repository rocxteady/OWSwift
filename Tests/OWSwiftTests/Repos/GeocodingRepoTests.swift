//
//  GeocodingRepoTests.swift
//
//
//  Created by Ulaş Sancak on 25.10.2023.
//

import XCTest
@testable import OWSwift
import Combine

final class GeocodingRepoTests: XCTestCase {
    private let configuration = URLSessionConfiguration.default
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        OWSwift.sessionConfiguration.protocolClasses = [MockedURLService.self]
        OWSwift.initialize(with: "hjdf87238jfhjhsh838hsjjdf83ıjdha")
    }

    override func tearDownWithError() throws {
        OWSwift.deIitialize()
        OWSwift.sessionConfiguration.protocolClasses = nil
    }

    func testGettingLocationsWithAsyncAwait() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: GeocodingEndpoint.direct.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try [GeoLocation].mockData)
        }

        let locations = try await GeocodingRepo.getLocations(cityName: "San Francisco")

        testModel(locations: locations)
    }

    func testGettingLocationsWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: GeocodingEndpoint.direct.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try [GeoLocation].mockData)
        }

        let publisher: AnyPublisher<[GeoLocation], Error> = GeocodingRepo.getLocations(cityName: "San Francisco")

        let expectation = self.expectation(description: "api")

        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { [weak self] locations in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                testModel(locations: locations)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    func testGettingLocationWithZipCodeWithAsyncAwait() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: GeocodingEndpoint.zip.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try GeoZipLocation.mockData)
        }

        let location = try await GeocodingRepo.getLocation(zipCode: "10001")

        testModel(location: location)
    }

    func testGettingLocationWithZipCodeWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: GeocodingEndpoint.zip.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try GeoZipLocation.mockData)
        }

        let publisher: AnyPublisher<GeoZipLocation, Error> = GeocodingRepo.getLocation(zipCode: "10001")

        let expectation = self.expectation(description: "api")

        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { [weak self] location in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                testModel(location: location)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    func testGettingLocationsReverseWithAsyncAwait() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: GeocodingEndpoint.reverse.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try [GeoLocation].mockData)
        }

        let locations = try await GeocodingRepo.getLocations(lat: 37.7790262, lon: -73.9967)

        testModel(locations: locations)
    }

    func testGettingLocationsReverseWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: GeocodingEndpoint.reverse.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try [GeoLocation].mockData)
        }

        let publisher: AnyPublisher<[GeoLocation], Error> = GeocodingRepo.getLocations(lat: 37.7790262, lon: -73.9967)

        let expectation = self.expectation(description: "api")

        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            } receiveValue: { [weak self] locations in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                testModel(locations: locations)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    private func testModel(locations: [GeoLocation]) {
        let location = locations.first!
        XCTAssertEqual(location.name, "San Francisco")
        XCTAssertEqual(location.localNames?["te"], "శాన్ ఫ్రాన్సిస్కో")
        XCTAssertEqual(location.localNames?["es"], "San Francisco")
        XCTAssertEqual(location.localNames?["en"], "San Francisco")
        XCTAssertEqual(location.localNames?["yi"], "סאן פראנציסקא")
        XCTAssertEqual(location.lat, 37.7790262)
        XCTAssertEqual(location.lon, -122.419906)
        XCTAssertEqual(location.country, "US")
        XCTAssertEqual(location.state, "California")
    }

    private func testModel(location: GeoZipLocation) {
        XCTAssertEqual(location.zip, "10001")
        XCTAssertEqual(location.name, "New York")
        XCTAssertEqual(location.lat, 40.7484)
        XCTAssertEqual(location.lon, -73.9967)
        XCTAssertEqual(location.country, "US")
    }
}
