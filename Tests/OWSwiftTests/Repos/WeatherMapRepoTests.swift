//
//  WeatherMapRepoTests.swift
//  
//
//  Created by Ulaş Sancak on 18.10.2023.
//

import XCTest
@testable import OWSwift
import Combine
import SwiftUI

final class WeatherMapRepoTests: XCTestCase {
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

    func testGettingMapWithImage() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, MockImageDataGenerator.generate())
        }

        let _: Image = try await WeatherMapRepo.getMap(layer: .clouds, zoomLevel: 1, xTile: 1, yTile: 1)
    }

    func testGettingMapWithImageWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, MockImageDataGenerator.generate())
        }

        let publisher: AnyPublisher<Image, Error> = WeatherMapRepo.getMap(layer: .clouds, zoomLevel: 1, xTile: 1, yTile: 1)

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
            } receiveValue: { _ in }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    func testGettingMapWithFailure() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, nil)
        }

        do {
            let _: Image = try await WeatherMapRepo.getMap(layer: .clouds, zoomLevel: 1, xTile: 1, yTile: 1)
            XCTFail("Image decoding should have been failed!")
        } catch WeatherMapError.imageDecoding {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testGettingMapWithWithFalureWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, nil)
        }

        let publisher: AnyPublisher<Image, Error> = WeatherMapRepo.getMap(layer: .clouds, zoomLevel: 1, xTile: 1, yTile: 1)

        let expectation = self.expectation(description: "api")

        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    switch error {
                    case WeatherMapError.imageDecoding:
                        break
                    default:
                        XCTFail(error.localizedDescription)
                    }
                    expectation.fulfill()
                case .finished:
                    XCTFail("Image decoding should have been failed!")
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    func testErrors() {
        let imageDecoding = WeatherMapError.imageDecoding
        XCTAssertNotNil(imageDecoding.errorDescription, "WeatherMapError case should not be nil!")
    }
}
