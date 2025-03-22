import ProjectDescription
import ProjectDescriptionHelpers

private let name = "Storage"

private let target = Target.target(
    name: name,
    destinations: [.iPhone],
    product: .framework,
    bundleId: "\(BundleId.id).\(name)",
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Sources/**"))]
)

let project = Project(
    name: name,
    targets: [target]
)
