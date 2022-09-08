import Foundation
import XCTest
@testable import TTAPIService

final class TonTransactionsKitTests: XCTestCase {
    let service = TonService()
    let walletAddress = TONAddress(stringLiteral: "EQBDanbCeUqI4_v-xrnAN0_I2wRvEIaLg1Qg2ZN5c6Zl1KOh")
    
    func test_fetchAddressInformation() async throws {
        let response = try await self.service.fetchAddressInformation(self.walletAddress)
        XCTAssertTrue(response.ok)
    }
}
