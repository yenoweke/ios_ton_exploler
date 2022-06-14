//
// Created by Dmitrii Chikovinskii on 10.06.2022.
//

import Foundation
import Moya

class APIHeadersPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        assertionFailure("insert api token or remove line")
        request.addValue("", forHTTPHeaderField: "X-API-Key")
        return request
    }
}
