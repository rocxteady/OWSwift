//
//  CurrentWeatherRepoTests.swift
//
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift
import Combine

final class ClimateForecastRepoTests: XCTestCase {
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

    func testGettingClimateForecastWithAsyncAwait() async throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: ProEndpoint.climateForecast.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try ForecastResponse.mockData)
        }

        let forecastResponse = try await ClimateForecastRepo.getClimateForecast(lat: 41, lon: 29)

        testModel(forecastResponse: forecastResponse)
    }

    func testGettingClimateForecastWithPublisher() throws {
        MockedURLService.observer = { request -> (URLResponse?, Data?) in
            let response = HTTPURLResponse(url: URL(string: ProEndpoint.climateForecast.fullURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, try ForecastResponse.mockData)
        }

        let publisher: AnyPublisher<ForecastResponse, Error> = ClimateForecastRepo.getClimateForecast(lat: 41, lon: 29)

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
            } receiveValue: { [weak self] forecastResponse in
                guard let self else {
                    XCTFail("Test finished unexpectedly!")
                    return
                }
                testModel(forecastResponse: forecastResponse)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    private func testModel(forecastResponse: ForecastResponse) {
        XCTAssertEqual(forecastResponse.cnt, 40)
        XCTAssertEqual(forecastResponse.list[0].dt, 1661871600)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.temp, 296.76)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.feelsLike, 296.98)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.tempMin, 296.76)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.tempMax, 297.87)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.pressure, 1015)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.humidity, 69)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.seaLevel, 1015)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.grndLevel, 933)
        XCTAssertEqual(forecastResponse.list[0].mainWeatherInfo.tempKf, -1.11)
        XCTAssertEqual(forecastResponse.list[0].conditions[0].id, 500)
        XCTAssertEqual(forecastResponse.list[0].conditions[0].main, "Rain")
        XCTAssertEqual(forecastResponse.list[0].conditions[0].description, "light rain")
        XCTAssertEqual(forecastResponse.list[0].conditions[0].icon, "10d")
        XCTAssertEqual(forecastResponse.list[0].conditions[0].iconURL, "https://openweathermap.org/img/wn/10d@2x.png")
        XCTAssertEqual(forecastResponse.list[0].clouds.all, 100)
        XCTAssertEqual(forecastResponse.list[0].wind.speed, 0.62)
        XCTAssertEqual(forecastResponse.list[0].wind.deg, 349)
        XCTAssertEqual(forecastResponse.list[0].wind.gust, 1.18)
        XCTAssertEqual(forecastResponse.list[0].visibility, 10000)
        XCTAssertEqual(forecastResponse.list[0].pop, 0.32)
        XCTAssertEqual(forecastResponse.list[0].rain?.the1H, 0.1)
        XCTAssertEqual(forecastResponse.list[0].rain?.the3H, 0.26)
        XCTAssertEqual(forecastResponse.list[0].snow?.the1H, 0.2)
        XCTAssertEqual(forecastResponse.list[0].snow?.the3H, 0.3)
        XCTAssertEqual(forecastResponse.list[0].sys.pod, .day)
        XCTAssertEqual(forecastResponse.list[0].dtTxt, "2022-08-30 15:00:00")
        XCTAssertEqual(forecastResponse.city.id, 3163858)
        XCTAssertEqual(forecastResponse.city.name, "Zocca")
        XCTAssertEqual(forecastResponse.city.coord.lon, 10.99)
        XCTAssertEqual(forecastResponse.city.coord.lat, 44.34)
        XCTAssertEqual(forecastResponse.city.country, "IT")
        XCTAssertEqual(forecastResponse.city.population, 4593)
        XCTAssertEqual(forecastResponse.city.timezone, 7200)
        XCTAssertEqual(forecastResponse.city.sunrise, 1661834187)
        XCTAssertEqual(forecastResponse.city.sunset, 1661882248)
        XCTAssertEqual(forecastResponse.cod, "200")
        XCTAssertEqual(forecastResponse.message, 0)
    }
}
