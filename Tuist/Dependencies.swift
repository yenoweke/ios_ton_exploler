import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.0")),
        .remote(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", requirement: .upToNextMajor(from: "4.0.1")),
    ],
    platforms: [.iOS]
)
