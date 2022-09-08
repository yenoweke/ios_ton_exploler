//
//  TransactionsDomainPlugin.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 15.06.2022.
//

import Moya
import Foundation

struct TransactionsDomainPlugin: PluginType {
    private let domain: () -> String // = { "https://toncenter.com/api/v2/" }  //"https://api.ton.cat/v2/explorer/" } //
    
    init(domain: @escaping () -> String) {
        self.domain = domain
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let urlString = request.url?.absoluteString
                .replacingOccurrences(of: target.baseURL.absoluteString, with: domain()) else {
            return request
        }
        var request = request
        request.url = URL(string: urlString)
        return request
    }
}
