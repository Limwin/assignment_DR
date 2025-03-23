import ProjectDescription
import ProjectDescriptionHelpers

private let name = "CommonExtension"

private let target = Target.target(
    name: name,
    destinations: [.iPhone],
    product: .framework,
    bundleId: BundleId.shared(name),
    deploymentTargets: .default,
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Sources/**"))]
)

let project = Project(
    name: name,
    targets: [target]
)
