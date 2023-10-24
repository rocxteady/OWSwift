//
//  ParameterFailureTests.swift
//  
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift
import Combine

final class ParameterFailureTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testCreatingParametersWithPublisherFailure() throws {
        let parameters: Parameters = ["lat": 41, "lon": 29]
        let createdParameters = parameters.createParameters_publisher()

        createdParameters.sink { completion in
            switch completion {
            case .failure(let error):
                switch error {
                case OWSwiftError.notInitialized:
                    break
                default:
                    XCTFail(error.localizedDescription)
                }
            case .finished:
                XCTFail("Parameter creating should have been failed!")
            }
        } receiveValue: { _ in }.store(in: &cancellables)
    }
}
