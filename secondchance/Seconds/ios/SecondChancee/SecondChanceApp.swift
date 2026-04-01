import SwiftUI

@main
struct SecondChanceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .errorModal()
        }
    }
}
