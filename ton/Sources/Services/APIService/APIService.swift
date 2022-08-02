//
//  APIService.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation
import Alamofire
import Moya

enum APIService {
    case getAddressInformation(address: TONAddress)
    case getWalletInformation(address: TONAddress)
    case getTransactions(GetTransactionRequest)
}

extension APIService: TargetType {
    var baseURL: URL {
        URL(string: "https://ton.org/")!
    }
    var path: String {
        switch self {
        case .getAddressInformation:
            return "getAddressInformation"
        case .getWalletInformation:
            return "getWalletInformation"
        case .getTransactions:
            return "getTransactions"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getAddressInformation, .getTransactions, .getWalletInformation:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getAddressInformation(let address), .getWalletInformation(let address):
            return .requestParameters(parameters: ["address": address], encoding: URLEncoding.queryString)
        case let .getTransactions(request):
            guard let params = try? request.dictionary() else {
                assertionFailure()
                return .requestJSONEncodable(request)
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String: String]? {
        nil
    }
}

fileprivate let encoderHelper = JSONEncoder()
extension Encodable {
    func data(using encoder: JSONEncoder = encoderHelper) throws -> Data { try encoder.encode(self) }
    func dictionary(using encoder: JSONEncoder = encoderHelper, options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: try data(using: encoder), options: options) as? [String: Any] ?? [:]
    }
}
