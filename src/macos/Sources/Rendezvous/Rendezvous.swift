import SwiftUI

@main
struct RendezvousApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Game") {
                    // Could trigger reset here
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}
