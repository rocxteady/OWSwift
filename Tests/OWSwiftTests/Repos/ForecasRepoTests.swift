//
//  CurrentWeatherRepoTests.swift
//
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift
import Combine

final class ForecasRepoTests: XCTestCase {
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

    func testGetting5DayForecastWithAsyncAwait() async throws {
        try await testWithAsyncAwait(endpoint: .forecast)
    }

    func testGetting5DayForecastWithPublisher() throws {
        try testWithPublisher(endpoint: .forecast)
    }

    func testGettingDailyForecastWithAsyncAwait() async throws {
        try await testWithAsyncAwait(endpoint: .dailyForecast)
    }

    func testGettingDailyForecastWithPublisher() throws {
        try testWithPublisher(endpoint: .dailyForecast)
    }

    func testGettingHourlyForecastWithAsyncAwait() async throws {
        try await testWithAsyncAwait(endpoint: .hourlyForecast)
    }

    func testGettingHourlyForecastWithPublisher() throws {
        try testWithPublisher(endpoint: .hourlyForecast)
    }

    private func testWithAsyncAwait(endpoint: Endpoint) async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: Endpoint.forecast.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try ForecastResponse.mockData)
        }

        let forecastResponseFromData: ForecastResponse?
        switch endpoint {
        case .forecast:
            forecastResponseFromData = try await ForecastRepo.get5DayForecast(lat: 41, lon: 29)
        case .dailyForecast:
            forecastResponseFromData = try await ForecastRepo.getDailyForecast(lat: 41, lon: 29)
        case .hourlyForecast:
            forecastResponseFromData = try await ForecastRepo.getHourlyForecast(lat: 41, lon: 29)
        default:
            forecastResponseFromData = nil
        }

        if let forecastResponseFromData {
            let forecastResponse = ForecastResponse.mock
            testModels(fromData: forecastResponseFromData, fromMock: forecastResponse)
        } else {
            XCTFail("forecastResponseFromData is nil!. Check the endpoint!")
        }
    }

    private func testWithPublisher(endpoint: Endpoint) throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: Endpoint.forecast.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try ForecastResponse.mockData)
        }

        let publisher: AnyPublisher<ForecastResponse, Error>?

        switch endpoint {
        case .forecast:
            publisher = ForecastRepo.get5DayForecast(lat: 41, lon: 29)
        case .dailyForecast:
            publisher = ForecastRepo.getDailyForecast(lat: 41, lon: 29)
        case .hourlyForecast:
            publisher = ForecastRepo.getHourlyForecast(lat: 41, lon: 29)
        default:
            publisher = nil
        }

        if let publisher {
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
                } receiveValue: { [weak self] forecastResponseFromData in
                    guard let self else {
                        XCTFail("Test finished unexpectedly!")
                        return
                    }
                    let forecastResponse = ForecastResponse.mock
                    testModels(fromData: forecastResponseFromData, fromMock: forecastResponse)
                }
                .store(in: &cancellables)

            waitForExpectations(timeout: 0.1)
        } else {
            XCTFail("publisher is nil!. Check the endpoint!")
        }
    }

    private func testModels(fromData: ForecastResponse, fromMock: ForecastResponse) {
        XCTAssertEqual(fromMock.cnt, fromData.cnt)
        XCTAssertEqual(fromMock.cod, fromData.cod)
        XCTAssertEqual(fromMock.message, fromData.message)
        XCTAssertEqual(fromMock.city.country, fromData.city.country)
        XCTAssertEqual(fromMock.city.id, fromData.city.id)
        XCTAssertEqual(fromMock.city.name, fromData.city.name)
        XCTAssertEqual(fromMock.city.population, fromData.city.population)
        XCTAssertEqual(fromMock.city.sunrise, fromData.city.sunrise)
        XCTAssertEqual(fromMock.city.sunset, fromData.city.sunset)
        XCTAssertEqual(fromMock.city.timezone, fromData.city.timezone)
        XCTAssertEqual(fromMock.city.coord.lat, fromData.city.coord.lat)
        XCTAssertEqual(fromMock.city.coord.lon, fromData.city.coord.lon)
        XCTAssertEqual(fromMock.list[0].dt, fromData.list[0].dt)
        XCTAssertEqual(fromMock.list[0].dtTxt, fromData.list[0].dtTxt)
        XCTAssertEqual(fromMock.list[0].pop, fromData.list[0].pop)
        XCTAssertEqual(fromMock.list[0].visibility, fromData.list[0].visibility)
        XCTAssertEqual(fromMock.list[0].clouds.all, fromData.list[0].clouds.all)
        XCTAssertEqual(fromMock.list[0].conditions[0].icon, fromData.list[0].conditions[0].icon)
        XCTAssertEqual(fromMock.list[0].conditions[0].iconURL, fromData.list[0].conditions[0].iconURL)
        XCTAssertEqual(fromMock.list[0].conditions[0].id, fromData.list[0].conditions[0].id)
        XCTAssertEqual(fromMock.list[0].conditions[0].main, fromData.list[0].conditions[0].main)
        XCTAssertEqual(fromMock.list[0].conditions[0].description, fromData.list[0].conditions[0].description)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.feelsLike, fromData.list[0].mainWeatherInfo.feelsLike)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.grndLevel, fromData.list[0].mainWeatherInfo.grndLevel)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.humidity, fromData.list[0].mainWeatherInfo.humidity)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.pressure, fromData.list[0].mainWeatherInfo.pressure)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.seaLevel, fromData.list[0].mainWeatherInfo.seaLevel)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.temp, fromData.list[0].mainWeatherInfo.temp)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.tempMax, fromData.list[0].mainWeatherInfo.tempMax)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.tempMin, fromData.list[0].mainWeatherInfo.tempMin)
        XCTAssertEqual(fromMock.list[0].mainWeatherInfo.tempKf, fromData.list[0].mainWeatherInfo.tempKf)
        XCTAssertEqual(fromMock.list[0].rain?.the1H, fromData.list[0].rain?.the1H)
        XCTAssertEqual(fromMock.list[0].rain?.the3H, fromData.list[0].rain?.the3H)
        XCTAssertEqual(fromMock.list[0].snow?.the1H, fromData.list[0].snow?.the1H)
        XCTAssertEqual(fromMock.list[0].snow?.the3H, fromData.list[0].snow?.the3H)
        XCTAssertEqual(fromMock.list[0].sys.pod, fromData.list[0].sys.pod)
        XCTAssertEqual(fromMock.list[0].wind.deg, fromData.list[0].wind.deg)
        XCTAssertEqual(fromMock.list[0].wind.gust, fromData.list[0].wind.gust)
        XCTAssertEqual(fromMock.list[0].wind.speed, fromData.list[0].wind.speed)
    }
}
