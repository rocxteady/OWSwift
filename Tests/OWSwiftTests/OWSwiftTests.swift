import XCTest
@testable import OWSwift

final class OWSwiftTests: XCTestCase {
    override func tearDownWithError() throws {
        OWSwift.deIitialize()
    }

    func testInitialization() throws {
        let apiKey = "hjdf87238jfhjhsh838hsjjdf83ıjdha"
        OWSwift.initialize(with: apiKey)
        let initializedApiKey = try OWSwift.apiKey
        XCTAssertEqual(apiKey, initializedApiKey)
    }

    func testNil() throws {
        do {
            _ = try OWSwift.apiKey
            XCTFail("OWSwift actually not initialized. This hould have been failed!")
        } catch OWSwiftError.notInitialized {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEmpty() {
        OWSwift.initialize(with: "")
        do {
            _ = try OWSwift.apiKey
            XCTFail("OWSwift actually initialized as empty. This hould have been failed!")
        } catch OWSwiftError.notInitialized {
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testErrors() {
        let notInitialized = OWSwiftError.notInitialized
        XCTAssertNotNil(notInitialized.errorDescription, "OWSwiftError description should not be nil!")
    }
}
