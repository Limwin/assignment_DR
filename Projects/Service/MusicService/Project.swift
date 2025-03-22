import ProjectDescription
import ProjectDescriptionHelpers

private enum Constants {
    static let name = "MusicService"
    
    static let interfaceName = "MusicServiceInterface"
    static let implementName = "MusicServiceImplement"
}

private let interfaceTarget = Target.target(
    name: Constants.interfaceName,
    destinations: [.iPhone],
    product: .framework,
    bundleId: BundleId.service(Constants.interfaceName),
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Interface/Sources/**"))]
)

private let inmplementTarget = Target.target(
    name: Constants.implementName,
    destinations: [.iPhone],
    product: .framework,
    bundleId: BundleId.service(Constants.implementName),
    infoPlist: .default,
    sources: [.glob(.relativeToManifest("Implement/Sources/**"))]
)

let project = Project(
    name: Constants.name,
    targets: [interfaceTarget, inmplementTarget]
)
