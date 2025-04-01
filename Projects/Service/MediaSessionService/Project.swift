import ProjectDescription
import ProjectDescriptionHelpers

private enum Constants {
    static let name = "MediaSessionService"
    
    static let interfaceName = "MediaSessionServiceInterface"
    static let implementName = "MediaSessionServiceImplement"
}

private let interfaceTarget = Target.target(
    name: Constants.interfaceName,
    destinations: [.iPhone],
    product: .framework,
    bundleId: BundleId.service(Constants.interfaceName),
    deploymentTargets: .default,
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Interface/Sources/**"))]
)

private let implementTarget = Target.target(
    name: Constants.implementName,
    destinations: [.iPhone],
    product: .framework,
    bundleId: BundleId.service(Constants.implementName),
    deploymentTargets: .default,
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Implement/Sources/**"))],
    dependencies: [
        .Service.MediaSessionService.Interface
    ]
)

let project = Project(
    name: Constants.name,
    targets: [interfaceTarget, implementTarget]
)
