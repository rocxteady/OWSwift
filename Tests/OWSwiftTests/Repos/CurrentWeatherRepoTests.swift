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
        print(Date().timeIntervalSince1970)
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

        let currentWeather = try await CurrentWeatherRepo.getCurrentWeather(lat: 41, lon: 29)
        testModel(currentWeather: currentWeather)
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
            } receiveValue: { [weak self] currentWeather in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                testModel(currentWeather: currentWeather)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    private func testModel(currentWeather: CurrentWeather) {
        XCTAssertEqual(currentWeather.coord.lon, 29)
        XCTAssertEqual(currentWeather.coord.lat, 41)
        XCTAssertEqual(currentWeather.conditions[0].id, 800)
        XCTAssertEqual(currentWeather.conditions[0].icon, "01d")
        XCTAssertEqual(currentWeather.conditions[0].description, "clear sky")
        XCTAssertEqual(currentWeather.conditions[0].iconURL, "https://openweathermap.org/img/wn/01d@2x.png")
        XCTAssertEqual(currentWeather.conditions[0].main, "Clear")
        XCTAssertEqual(currentWeather.mainWeatherInfo.temp, 21.19)
        XCTAssertEqual(currentWeather.mainWeatherInfo.feelsLike, 21.27)
        XCTAssertEqual(currentWeather.mainWeatherInfo.tempMin, 21.19)
        XCTAssertEqual(currentWeather.mainWeatherInfo.tempMax, 22.61)
        XCTAssertEqual(currentWeather.mainWeatherInfo.pressure, 1010)
        XCTAssertEqual(currentWeather.mainWeatherInfo.humidity, 73)
        XCTAssertEqual(currentWeather.mainWeatherInfo.seaLevel, 1010)
        XCTAssertEqual(currentWeather.mainWeatherInfo.grndLevel, 1009)
        XCTAssertNil(currentWeather.mainWeatherInfo.tempKf)
        XCTAssertEqual(currentWeather.visibility, 10000)
        XCTAssertEqual(currentWeather.wind.speed, 4.12)
        XCTAssertEqual(currentWeather.wind.deg, 240)
        XCTAssertEqual(currentWeather.wind.gust, 6.26)
        XCTAssertEqual(currentWeather.rain?.the1H, 0.1)
        XCTAssertEqual(currentWeather.rain?.the3H, 0.1)
        XCTAssertEqual(currentWeather.snow?.the1H, 0.1)
        XCTAssertEqual(currentWeather.snow?.the3H, 0.1)
        XCTAssertEqual(currentWeather.clouds.all, 0)
        XCTAssertEqual(currentWeather.dt, Date(timeIntervalSince1970: 1697374381))
        XCTAssertEqual(currentWeather.sys.country, "TR")
        XCTAssertEqual(currentWeather.sys.sunrise, 1697343277)
        XCTAssertEqual(currentWeather.sys.sunset, 1697383489)
        XCTAssertEqual(currentWeather.sys.type, 1)
        XCTAssertEqual(currentWeather.sys.id, 6970)
        XCTAssertEqual(currentWeather.sys.message, "Message")
        XCTAssertEqual(currentWeather.timezone, 10800)
        XCTAssertEqual(currentWeather.cityId, 738329)
        XCTAssertEqual(currentWeather.cityName, "Uskudar")
        XCTAssertEqual(currentWeather.base, "stations")
        XCTAssertEqual(currentWeather.cod, 200)
    }
}
