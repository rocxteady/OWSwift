//
//  RoadRiskRepoTests.swift
//
//
//  Created by Ulaş Sancak on 20.10.2023.
//

#if !os(watchOS)
import XCTest
@testable import OWSwift
import Combine

final class RoadRiskRepoTests: XCTestCase {
    private let configuration = URLSessionConfiguration.default
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        OWSwift.sessionConfiguration.protocolClasses = [MockedURLService.self]
        URLProtocol.registerClass(MockedURLService.self)
        OWSwift.initialize(with: "hjdf87238jfhjhsh838hsjjdf83ıjdha")
    }

    override func tearDownWithError() throws {
        OWSwift.deIitialize()
        OWSwift.sessionConfiguration.protocolClasses = nil
        URLProtocol.unregisterClass(MockedURLService.self)
    }

    func testGettingRoadRiskWithAsyncAwait() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: "Endpoint.roadRisk.fullURL")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try RoadRisk.mockData)
        }
        let roadRisks = try await RoadRiskRepo.getRoadRisk(locations: [.init(lat: 7.27, lon: 44.04, dt: 1602702000)])
        testModel(roadRisks: roadRisks)
    }

    func testGettingRoadRiskWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: Endpoint.roadRisk.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try RoadRisk.mockData)
        }

        let publisher: AnyPublisher<[RoadRisk], Error> = RoadRiskRepo.getRoadRisk(locations: [.init(lat: 7.27, lon: 44.04, dt: 1602702000)])

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
            } receiveValue: { [weak self] roadRisks in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                testModel(roadRisks: roadRisks)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }

    private func testModel(roadRisks: [RoadRisk]) {
        XCTAssertEqual(roadRisks[0].dt, 1602702000)
        XCTAssertEqual(roadRisks[0].coord, [7.27, 44.04])
        XCTAssertEqual(roadRisks[0].weather.temp, 278.44)
        XCTAssertEqual(roadRisks[0].weather.windSpeed, 2.27)
        XCTAssertEqual(roadRisks[0].weather.windDeg, 7)
        XCTAssertEqual(roadRisks[0].weather.precipitationIntensity, 0.38)
        XCTAssertEqual(roadRisks[0].weather.visibility, 10000)
        XCTAssertEqual(roadRisks[0].weather.dewPoint, 276.13)
        XCTAssertEqual(roadRisks[0].road?.state, .moist)
        XCTAssertEqual(roadRisks[0].road?.temp, 293.85)
        XCTAssertEqual(roadRisks[0].alerts[0].senderName, "METEO-FRANCE")
        XCTAssertEqual(roadRisks[0].alerts[0].event, "Moderate thunderstorm warning")
        XCTAssertEqual(roadRisks[0].alerts[0].eventLevel, .yellow)
    }
}
#endif
