//
//  ListState.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

enum ListState<Element: Identifiable> {
    case idle
    case initialLoading
    case loadingNextPage(current: [Element])
    case loaded(current: [Element], hasNextPage: Bool)
    case initialLoadingError(Error)
    case loadNextPageError(current: [Element], Error)
    
    var elements: [Element] {
        switch self {
        case .loadingNextPage(let current), .loaded(let current, _), .loadNextPageError(let current, _):
            return current
        case .idle, .initialLoading, .initialLoadingError:
            return []
        }
    }
    
    var isIdle: Bool {
        switch self {
        case .idle: return true
        default: return false
        }
    }

    var isInitialLoadingError: Bool {
        switch self {
        case .initialLoadingError: return true
        default: return false
        }
    }

    var initialLoading: Bool {
        switch self {
        case .initialLoading: return true
        default: return false
        }
    }
    
    var isLoadingNextPageError: Bool {
        switch self {
        case .loadNextPageError: return true
        default: return false
        }
    }
    
    var loadingNextPage: Bool {
        switch self {
        case .loadingNextPage: return true
        default: return false
        }
    }
    
    var hasNextPage: Bool {
        switch self {
        case .loaded(_, let hasNextPage): return hasNextPage
        default: return false
        }
    }
    
    mutating func initiallyLoaded(_ elements: [Element], hasNextPage: Bool) {
        self = .loaded(current: elements, hasNextPage: hasNextPage)
    }
    
    mutating func initiallLoadError(_ error: Error) {
        self = .initialLoadingError(error)
    }
    
    mutating func nextPageLoading() {
        self = .loadingNextPage(current: self.elements)
    }
    
    mutating func nextPageLoaded(_ elements: [Element], hasNextPage: Bool) {
        self = .loaded(current: self.elements + elements, hasNextPage: hasNextPage)
    }
    
    mutating func nextPageLoadingError(_ error: Error) {
        self = .loadNextPageError(current: self.elements, error)
    }
}
