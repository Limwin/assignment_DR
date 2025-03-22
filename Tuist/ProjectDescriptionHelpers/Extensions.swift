import ProjectDescription

public enum BundleId {
    public static let id = "com.dr.MusicPlayer"
    
    public static func shared(_ name: String) -> String {
        "\(Self.id).shared.\(name)"
    }
    
    public static func service(_ name: String) -> String {
        "\(Self.id).service.\(name)"
    }
}

extension Path {
    static func relativeToProject(_ path: String) -> Path {
        .relativeToRoot("Projects/\(path)")
    }
    
    static func relativeToShared(_ path: String) -> Path {
        .relativeToProject("Shared/\(path)")
    }
    
    static func relativeToService(_ path: String) -> Path {
        .relativeToProject("Service/\(path)")
    }
}

public extension TargetDependency {
    
    static let Storage = TargetDependency.project(
        target: "Storage",
        path: .relativeToProject("Storage")
    )
    
    enum Shared {
        public static let CommonExtension = TargetDependency.project(
            target: "CommonExtension",
            path: .relativeToShared("CommonExtension")
        )
    }
    
    enum Service {
        public enum MusicService {
            public static let Interface = TargetDependency.project(
                target: "MusicServiceInterface",
                path: .relativeToService("MusicService")
            )
            public static let Implement = TargetDependency.project(
                target: "MusicServiceImplement",
                path: .relativeToService("MusicService")
            )
        }
    }
}
