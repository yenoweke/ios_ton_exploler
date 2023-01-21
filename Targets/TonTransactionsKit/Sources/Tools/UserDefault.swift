import Foundation

@propertyWrapper
public struct UserDefault<T: Equatable>: Equatable {
    public static func == (lhs: UserDefault<T>, rhs: UserDefault<T>) -> Bool {
        guard lhs.defaultValue == rhs.defaultValue else { return false }
        guard lhs.key == rhs.key else { return false }
        return true
    }
    
    private let key: UserDefaultKey
    private let defaultValue: T

    public var wrappedValue: T {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T ?? self.defaultValue }
        nonmutating set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }

    public init(_ key: UserDefaultKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

public struct UserDefaultKey: RawRepresentable {
    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension UserDefaultKey: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}
//
//import Foundation
//
//@propertyWrapper
//public struct UserDefaultArray<T: Equatable>: Equatable {
//    public static func == (lhs: UserDefaultArray<T>, rhs: UserDefaultArray<T>) -> Bool {
//        guard lhs.defaultValue == rhs.defaultValue else { return false }
//        guard lhs.key == rhs.key else { return false }
//        return true
//    }
//    
//    private let key: UserDefaultKey
//    private let defaultValue: [T]
//
//    public var wrappedValue: [T] {
//        get { UserDefaults.standard.array(forKey: key.rawValue) as? [T] ?? self.defaultValue }
//        nonmutating set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
//    }
//
//    public init(_ key: UserDefaultKey, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//}
