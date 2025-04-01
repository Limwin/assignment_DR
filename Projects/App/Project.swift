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
                    "UIBackgroundModes": ["audio"],
                    "NSAppleMusicUsageDescription": "이 앱은 Apple Music의 음악을 재생합니다."
                ]
            ),
            sources: [.glob(.relativeToManifest("Sources/**"))],
            resources: [.glob(pattern: .relativeToManifest("Resources/**"))],
            dependencies: [
                .Service.MusicService.Interface,
                .Service.MusicService.Implement,
                .Service.MediaPlayerService.Interface,
                .Service.MediaPlayerService.Implement,
                .Service.MediaSessionService.Interface,
                .Service.MediaSessionService.Implement,
                .Shared.CommonExtension
            ]
        ),
    ]
)
