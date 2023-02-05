import Foundation
import XCTest
@testable import TonTransactions

final class DeeplinkParserTests: XCTestCase {

    func testCorrectAccountDeeplinkHandlers() throws {
        let parser: DeeplinkParser = DeeplinkParserImpl()
        let parsed = parser.parse(Deeplinks.correctAccount)
        XCTAssertEqual(Deeplinks.correctAccountDeeplink, parsed)
    }
    
    func testWrongPathDeeplinkHandlers() throws {
        let parser: DeeplinkParser = DeeplinkParserImpl()
        let parsed = parser.parse(Deeplinks.notCorrectPathAccount)
        XCTAssertEqual(Deeplinks.unknownPathDeeplink, parsed)
    }
    
    func testWrongHostDeeplinkHandlers() throws {
        let parser: DeeplinkParser = DeeplinkParserImpl()
        let parsed = parser.parse(Deeplinks.notCorrectHostAccount)
        XCTAssertNil(parsed)
    }
}

private extension DeeplinkParserTests {
    enum Deeplinks {
        static let correctAccount = "tonsnow://current/account/someAccountIdentifier"
        static let notCorrectPathAccount = "tonsnow://current/other/someAccountIdentifier"
        static let notCorrectHostAccount = "tonsnow://unsuported_host/account/someAccountIdentifier"
        
        static let correctAccountDeeplink = Deeplink(host: "tonsnow", path: .account("someAccountIdentifier"))
        static let unknownPathDeeplink = Deeplink(host: "tonsnow", path: .unkonwn)
    }
    
}
