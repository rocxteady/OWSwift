//
//  File.swift
//  
//
//  Created by Ulaş Sancak on 17.10.2023.
//

import Foundation

extension Int {
    var date: Date {
        .init(timeIntervalSince1970: .init(self))
    }
}
