import Foundation
import SwiftKeychainWrapper

enum Device {
    static var identifier: UUID {
        if let deviceIDString = KeychainWrapper.standard.string(forKey: deviceIDKey),
           let deviceID = UUID(uuidString: deviceIDString) {
            return deviceID
        }
        else {
            let deviceID = UUID()
            KeychainWrapper.standard.set(deviceID.uuidString, forKey: deviceIDKey, withAccessibility: .always)
            return deviceID
        }
    }
    
    static var signature: String {
        if let signatureString = KeychainWrapper.standard.string(forKey: signatureKey) {
            assert(signatureString.count == 128)
            return signatureString
        }
        else {
            let signature = String.random(of: 128)
            KeychainWrapper.standard.set(signature, forKey: signatureKey, withAccessibility: .always)
            return signature
        }
    }
}


private let deviceIDKey = "TT_device_id"
private let signatureKey = "TT_header_signature"

extension String {
   static func random(of n: Int) -> String {
      let availableChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      return String(Array(0..<n).map { _ in availableChars.randomElement()! })
   }
}
