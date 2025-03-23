import ProjectDescription
import ProjectDescriptionHelpers

private let name = "MusicPlayer"

let project = Project(
    name: name,
    targets: [
        .target(
            name: name,
            destinations: [.iPhone],
            product: .app,
            bundleId: BundleId.id,
            deploymentTargets: .default,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIUserInterfaceStyle": "Light",
                ]
            ),
            sources: [.glob(.relativeToManifest("Sources/**"))],
            resources: [.glob(pattern: .relativeToManifest("Resources/**"))],
            dependencies: [
                .Service.MusicService.Interface,
                .Service.MusicService.Implement,
                .Shared.CommonExtension
            ]
        ),
    ]
)
