import Foundation

enum PreparerResult {
    case success
}

enum PreparerError: Error {
    case failed
    case retryRequired
}

protocol Preparer {
    func prepare() async throws -> PreparerResult
}

final class PreparerAggregate: Preparer {
    private let items: [Preparer]
    
    init(items: [Preparer]) {
        self.items = items
    }
    
    func prepare() async -> PreparerResult {
        var retry: [Preparer] = []
        
        for item in items {
            do {
                switch try await item.prepare() {
                case .success:
                    break
                }
            }
            catch {
                guard let error = error as? PreparerError else { assertionFailure("why?"); continue }
                switch error {
                case .retryRequired:
                    retry.append(item)
                case .failed:
                    // TODO: may be log it or silent retry
                    break
                }
            }
        }
        if retry.isEmpty {
            return .success
        }
        else {
            print("before Task.sleep")
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            print("after Task.sleep")
            return await PreparerAggregate(items: retry).prepare()
        }
    }
}
