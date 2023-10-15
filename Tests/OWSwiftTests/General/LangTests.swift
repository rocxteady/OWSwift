//
//  LangTests.swift
//
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift

final class LangTests: XCTestCase {
    func testLangs() throws {
        Locale.availableIdentifiers.forEach {
            let locale = Locale(identifier: $0)
            XCTAssertNotNil(locale.lang)
        }
    }
}
