import Foundation
import Moya

enum DeviceEndpoins {
    case create(deviceID: UUID, signature: String)
    
    case pushSubsribe(deviceID: UUID, token: String)
    case pushUnsubsribe(deviceID: UUID)
    case pushDisabled(deviceID: UUID)
    
    case accountSubscribe(deviceID: UUID, account: String)
    case accountUnsubscribe(deviceID: UUID, account: String)
    case accountsSubscribed(deviceID: UUID)
}

extension DeviceEndpoins: TargetType {
    var baseURL: URL {
        URL(string: "https://localhost:8080/device/")!
    }
    
    var path: String {
        switch self {
        case .create:
            return "create"
        case .accountSubscribe(let device, _), .accountUnsubscribe(let device, _), .accountsSubscribed(let device):
            return "\(device.uuidString)/watch_account"
        case .pushSubsribe(let device, _), .pushUnsubsribe(let device):
            return "\(device.uuidString)/push_token"
        case .pushDisabled(deviceID: let device):
            return "\(device.uuidString)/push_disabled"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .accountsSubscribed:
            return .get
        case .accountSubscribe, .pushSubsribe, .create, .pushDisabled:
            return .post
        case .pushUnsubsribe, .accountUnsubscribe:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .create(deviceID, signature):
            return .requestParameters(
                parameters: ["deviceID": deviceID.uuidString, "signature": signature],
                encoding: JSONEncoding.default
            )
        case .pushUnsubsribe, .accountsSubscribed, .pushDisabled:
            return .requestPlain
        case .pushSubsribe(_, let token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        case .accountSubscribe(_, let account), .accountUnsubscribe(_, let account):
            return .requestParameters(parameters: ["account": account], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
