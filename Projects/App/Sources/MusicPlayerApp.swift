import SwiftUI

@main
struct MusicPlayerApp: App {
    private let container = AppDependency()
    
    var body: some Scene {
        WindowGroup {
            LibraryView(viewModel: self.container.makeLibraryViewModel())
        }
    }
}
