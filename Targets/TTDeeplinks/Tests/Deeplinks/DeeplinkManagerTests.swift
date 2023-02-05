import Foundation
import XCTest
@testable import TonTransactions

final class DeeplinkManagerTests: XCTestCase {

    func testEmptyHandlers() throws {
        let parser = DeeplinkParserMock()
        let manager: DeeplinkManager = DeeplinkManagerImpl(parser: parser)
        let handled = manager.handle(Deeplinks.correctAccount)
        XCTAssertFalse(handled)
    }
    
    func testNoHandler() throws {
        let parser = DeeplinkParserMock()
        let manager: DeeplinkManager = DeeplinkManagerImpl(parser: parser)
        let handled = manager.handle(Deeplinks.correctAccount)
        let handler = FalseHandlerMock()
        manager.add(handler: handler)

        XCTAssertFalse(handled)
    }
    
    func testAccountHandler() throws {
        let parser = DeeplinkParserMock()
        let manager: DeeplinkManager = DeeplinkManagerImpl(parser: parser)
        let falseHandler = FalseHandlerMock()
        let accountHandler = AccountHandlerMock()
        
        manager.add(handler: falseHandler)
        manager.add(handler: accountHandler)
        
        let correctHandled = manager.handle(Deeplinks.correctAccount)
        XCTAssertTrue(correctHandled)
        XCTAssertEqual(accountHandler.accountID, "someAccountIdentifier")
        
        let wrongPathHandled = manager.handle(Deeplinks.notCorrectPathAccount)
        XCTAssertFalse(wrongPathHandled)
        
        let wrongHostHandled = manager.handle(Deeplinks.notCorrectHostAccount)
        XCTAssertFalse(wrongHostHandled)
    }
    
    func testAccountHandlerRemove() throws {
        let parser = DeeplinkParserMock()
        let manager: DeeplinkManager = DeeplinkManagerImpl(parser: parser)
        let falseHandler = FalseHandlerMock()
        let accountHandler = AccountHandlerMock()
        
        manager.add(handler: falseHandler)
        manager.add(handler: accountHandler)
        
        let correctHandled = manager.handle(Deeplinks.correctAccount)
        XCTAssertTrue(correctHandled)
        XCTAssertEqual(accountHandler.accountID, "someAccountIdentifier")
        
        manager.remove(handler: accountHandler)
        let afterRemoveHandled = manager.handle(Deeplinks.correctAccount)
        XCTAssertFalse(afterRemoveHandled)
    }
    
    func testHandleURL() throws {
        let parser = DeeplinkParserMock()
        let manager: DeeplinkManager = DeeplinkManagerImpl(parser: parser)
        let handler = AccountHandlerMock()
        manager.add(handler: handler)
        
        let handled = manager.handle(URL(string: Deeplinks.correctAccount)!)
        XCTAssertTrue(handled)
    }
}

private extension DeeplinkManagerTests {
    enum Deeplinks {
        static let correctAccount = "tonsnow://current/account/someAccountIdentifier"
        static let notCorrectPathAccount = "tonsnow://current/other/someAccountIdentifier"
        static let notCorrectHostAccount = "tonsnow://unsuported_host/account/someAccountIdentifier"
    }
    
    struct DeeplinkParserMock: DeeplinkParser {
        func parse(_ url: URL) -> TonTransactions.Deeplink? {
            return parse(url.absoluteString)
        }
        
        func parse(_ urlString: String) -> Deeplink? {
            if urlString == "tonsnow://current/account/someAccountIdentifier" {
                return Deeplink(host: "tonsnow", path: .account("someAccountIdentifier"))
            }
            return nil
        }
    }
    
    class FalseHandlerMock: DeeplinkHandler {
        func handle(_ deeplink: Deeplink) -> Bool {
            return false
        }
    }
    
    class AccountHandlerMock: DeeplinkHandler {
        var accountID: String?
        
        func handle(_ deeplink: Deeplink) -> Bool {
            switch deeplink.path {
            case .account(let id):
                self.accountID = id
                return true
            case .unkonwn:
                return false
            }
            
        }
    }
    
}
