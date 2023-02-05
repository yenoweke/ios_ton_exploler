import Foundation

public enum ListState<Element: Identifiable> {
    case idle
    case initialLoading
    case loadingNextPage(current: [Element])
    case loaded(current: [Element], hasNextPage: Bool)
    case initialLoadingError(Error)
    case loadNextPageError(current: [Element], Error)
    
    public var elements: [Element] {
        switch self {
        case .loadingNextPage(let current), .loaded(let current, _), .loadNextPageError(let current, _):
            return current
        case .idle, .initialLoading, .initialLoadingError:
            return []
        }
    }
    
    public var isIdle: Bool {
        switch self {
        case .idle: return true
        default: return false
        }
    }

    public var isInitialLoadingError: Bool {
        switch self {
        case .initialLoadingError: return true
        default: return false
        }
    }

    public var initialLoading: Bool {
        switch self {
        case .initialLoading: return true
        default: return false
        }
    }
    
    public var isLoadingNextPageError: Bool {
        switch self {
        case .loadNextPageError: return true
        default: return false
        }
    }
    
    public var loadingNextPage: Bool {
        switch self {
        case .loadingNextPage: return true
        default: return false
        }
    }
    
    public var hasNextPage: Bool {
        switch self {
        case .loaded(_, let hasNextPage): return hasNextPage
        default: return false
        }
    }
    
    public mutating func initiallyLoaded(_ elements: [Element], hasNextPage: Bool) {
        self = .loaded(current: elements, hasNextPage: hasNextPage)
    }
    
    public mutating func initiallLoadError(_ error: Error) {
        self = .initialLoadingError(error)
    }
    
    public mutating func nextPageLoading() {
        self = .loadingNextPage(current: self.elements)
    }
    
    public mutating func nextPageLoaded(_ elements: [Element], hasNextPage: Bool) {
        self = .loaded(current: elements, hasNextPage: hasNextPage)
    }
    
    public mutating func nextPageLoadingError(_ error: Error) {
        self = .loadNextPageError(current: self.elements, error)
    }
}
