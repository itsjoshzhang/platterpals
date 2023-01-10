import SwiftUI
import Firebase

@main
struct AppInit: App {
    
    init() {
        FirebaseApp.configure()
        UIView.appearance().tintColor = .systemPink
    }
    var body: some Scene {
        WindowGroup {
            //Users()
            Splash()
        }
    }
}
