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
            Splash()
        }
    }
}
struct AppInit_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
