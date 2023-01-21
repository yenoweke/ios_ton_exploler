import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    public enum TargetTypeToGenerate {
        case name(String, dependencies: [TargetDependency])
    }
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [TargetTypeToGenerate], dependencies: [TargetDependency]) -> Project {
        
        let appDep: [TargetDependency] = additionalTargets.map { type in
            switch type {
            case .name(let name, _):
                return TargetDependency.target(name: name)
            }
        }
        
        
        var targets = makeAppTargets(name: name, platform: platform, dependencies: appDep + dependencies)
        targets += additionalTargets.flatMap({ type -> [Target] in
            switch type {
            case .name(let name, let dependencies):
                return makeFrameworkTargets(name: name, platform: platform, dependencies: dependencies)
            }
        })
        
        let settings = ProjectDescription.Settings.settings(
            configurations: [
                .release(name: "Release", xcconfig: .relativeToRoot("xcconfigs/Release.xcconfig")),
                .debug(name: "Debug", xcconfig: .relativeToRoot("xcconfigs/Debug.xcconfig"))
            ]
        )
        return Project(name: name,
                       organizationName: "dmitri.space",
                       settings: settings,
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        
        
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "space.dmitrii.\(name)",
                deploymentTarget: .iOS(targetVersion: "15.1", devices: .iphone),
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: dependencies
        )
        
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "space.dmitrii.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        
        let urlType: InfoPlist.Value = .dictionary([
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["tonsnow"]
        ])
        
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
            "TONCENTER_API_KEY": "$(TONCENTER_API_KEY)",
            "TT_BACKEND_URL": "$(TT_BACKEND_URL)",
            "ITSAppUsesNonExemptEncryption": .boolean(false),
            "CFBundleURLTypes": .array([urlType])
        ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "space.dmitrii.ton",
            deploymentTarget: .iOS(targetVersion: "15.1", devices: .iphone),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**", "Targets/\(name)/Generated/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )
        return [mainTarget]
    }
}
