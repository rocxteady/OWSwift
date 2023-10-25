//
//  File.swift
//  
//
//  Created by Ulaş Sancak on 20.10.2023.
//

import Foundation
@testable import OWSwift

extension RoadRisk {
    static var mockData: Data {
        get throws {
            guard let url = Bundle.module.url(forResource: "RoadRisk", withExtension: "json") else {
                throw MockError.fileNotFound("RoadRisk.json")
            }
            let data = try Data(contentsOf: url)
            return data
        }
    }
}
