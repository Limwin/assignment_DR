import ProjectDescription
import ProjectDescriptionHelpers

private let name = "Storage"

private let target = Target.target(
    name: name,
    destinations: [.iPhone],
    product: .framework,
    bundleId: "\(BundleId.id).\(name)",
    deploymentTargets: .default,
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Sources/**"))],
    resources: [.glob(pattern: .relativeToManifest("Resources/**"))]
)

let project = Project(
    name: name,
    targets: [target]
)
