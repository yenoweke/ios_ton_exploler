import Foundation

public struct Deeplink: Equatable {
    public enum Path: Equatable {
        case account(String)
        case unkonwn
    }
    
    let host: String
    public let path: Path
}
