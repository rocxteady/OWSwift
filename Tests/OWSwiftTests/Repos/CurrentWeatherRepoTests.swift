//
//  CurrentWeatherRepoTests.swift
//
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift
import Combine

final class CurrentWeatherRepoTests: XCTestCase {
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

    func testGettingCurrentWeatherWithAsyncAwait() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: Endpoint.currentWeather.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try CurrentWeather.mockData)
        }

        let currentWeatherFromData = try await CurrentWeatherRepo.getCurrentWeather(lat: 41, lon: 29)
        let currentWeather = CurrentWeather.mock
        testModels(fromData: currentWeatherFromData, fromMock: currentWeather)
    }

    func testGettingCurrentWeatherWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: Endpoint.currentWeather.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try CurrentWeather.mockData)
        }

        let publisher: AnyPublisher<CurrentWeather, Error> = CurrentWeatherRepo.getCurrentWeather(lat: 41, lon: 29)

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
            } receiveValue: { [weak self] currentWeatherFromData in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                let currentWeather = CurrentWeather.mock
                testModels(fromData: currentWeatherFromData, fromMock: currentWeather)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    private func testModels(fromData: CurrentWeather, fromMock: CurrentWeather) {
        XCTAssertEqual(fromMock.base, fromData.base)
        XCTAssertEqual(fromMock.cityId, fromData.cityId)
        XCTAssertEqual(fromMock.cityName, fromData.cityName)
        XCTAssertEqual(fromMock.cod, fromData.cod)
        XCTAssertEqual(fromMock.dt, fromData.dt)
        XCTAssertEqual(fromMock.timezone, fromData.timezone)
        XCTAssertEqual(fromMock.visibility, fromData.visibility)
        XCTAssertEqual(fromMock.clouds.all, fromData.clouds.all)
        XCTAssertEqual(fromMock.conditions[0].description, fromData.conditions[0].description)
        XCTAssertEqual(fromMock.conditions[0].icon, fromData.conditions[0].icon)
        XCTAssertEqual(fromMock.conditions[0].iconURL, fromData.conditions[0].iconURL)
        XCTAssertEqual(fromMock.conditions[0].id, fromData.conditions[0].id)
        XCTAssertEqual(fromMock.conditions[0].main, fromData.conditions[0].main)
        XCTAssertEqual(fromMock.coord.lat, fromData.coord.lat)
        XCTAssertEqual(fromMock.coord.lon, fromData.coord.lon)
        XCTAssertEqual(fromMock.mainWeatherInfo.feelsLike, fromData.mainWeatherInfo.feelsLike)
        XCTAssertEqual(fromMock.mainWeatherInfo.grndLevel, fromData.mainWeatherInfo.grndLevel)
        XCTAssertEqual(fromMock.mainWeatherInfo.humidity, fromData.mainWeatherInfo.humidity)
        XCTAssertEqual(fromMock.mainWeatherInfo.pressure, fromData.mainWeatherInfo.pressure)
        XCTAssertEqual(fromMock.mainWeatherInfo.seaLevel, fromData.mainWeatherInfo.seaLevel)
        XCTAssertEqual(fromMock.mainWeatherInfo.temp, fromData.mainWeatherInfo.temp)
        XCTAssertEqual(fromMock.mainWeatherInfo.tempMax, fromData.mainWeatherInfo.tempMax)
        XCTAssertEqual(fromMock.mainWeatherInfo.tempMin, fromData.mainWeatherInfo.tempMin)
        XCTAssertEqual(fromMock.rain?.the1H, fromData.rain?.the1H)
        XCTAssertEqual(fromMock.rain?.the3H, fromData.rain?.the3H)
        XCTAssertEqual(fromMock.snow?.the1H, fromData.snow?.the1H)
        XCTAssertEqual(fromMock.snow?.the3H, fromData.snow?.the3H)
        XCTAssertEqual(fromMock.sys.country, fromData.sys.country)
        XCTAssertEqual(fromMock.sys.id, fromData.sys.id)
        XCTAssertEqual(fromMock.sys.message, fromData.sys.message)
        XCTAssertEqual(fromMock.sys.sunrise, fromData.sys.sunrise)
        XCTAssertEqual(fromMock.sys.sunset, fromData.sys.sunset)
        XCTAssertEqual(fromMock.sys.type, fromData.sys.type)
        XCTAssertEqual(fromMock.wind.deg, fromData.wind.deg)
        XCTAssertEqual(fromMock.wind.gust, fromData.wind.gust)
        XCTAssertEqual(fromMock.wind.speed, fromData.wind.speed)
    }
}
