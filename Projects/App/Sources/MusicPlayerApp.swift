import SwiftUI

@main
struct MusicPlayerApp: App {
    private let container = AppDependency()
    
    var body: some Scene {
        WindowGroup {
            LibrarayView(viewModel: self.container.makeLibraryViewModel())
        }
    }
}
