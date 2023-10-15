//
//  Parameters.swift
//  
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation
import Combine

typealias Parameters = [String: Any]

extension Parameters {
    func createParameters() throws -> [String: Any] {
        let defaultParameters = try Constants.defaultParameters
        return defaultParameters.merging(self) { (_, new) in new }
    }

    func createParametersWithPublisher() -> Future<Self, Error> {
        Future { promise in
            do {
                let parameters: Self = try createParameters()
                promise(.success(parameters))
            } catch {
                promise(.failure(error))
            }
        }
    }
}
