import Foundation
import Moya

class BaseService<Endpoint: TargetType> {
    private let provider: MoyaProvider<Endpoint>
    
    public init(plugins: [PluginType]) {
        self.provider = MoyaProvider<Endpoint>(plugins: plugins)
    }

    internal func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Response, Error>) in
            self.provider.request(endpoint) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let response = try moyaResponse.filterSuccessfulStatusCodes()
                        let data: Response
                        if response.data.isEmpty, Response.self == EmptyResponse.self {
                            data = EmptyResponse() as! Response
                        }
                        else {
                            data = try response.map(Response.self)
                        }
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    internal func request(_ endpoint: Endpoint) async throws {
        let _: EmptyResponse = try await request(endpoint)
    }
}

struct EmptyResponse: Decodable {
}
