import SwiftUI

@main
struct MusicPlayerApp: App {
    private let appDependency = AppDependency()
    private var musicPlayerState = MusicPlayerState()
    
    var body: some Scene {
        WindowGroup {
            LibraryView(viewModel: self.appDependency.makeLibraryViewModel())
                .environmentObject(self.musicPlayerState)
        }
    }
}
