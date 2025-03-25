import SwiftUI

@main
struct MusicPlayerApp: App {
    private let appDependency = AppDependency()
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                LibraryView(viewModel: self.appDependency.makeLibraryViewModel())
                self.playerView
            }
            .environmentObject(self.appDependency.makeMusicPlayerState())
        }
    }
    
    @ViewBuilder
    private var playerView: some View {
        MusicPlayerView()
            .background(.white)
            .transition(.move(edge: .bottom))
    }
}
