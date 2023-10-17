//
//  VolumeLast.swift
//  
//
//  Created by Ulaş Sancak on 16.10.2023.
//

import Foundation

public struct VolumeLast: Codable {
    public let the1H: Double?
    public let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}
