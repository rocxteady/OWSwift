//
//  Parameters.swift
//  
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation
import Combine
import ThrowPublisher

typealias Parameters = [String: Any]
typealias OptinalParameters = [String: Any?]

extension Parameters {
    @ThrowPublisher
    func createParameters() throws -> Self {
        let defaultParameters = try Constants.defaultParameters
        return defaultParameters.merging(self) { (_, new) in new }
    }
}

extension OptinalParameters {
    @ThrowPublisher
    func createParameters() throws -> Parameters{
        try self.compactMapValues { $0 }
            .createParameters()
    }
}
