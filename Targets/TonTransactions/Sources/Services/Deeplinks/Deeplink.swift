import Foundation

struct Deeplink {
    enum Path {
        case account(String)
        case unkonwn
    }
    
    let host: String
    let path: Path
}
