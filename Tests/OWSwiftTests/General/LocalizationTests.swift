//
//  LocalizationTests.swift
//  
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import XCTest
@testable import OWSwift

final class LocalizationTests: XCTestCase {
    func testLocalizations() {
        let locales = ["en", "tr"]
        for locale in locales {
            guard let path = Bundle.module.path(forResource: locale, ofType: "lproj"),
                let bundle = Bundle(path: path) else {
                    XCTFail("Missing localization for \(locale)"); return
            }

            let OWSwiftErrorNotInitialized = bundle.localizedString(forKey: "OWSwiftError.notInitialized", value: nil, table: nil)

            XCTAssertFalse(OWSwiftErrorNotInitialized.isEmpty)
            XCTAssertNotEqual(OWSwiftErrorNotInitialized, "OWSwiftError.notInitialized", "OWSwiftError.notInitialized failed for \(locale)")
        }
    }
}
