import Foundation

public struct APIBaseInfoProvider {
    let baseURL: String
    let headers: [String: String]
    
    init(baseURL: String, headers: [String: String]) {
        self.baseURL = baseURL
        self.headers = headers
    }
}

public extension APIBaseInfoProvider {
    static func toncenter(apiKey: String) -> APIBaseInfoProvider {
        APIBaseInfoProvider(
            baseURL: "https://toncenter.com/api/v2/",
            headers: ["X-API-Key": apiKey]
        )
    }
    
    static func ttBackend(baseURL: String, signature: String?) -> APIBaseInfoProvider {
        var headers: [String: String] = [:]
        if let signature = signature {
            headers["X-TT-Signature"] = signature
        }
        return APIBaseInfoProvider(
            baseURL: baseURL,
            headers: headers
        )
    }
}
