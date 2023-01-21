//
// Created by Dmitrii Chikovinskii on 10.06.2022.
//

import Foundation
import Moya

final class HeadersPlugin: PluginType {
    private let headers: [String: String]
    
    public init(headers: [String: String]) {
        self.headers = headers
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        self.headers.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
