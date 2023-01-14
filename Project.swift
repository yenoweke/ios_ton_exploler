import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains TonTransactions App target and TonTransactions unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(
    name: "TonTransactions",
    platform: .iOS,
    additionalTargets: [
        .name(
            "TonTransactionsKit",
            dependencies: []
        ),
        .name(
            "TonTransactionsUI",
            dependencies: []
        ),
        .name(
            "TTAPIService",
            dependencies: [
                .external(name: "Moya"),
                .target(name: "TonTransactionsKit")
            ]
        )
    ],
    dependencies: [
        .external(name: "SwiftKeychainWrapper")
    ]
)

