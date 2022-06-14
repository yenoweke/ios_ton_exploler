//
//  InputAddressError.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import Foundation

enum InputAddressError: LocalizedError {
    case addressIsNotValid
    
    var errorDescription: String? {
        switch self {
        case .addressIsNotValid:
            return L10n.InputAddress.Error.isNotValid
        }
    }
}
